-- =============================================================================
-- Commit 4: Yemen Validation Dataset — Committees, Applications, Reviews
-- Generated: 2026-07-06
-- Total committees: 8 | Total committee members: 60 | Total applications: 100
-- Requirements: Business Realism, Workflow Compliance, Data Quality
-- =============================================================================

BEGIN;

SET session_replication_role = 'replica';

SELECT set_config('app.user_id', '1', true);

-- Reset sequences
SELECT setval('committee.committees_id_seq', COALESCE((SELECT MAX(id) FROM committee.committees), 0) + 1, false);
SELECT setval('committee.committee_members_id_seq', COALESCE((SELECT MAX(id) FROM committee.committee_members), 0) + 1, false);
SELECT setval('core.applications_id_seq', COALESCE((SELECT MAX(id) FROM core.applications), 0) + 1, false);
SELECT setval('core.application_history_id_seq', COALESCE((SELECT MAX(id) FROM core.application_history), 0) + 1, false);
SELECT setval('workflow.workflow_instances_id_seq', COALESCE((SELECT MAX(id) FROM workflow.workflow_instances), 0) + 1, false);
SELECT setval('workflow.workflow_actions_id_seq', COALESCE((SELECT MAX(id) FROM workflow.workflow_actions), 0) + 1, false);
SELECT setval('committee.review_assignments_id_seq', COALESCE((SELECT MAX(id) FROM committee.review_assignments), 0) + 1, false);
SELECT setval('committee.scientific_reviews_id_seq', COALESCE((SELECT MAX(id) FROM committee.scientific_reviews), 0) + 1, false);
SELECT setval('committee.ethics_reviews_id_seq', COALESCE((SELECT MAX(id) FROM committee.ethics_reviews), 0) + 1, false);
SELECT setval('committee.application_conditions_id_seq', COALESCE((SELECT MAX(id) FROM committee.application_conditions), 0) + 1, false);
SELECT setval('core.application_amendments_id_seq', COALESCE((SELECT MAX(id) FROM core.application_amendments), 0) + 1, false);

-- =============================================================================
-- COMMITTEES
-- =============================================================================
-- Committee: National Medical Ethics Committee (NMEC_YE)
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active, created_by)
SELECT 2, 'NMEC_YE', 'اللجنة الوطنية للأخلاقيات الطبية', 'National Medical Ethics Committee', 1, '2020-01-15', true, 1
WHERE NOT EXISTS (SELECT 1 FROM committee.committees WHERE committee_code = 'NMEC_YE');
-- Committee: Sana'a University Research Ethics Committee (SUREC_31)
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active, created_by)
SELECT 31, 'SUREC_31', 'لجنة أخلاقيات البحث بجامعة صنعاء', 'Sana''a University Research Ethics Committee', 4, '2020-06-01', true, 1
WHERE NOT EXISTS (SELECT 1 FROM committee.committees WHERE committee_code = 'SUREC_31');
-- Committee: Aden University Research Ethics Committee (AUREC_32)
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active, created_by)
SELECT 32, 'AUREC_32', 'لجنة أخلاقيات البحث بجامعة عدن', 'Aden University Research Ethics Committee', 4, '2020-09-15', true, 1
WHERE NOT EXISTS (SELECT 1 FROM committee.committees WHERE committee_code = 'AUREC_32');
-- Committee: National Biosafety Committee (NBC_YE)
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active, created_by)
SELECT 3, 'NBC_YE', 'اللجنة الوطنية للسلامة الحيوية', 'National Biosafety Committee', 3, '2021-01-10', true, 1
WHERE NOT EXISTS (SELECT 1 FROM committee.committees WHERE committee_code = 'NBC_YE');
-- Committee: Sana'a Teaching Hospital Ethics Committee (SHEC_26)
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active, created_by)
SELECT 26, 'SHEC_26', 'لجنة أخلاقيات مستشفى صنعاء التعليمي', 'Sana''a Teaching Hospital Ethics Committee', 1, '2021-03-20', true, 1
WHERE NOT EXISTS (SELECT 1 FROM committee.committees WHERE committee_code = 'SHEC_26');
-- Committee: Taiz Research Committee (TRC_33)
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active, created_by)
SELECT 33, 'TRC_33', 'لجنة أبحاث تعز', 'Taiz Research Committee', 4, '2021-06-05', true, 1
WHERE NOT EXISTS (SELECT 1 FROM committee.committees WHERE committee_code = 'TRC_33');
-- Committee: National Scientific Review Board (NSRB_4)
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active, created_by)
SELECT 4, 'NSRB_4', 'مجلس المراجعة العلمية الوطني', 'National Scientific Review Board', 5, '2021-09-01', true, 1
WHERE NOT EXISTS (SELECT 1 FROM committee.committees WHERE committee_code = 'NSRB_4');
-- Committee: National Research Council (NRC_YE)
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active, created_by)
SELECT 2, 'NRC_YE', 'المجلس الوطني للبحوث', 'National Research Council', 8, '2022-01-01', true, 1
WHERE NOT EXISTS (SELECT 1 FROM committee.committees WHERE committee_code = 'NRC_YE');
-- =============================================================================
-- COMMITTEE MEMBERS
-- =============================================================================
-- Format: committee_code, user_id, role_code, start_date, end_date
-- Chairs (6-10), Members (11-56), Ethics Admins as Secretaries (2-5)
-- Distributed unevenly across committees (workload variation)
--
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 6, '2020-01-15', '2025-12-31', true, 1, 1
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 6);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 2, '2020-01-15', NULL, true, 2, 1
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 2);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 11, '2020-03-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 11);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 12, '2020-03-01', '2025-12-31', true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 12);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 13, '2021-01-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 13);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 14, '2021-06-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 14);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 15, '2022-01-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 15);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 8, '2020-06-01', NULL, true, 1, 1
FROM committee.committees c WHERE c.committee_code = 'SUREC_31'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 8);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 16, '2020-06-01', NULL, true, 2, 1
FROM committee.committees c WHERE c.committee_code = 'SUREC_31'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 16);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 17, '2020-07-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'SUREC_31'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 17);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 18, '2020-07-01', '2025-06-30', true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'SUREC_31'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 18);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 19, '2021-01-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'SUREC_31'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 19);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 20, '2022-01-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'SUREC_31'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 20);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 9, '2020-09-15', NULL, true, 1, 1
FROM committee.committees c WHERE c.committee_code = 'AUREC_32'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 9);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 21, '2020-09-15', NULL, true, 2, 1
FROM committee.committees c WHERE c.committee_code = 'AUREC_32'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 21);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 22, '2020-10-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'AUREC_32'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 22);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 23, '2020-10-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'AUREC_32'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 23);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 24, '2021-03-01', '2025-12-31', true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'AUREC_32'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 24);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 25, '2022-01-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'AUREC_32'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 25);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 7, '2021-01-10', NULL, true, 1, 1
FROM committee.committees c WHERE c.committee_code = 'NBC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 7);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 26, '2021-01-10', NULL, true, 2, 1
FROM committee.committees c WHERE c.committee_code = 'NBC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 26);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 27, '2021-02-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NBC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 27);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 28, '2021-02-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NBC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 28);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 29, '2021-06-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NBC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 29);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 6, '2021-03-20', NULL, true, 1, 1
FROM committee.committees c WHERE c.committee_code = 'SHEC_26'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 6);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 30, '2021-03-20', NULL, true, 2, 1
FROM committee.committees c WHERE c.committee_code = 'SHEC_26'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 30);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 31, '2021-04-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'SHEC_26'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 31);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 32, '2021-04-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'SHEC_26'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 32);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 33, '2021-07-01', '2025-12-31', true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'SHEC_26'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 33);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 34, '2022-01-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'SHEC_26'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 34);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 10, '2021-06-05', NULL, true, 1, 1
FROM committee.committees c WHERE c.committee_code = 'TRC_33'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 10);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 35, '2021-06-05', NULL, true, 2, 1
FROM committee.committees c WHERE c.committee_code = 'TRC_33'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 35);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 36, '2021-07-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'TRC_33'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 36);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 37, '2021-07-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'TRC_33'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 37);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 38, '2022-01-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'TRC_33'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 38);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 8, '2021-09-01', NULL, true, 1, 1
FROM committee.committees c WHERE c.committee_code = 'NSRB_4'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 8);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 39, '2021-09-01', NULL, true, 2, 1
FROM committee.committees c WHERE c.committee_code = 'NSRB_4'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 39);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 40, '2021-10-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NSRB_4'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 40);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 41, '2021-10-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NSRB_4'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 41);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 42, '2022-01-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NSRB_4'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 42);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 9, '2022-01-01', NULL, true, 1, 1
FROM committee.committees c WHERE c.committee_code = 'NRC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 9);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 43, '2022-01-01', NULL, true, 2, 1
FROM committee.committees c WHERE c.committee_code = 'NRC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 43);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 44, '2022-02-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NRC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 44);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 45, '2022-02-01', '2025-12-31', true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NRC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 45);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 46, '2023-01-01', NULL, true, 3, 1
FROM committee.committees c WHERE c.committee_code = 'NRC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 46);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 3, '2020-01-15', NULL, true, 4, 1
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 3);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 4, '2020-06-01', NULL, true, 4, 1
FROM committee.committees c WHERE c.committee_code = 'SUREC_31'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 4);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 5, '2020-09-15', NULL, true, 4, 1
FROM committee.committees c WHERE c.committee_code = 'AUREC_32'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 5);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 3, '2021-01-10', NULL, true, 4, 1
FROM committee.committees c WHERE c.committee_code = 'NBC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 3);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 4, '2021-03-20', NULL, true, 4, 1
FROM committee.committees c WHERE c.committee_code = 'SHEC_26'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 4);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 5, '2021-06-05', NULL, true, 4, 1
FROM committee.committees c WHERE c.committee_code = 'TRC_33'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 5);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 2, '2021-09-01', NULL, true, 4, 1
FROM committee.committees c WHERE c.committee_code = 'NSRB_4'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 2);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 2, '2022-01-01', NULL, true, 4, 1
FROM committee.committees c WHERE c.committee_code = 'NRC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 2);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 47, '2022-01-01', NULL, true, 5, 1
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 47);
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, 48, '2022-01-01', NULL, true, 5, 1
FROM committee.committees c WHERE c.committee_code = 'NRC_YE'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = 48);
-- =============================================================================
-- APPLICATIONS
-- =============================================================================
-- Each application is linked to an existing project.
-- Applications are distributed across 14 workflow states with realistic
-- transition histories and committee assignments.
-- =============================================================================
-- Application 1: Project 190 → ARCHIVED (ARCHIVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  190,
  'APP-2025-001002',
  'NEW',
  'ARCHIVED',
  (created_at + interval '6 days'),
  65,
  'NORMAL',
  c.id,
  'Application archived',
  1,
  '2025-01-16 00:00:00+03'::timestamptz,
  '2025-01-16 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 2: Project 191 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  191,
  'APP-2025-001003',
  'NEW',
  'CLOSED',
  (created_at + interval '5 days'),
  66,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2025-01-19 00:00:00+03'::timestamptz,
  '2025-01-19 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 3: Project 192 → ETHICAL_REVIEW (ETHICAL_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  192,
  'APP-2025-001004',
  'NEW',
  'ETHICAL_REVIEW',
  (created_at + interval '4 days'),
  67,
  'NORMAL',
  c.id,
  'Application under ethical review',
  1,
  '2025-01-22 00:00:00+03'::timestamptz,
  '2025-01-22 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 4: Project 193 → INITIAL_REVIEW (INITIAL_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  193,
  'APP-2025-001005',
  'NEW',
  'INITIAL_REVIEW',
  (created_at + interval '8 days'),
  67,
  'NORMAL',
  c.id,
  'Application under initial review',
  1,
  '2025-01-17 00:00:00+03'::timestamptz,
  '2025-01-17 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 5: Project 194 → WITHDRAWN (WITHDRAWN_DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  194,
  'APP-2025-001006',
  'NEW',
  'WITHDRAWN',
  (created_at + interval '12 days'),
  68,
  'NORMAL',
  c.id,
  'Application withdrawn by applicant',
  1,
  '2025-01-21 00:00:00+03'::timestamptz,
  '2025-01-21 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 6: Project 195 → ETHICAL_REVIEW (ETHICAL_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  195,
  'APP-2025-001007',
  'NEW',
  'ETHICAL_REVIEW',
  (created_at + interval '5 days'),
  69,
  'NORMAL',
  c.id,
  'Application under ethical review',
  1,
  '2025-01-18 00:00:00+03'::timestamptz,
  '2025-01-18 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 7: Project 196 → SUBMITTED (SUBMITTED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  196,
  'APP-2025-001008',
  'NEW',
  'SUBMITTED',
  (created_at + interval '9 days'),
  69,
  'NORMAL',
  c.id,
  'Application submitted and under review',
  1,
  '2025-01-26 00:00:00+03'::timestamptz,
  '2025-01-26 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 8: Project 197 → ARCHIVED (ARCHIVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  197,
  'APP-2025-001009',
  'NEW',
  'ARCHIVED',
  (created_at + interval '3 days'),
  70,
  'NORMAL',
  c.id,
  'Application archived',
  1,
  '2025-01-22 00:00:00+03'::timestamptz,
  '2025-01-22 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 9: Project 198 → APPROVED (SHORT_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  198,
  'APP-2025-001010',
  'NEW',
  'APPROVED',
  (created_at + interval '4 days'),
  71,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2025-01-25 00:00:00+03'::timestamptz,
  '2025-01-25 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 10: Project 199 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  199,
  'APP-2025-001011',
  'NEW',
  'CLOSED',
  (created_at + interval '4 days'),
  71,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2025-01-19 00:00:00+03'::timestamptz,
  '2025-01-19 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 11: Project 200 → REJECTED (REJECTED_SUBMIT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  200,
  'APP-2025-001012',
  'NEW',
  'REJECTED',
  (created_at + interval '3 days'),
  72,
  'HIGH',
  c.id,
  'Application has been rejected',
  1,
  '2025-01-22 00:00:00+03'::timestamptz,
  '2025-01-22 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE';
-- Application 12: Project 201 → ARCHIVED (ARCHIVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  201,
  'APP-2025-001013',
  'NEW',
  'ARCHIVED',
  (created_at + interval '1 days'),
  73,
  'NORMAL',
  c.id,
  'Application archived',
  1,
  '2025-01-27 00:00:00+03'::timestamptz,
  '2025-01-27 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 13: Project 202 → APPROVED (SHORT_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  202,
  'APP-2025-001014',
  'NEW',
  'APPROVED',
  (created_at + interval '3 days'),
  73,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2025-01-27 00:00:00+03'::timestamptz,
  '2025-01-27 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 14: Project 203 → COMMITTEE_REVIEW (COMMITTEE_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  203,
  'APP-2025-001015',
  'NEW',
  'COMMITTEE_REVIEW',
  (created_at + interval '4 days'),
  74,
  'HIGH',
  c.id,
  'Application under committee review',
  1,
  '2025-01-27 00:00:00+03'::timestamptz,
  '2025-01-27 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE';
-- Application 15: Project 204 → DRAFT (DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  204,
  'APP-2025-001016',
  'NEW',
  'DRAFT',
  NULL,
  NULL,
  'NORMAL',
  c.id,
  'Draft application not yet submitted',
  1,
  '2025-01-22 00:00:00+03'::timestamptz,
  '2025-01-22 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 16: Project 205 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  205,
  'APP-2025-001017',
  'NEW',
  'APPROVED',
  (created_at + interval '9 days'),
  75,
  'HIGH',
  c.id,
  'Application has been approved',
  1,
  '2025-01-26 00:00:00+03'::timestamptz,
  '2025-01-26 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 17: Project 206 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  206,
  'APP-2025-001018',
  'NEW',
  'CLOSED',
  (created_at + interval '8 days'),
  76,
  'HIGH',
  c.id,
  'Application closed after completion',
  1,
  '2025-01-21 00:00:00+03'::timestamptz,
  '2025-01-21 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE';
-- Application 18: Project 207 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  207,
  'APP-2025-001019',
  'NEW',
  'APPROVED',
  (created_at + interval '4 days'),
  77,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2025-01-30 00:00:00+03'::timestamptz,
  '2025-01-30 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 19: Project 208 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  208,
  'APP-2025-001020',
  'NEW',
  'CLOSED',
  (created_at + interval '8 days'),
  77,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2025-01-25 00:00:00+03'::timestamptz,
  '2025-01-25 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 20: Project 209 → APPROVED (SHORT_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  209,
  'APP-2025-001021',
  'NEW',
  'APPROVED',
  (created_at + interval '11 days'),
  78,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2025-01-30 00:00:00+03'::timestamptz,
  '2025-01-30 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 21: Project 210 → ETHICAL_REVIEW (ETHICAL_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  210,
  'APP-2025-001022',
  'NEW',
  'ETHICAL_REVIEW',
  (created_at + interval '12 days'),
  79,
  'NORMAL',
  c.id,
  'Application under ethical review',
  1,
  '2025-01-30 00:00:00+03'::timestamptz,
  '2025-01-30 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 22: Project 211 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  211,
  'APP-2025-001023',
  'NEW',
  'APPROVED',
  (created_at + interval '5 days'),
  79,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2025-01-30 00:00:00+03'::timestamptz,
  '2025-01-30 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 23: Project 212 → SUBMITTED (SUBMITTED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  212,
  'APP-2025-001024',
  'NEW',
  'SUBMITTED',
  (created_at + interval '6 days'),
  80,
  'NORMAL',
  c.id,
  'Application submitted and under review',
  1,
  '2025-01-26 00:00:00+03'::timestamptz,
  '2025-01-26 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 24: Project 213 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  213,
  'APP-2025-001025',
  'NEW',
  'CLOSED',
  (created_at + interval '4 days'),
  81,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2025-01-30 00:00:00+03'::timestamptz,
  '2025-01-30 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SHEC_26';
-- Application 25: Project 214 → WITHDRAWN (WITHDRAWN_SUBMITTED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  214,
  'APP-2025-001026',
  'NEW',
  'WITHDRAWN',
  (created_at + interval '2 days'),
  81,
  'NORMAL',
  c.id,
  'Application withdrawn by applicant',
  1,
  '2025-01-31 00:00:00+03'::timestamptz,
  '2025-01-31 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SHEC_26';
-- Application 26: Project 215 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  215,
  'APP-2025-001027',
  'NEW',
  'APPROVED',
  (created_at + interval '11 days'),
  82,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2025-01-28 00:00:00+03'::timestamptz,
  '2025-01-28 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SHEC_26';
-- Application 27: Project 216 → APPROVED (SHORT_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  216,
  'APP-2025-001028',
  'NEW',
  'APPROVED',
  (created_at + interval '4 days'),
  83,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2025-01-28 00:00:00+03'::timestamptz,
  '2025-01-28 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 28: Project 217 → SCIENTIFIC_REVIEW (SCIENTIFIC_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  217,
  'APP-2025-001029',
  'NEW',
  'SCIENTIFIC_REVIEW',
  (created_at + interval '13 days'),
  83,
  'NORMAL',
  c.id,
  'Application under scientific review',
  1,
  '2025-02-01 00:00:00+03'::timestamptz,
  '2025-02-01 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 29: Project 218 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  218,
  'APP-2026-001030',
  'NEW',
  'APPROVED',
  (created_at + interval '3 days'),
  84,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-01-25 00:00:00+03'::timestamptz,
  '2026-01-25 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 30: Project 219 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  219,
  'APP-2026-001031',
  'NEW',
  'CLOSED',
  (created_at + interval '13 days'),
  85,
  'HIGH',
  c.id,
  'Application closed after completion',
  1,
  '2026-01-25 00:00:00+03'::timestamptz,
  '2026-01-25 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE';
-- Application 31: Project 220 → DRAFT (DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  220,
  'APP-2026-001032',
  'NEW',
  'DRAFT',
  NULL,
  NULL,
  'NORMAL',
  c.id,
  'Draft application not yet submitted',
  1,
  '2026-01-26 00:00:00+03'::timestamptz,
  '2026-01-26 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 32: Project 221 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  221,
  'APP-2026-001033',
  'NEW',
  'CLOSED',
  (created_at + interval '11 days'),
  85,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2026-01-23 00:00:00+03'::timestamptz,
  '2026-01-23 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 33: Project 222 → WITHDRAWN (WITHDRAWN_DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  222,
  'APP-2026-001034',
  'NEW',
  'WITHDRAWN',
  (created_at + interval '1 days'),
  85,
  'NORMAL',
  c.id,
  'Application withdrawn by applicant',
  1,
  '2026-01-30 00:00:00+03'::timestamptz,
  '2026-01-30 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 34: Project 223 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  223,
  'APP-2026-001035',
  'NEW',
  'CLOSED',
  (created_at + interval '9 days'),
  86,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2026-01-22 00:00:00+03'::timestamptz,
  '2026-01-22 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 35: Project 224 → COMMITTEE_REVIEW (COMMITTEE_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  224,
  'APP-2026-001036',
  'NEW',
  'COMMITTEE_REVIEW',
  (created_at + interval '12 days'),
  86,
  'HIGH',
  c.id,
  'Application under committee review',
  1,
  '2026-01-27 00:00:00+03'::timestamptz,
  '2026-01-27 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE';
-- Application 36: Project 225 → SUBMITTED (SUBMITTED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  225,
  'APP-2026-001037',
  'NEW',
  'SUBMITTED',
  (created_at + interval '5 days'),
  86,
  'NORMAL',
  c.id,
  'Application submitted and under review',
  1,
  '2026-01-24 00:00:00+03'::timestamptz,
  '2026-01-24 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 37: Project 226 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  226,
  'APP-2026-001038',
  'NEW',
  'APPROVED',
  (created_at + interval '2 days'),
  87,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-01-22 00:00:00+03'::timestamptz,
  '2026-01-22 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 38: Project 227 → SUBMITTED (SUBMITTED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  227,
  'APP-2026-001039',
  'NEW',
  'SUBMITTED',
  (created_at + interval '5 days'),
  87,
  'NORMAL',
  c.id,
  'Application submitted and under review',
  1,
  '2026-01-25 00:00:00+03'::timestamptz,
  '2026-01-25 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 39: Project 228 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  228,
  'APP-2026-001040',
  'NEW',
  'CLOSED',
  (created_at + interval '2 days'),
  87,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2026-01-25 00:00:00+03'::timestamptz,
  '2026-01-25 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 40: Project 229 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  229,
  'APP-2026-001041',
  'NEW',
  'CLOSED',
  (created_at + interval '12 days'),
  87,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2026-01-28 00:00:00+03'::timestamptz,
  '2026-01-28 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 41: Project 230 → ARCHIVED (ARCHIVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  230,
  'APP-2026-001042',
  'NEW',
  'ARCHIVED',
  (created_at + interval '8 days'),
  87,
  'NORMAL',
  c.id,
  'Application archived',
  1,
  '2026-01-30 00:00:00+03'::timestamptz,
  '2026-01-30 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 42: Project 231 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  231,
  'APP-2026-001043',
  'NEW',
  'APPROVED',
  (created_at + interval '6 days'),
  88,
  'HIGH',
  c.id,
  'Application has been approved',
  1,
  '2026-01-26 00:00:00+03'::timestamptz,
  '2026-01-26 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 43: Project 232 → WITHDRAWN (WITHDRAWN_SUBMITTED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  232,
  'APP-2026-001044',
  'NEW',
  'WITHDRAWN',
  (created_at + interval '7 days'),
  88,
  'HIGH',
  c.id,
  'Application withdrawn by applicant',
  1,
  '2026-02-01 00:00:00+03'::timestamptz,
  '2026-02-01 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE';
-- Application 44: Project 233 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  233,
  'APP-2026-001045',
  'NEW',
  'APPROVED',
  (created_at + interval '1 days'),
  88,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-01-28 00:00:00+03'::timestamptz,
  '2026-01-28 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 45: Project 234 → SCIENTIFIC_REVIEW (SCIENTIFIC_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  234,
  'APP-2026-001046',
  'NEW',
  'SCIENTIFIC_REVIEW',
  (created_at + interval '2 days'),
  88,
  'NORMAL',
  c.id,
  'Application under scientific review',
  1,
  '2026-01-27 00:00:00+03'::timestamptz,
  '2026-01-27 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 46: Project 235 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  235,
  'APP-2026-001047',
  'NEW',
  'APPROVED',
  (created_at + interval '2 days'),
  89,
  'HIGH',
  c.id,
  'Application has been approved',
  1,
  '2026-01-28 00:00:00+03'::timestamptz,
  '2026-01-28 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'AUREC_32';
-- Application 47: Project 236 → DRAFT (DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  236,
  'APP-2026-001048',
  'NEW',
  'DRAFT',
  NULL,
  NULL,
  'NORMAL',
  c.id,
  'Draft application not yet submitted',
  1,
  '2026-01-26 00:00:00+03'::timestamptz,
  '2026-01-26 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'AUREC_32';
-- Application 48: Project 237 → SCIENTIFIC_REVIEW (SCIENTIFIC_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  237,
  'APP-2026-001049',
  'NEW',
  'SCIENTIFIC_REVIEW',
  (created_at + interval '1 days'),
  89,
  'NORMAL',
  c.id,
  'Application under scientific review',
  1,
  '2026-01-28 00:00:00+03'::timestamptz,
  '2026-01-28 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'AUREC_32';
-- Application 49: Project 238 → DRAFT (DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  238,
  'APP-2026-001050',
  'NEW',
  'DRAFT',
  NULL,
  NULL,
  'HIGH',
  c.id,
  'Draft application not yet submitted',
  1,
  '2026-01-28 00:00:00+03'::timestamptz,
  '2026-01-28 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE';
-- Application 50: Project 239 → APPROVED (SHORT_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  239,
  'APP-2026-001051',
  'NEW',
  'APPROVED',
  (created_at + interval '10 days'),
  90,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-01-29 00:00:00+03'::timestamptz,
  '2026-01-29 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'TRC_33';
-- Application 51: Project 240 → ETHICAL_REVIEW (ETHICAL_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  240,
  'APP-2026-001052',
  'NEW',
  'ETHICAL_REVIEW',
  (created_at + interval '12 days'),
  90,
  'NORMAL',
  c.id,
  'Application under ethical review',
  1,
  '2026-01-27 00:00:00+03'::timestamptz,
  '2026-01-27 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'TRC_33';
-- Application 52: Project 241 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  241,
  'APP-2026-001053',
  'NEW',
  'APPROVED',
  (created_at + interval '4 days'),
  90,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-02-01 00:00:00+03'::timestamptz,
  '2026-02-01 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'TRC_33';
-- Application 53: Project 242 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  242,
  'APP-2026-001054',
  'NEW',
  'CLOSED',
  (created_at + interval '9 days'),
  90,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2026-01-29 00:00:00+03'::timestamptz,
  '2026-01-29 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'TRC_33';
-- Application 54: Project 243 → SCIENTIFIC_REVIEW (SCIENTIFIC_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  243,
  'APP-2026-001055',
  'NEW',
  'SCIENTIFIC_REVIEW',
  (created_at + interval '10 days'),
  91,
  'HIGH',
  c.id,
  'Application under scientific review',
  1,
  '2026-02-06 00:00:00+03'::timestamptz,
  '2026-02-06 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 55: Project 244 → REJECTED (RETURNED_REJECTED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  244,
  'APP-2026-001056',
  'NEW',
  'REJECTED',
  (created_at + interval '9 days'),
  91,
  'HIGH',
  c.id,
  'Application has been rejected',
  1,
  '2026-02-04 00:00:00+03'::timestamptz,
  '2026-02-04 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 56: Project 245 → REJECTED (REJECTED_INITIAL)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  245,
  'APP-2026-001057',
  'NEW',
  'REJECTED',
  (created_at + interval '13 days'),
  91,
  'HIGH',
  c.id,
  'Application has been rejected',
  1,
  '2026-02-03 00:00:00+03'::timestamptz,
  '2026-02-03 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE';
-- Application 57: Project 246 → ETHICAL_REVIEW (ETHICAL_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  246,
  'APP-2026-001058',
  'NEW',
  'ETHICAL_REVIEW',
  (created_at + interval '2 days'),
  91,
  'NORMAL',
  c.id,
  'Application under ethical review',
  1,
  '2026-01-31 00:00:00+03'::timestamptz,
  '2026-01-31 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 58: Project 247 → ARCHIVED (ARCHIVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  247,
  'APP-2026-001059',
  'NEW',
  'ARCHIVED',
  (created_at + interval '11 days'),
  92,
  'NORMAL',
  c.id,
  'Application archived',
  1,
  '2026-02-06 00:00:00+03'::timestamptz,
  '2026-02-06 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 59: Project 248 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  248,
  'APP-2026-001060',
  'NEW',
  'CLOSED',
  (created_at + interval '5 days'),
  92,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2026-02-02 00:00:00+03'::timestamptz,
  '2026-02-02 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 60: Project 249 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  249,
  'APP-2026-001061',
  'NEW',
  'APPROVED',
  (created_at + interval '13 days'),
  92,
  'HIGH',
  c.id,
  'Application has been approved',
  1,
  '2026-02-05 00:00:00+03'::timestamptz,
  '2026-02-05 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 61: Project 250 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  250,
  'APP-2026-001062',
  'NEW',
  'CLOSED',
  (created_at + interval '6 days'),
  93,
  'HIGH',
  c.id,
  'Application closed after completion',
  1,
  '2026-02-05 00:00:00+03'::timestamptz,
  '2026-02-05 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 62: Project 251 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  251,
  'APP-2026-001063',
  'NEW',
  'APPROVED',
  (created_at + interval '10 days'),
  93,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-02-02 00:00:00+03'::timestamptz,
  '2026-02-02 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 63: Project 252 → DRAFT (DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  252,
  'APP-2026-001064',
  'NEW',
  'DRAFT',
  NULL,
  NULL,
  'NORMAL',
  c.id,
  'Draft application not yet submitted',
  1,
  '2026-02-02 00:00:00+03'::timestamptz,
  '2026-02-02 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 64: Project 253 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  253,
  'APP-2026-001065',
  'NEW',
  'APPROVED',
  (created_at + interval '9 days'),
  93,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-02-02 00:00:00+03'::timestamptz,
  '2026-02-02 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 65: Project 254 → DRAFT (DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  254,
  'APP-2026-001066',
  'NEW',
  'DRAFT',
  NULL,
  NULL,
  'NORMAL',
  c.id,
  'Draft application not yet submitted',
  1,
  '2026-02-01 00:00:00+03'::timestamptz,
  '2026-02-01 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 66: Project 255 → SUBMITTED (SUBMITTED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  255,
  'APP-2026-001067',
  'NEW',
  'SUBMITTED',
  (created_at + interval '5 days'),
  93,
  'NORMAL',
  c.id,
  'Application submitted and under review',
  1,
  '2026-02-05 00:00:00+03'::timestamptz,
  '2026-02-05 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 67: Project 256 → DRAFT (DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  256,
  'APP-2026-001068',
  'NEW',
  'DRAFT',
  NULL,
  NULL,
  'HIGH',
  c.id,
  'Draft application not yet submitted',
  1,
  '2026-02-04 00:00:00+03'::timestamptz,
  '2026-02-04 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE';
-- Application 68: Project 257 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  257,
  'APP-2026-001069',
  'NEW',
  'CLOSED',
  (created_at + interval '7 days'),
  94,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2026-02-07 00:00:00+03'::timestamptz,
  '2026-02-07 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 69: Project 258 → CLOSED (CONDITIONS_MET)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  258,
  'APP-2026-001070',
  'NEW',
  'CLOSED',
  (created_at + interval '5 days'),
  94,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2026-02-08 00:00:00+03'::timestamptz,
  '2026-02-08 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 70: Project 259 → APPROVED (SHORT_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  259,
  'APP-2026-001071',
  'NEW',
  'APPROVED',
  (created_at + interval '13 days'),
  94,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-02-09 00:00:00+03'::timestamptz,
  '2026-02-09 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 71: Project 260 → SCIENTIFIC_REVIEW (SCIENTIFIC_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  260,
  'APP-2026-001072',
  'NEW',
  'SCIENTIFIC_REVIEW',
  (created_at + interval '9 days'),
  94,
  'NORMAL',
  c.id,
  'Application under scientific review',
  1,
  '2026-02-09 00:00:00+03'::timestamptz,
  '2026-02-09 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 72: Project 261 → DRAFT (DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  261,
  'APP-2026-001073',
  'NEW',
  'DRAFT',
  NULL,
  NULL,
  'NORMAL',
  c.id,
  'Draft application not yet submitted',
  1,
  '2026-02-06 00:00:00+03'::timestamptz,
  '2026-02-06 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 73: Project 262 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  262,
  'APP-2026-001074',
  'NEW',
  'CLOSED',
  (created_at + interval '7 days'),
  94,
  'HIGH',
  c.id,
  'Application closed after completion',
  1,
  '2026-02-04 00:00:00+03'::timestamptz,
  '2026-02-04 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 74: Project 263 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  263,
  'APP-2026-001075',
  'NEW',
  'APPROVED',
  (created_at + interval '1 days'),
  95,
  'HIGH',
  c.id,
  'Application has been approved',
  1,
  '2026-02-07 00:00:00+03'::timestamptz,
  '2026-02-07 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 75: Project 264 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  264,
  'APP-2026-001076',
  'NEW',
  'CLOSED',
  (created_at + interval '5 days'),
  95,
  'HIGH',
  c.id,
  'Application closed after completion',
  1,
  '2026-02-07 00:00:00+03'::timestamptz,
  '2026-02-07 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE';
-- Application 76: Project 265 → DRAFT (DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  265,
  'APP-2026-001077',
  'NEW',
  'DRAFT',
  NULL,
  NULL,
  'NORMAL',
  c.id,
  'Draft application not yet submitted',
  1,
  '2026-02-05 00:00:00+03'::timestamptz,
  '2026-02-05 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 77: Project 266 → SCIENTIFIC_REVIEW (SCIENTIFIC_REVIEW)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  266,
  'APP-2026-001078',
  'NEW',
  'SCIENTIFIC_REVIEW',
  (created_at + interval '8 days'),
  95,
  'NORMAL',
  c.id,
  'Application under scientific review',
  1,
  '2026-02-13 00:00:00+03'::timestamptz,
  '2026-02-13 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 78: Project 267 → SUBMITTED (SUBMITTED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  267,
  'APP-2026-001079',
  'NEW',
  'SUBMITTED',
  (created_at + interval '3 days'),
  95,
  'NORMAL',
  c.id,
  'Application submitted and under review',
  1,
  '2026-02-14 00:00:00+03'::timestamptz,
  '2026-02-14 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 79: Project 268 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  268,
  'APP-2026-001080',
  'NEW',
  'APPROVED',
  (created_at + interval '5 days'),
  95,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-02-10 00:00:00+03'::timestamptz,
  '2026-02-10 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 80: Project 269 → APPROVED (SHORT_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  269,
  'APP-2026-001081',
  'NEW',
  'APPROVED',
  (created_at + interval '7 days'),
  95,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-02-14 00:00:00+03'::timestamptz,
  '2026-02-14 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 81: Project 270 → SUBMITTED (SUBMITTED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  270,
  'APP-2026-001082',
  'NEW',
  'SUBMITTED',
  (created_at + interval '12 days'),
  95,
  'NORMAL',
  c.id,
  'Application submitted and under review',
  1,
  '2026-02-10 00:00:00+03'::timestamptz,
  '2026-02-10 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 82: Project 271 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  271,
  'APP-2026-001083',
  'NEW',
  'APPROVED',
  (created_at + interval '4 days'),
  96,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-02-12 00:00:00+03'::timestamptz,
  '2026-02-12 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 83: Project 272 → APPROVED (RETURNED_ETHICAL)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  272,
  'APP-2026-001084',
  'NEW',
  'APPROVED',
  (created_at + interval '12 days'),
  96,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-02-06 00:00:00+03'::timestamptz,
  '2026-02-06 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 84: Project 273 → RETURNED (RETURNED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  273,
  'APP-2026-001085',
  'NEW',
  'RETURNED',
  (created_at + interval '10 days'),
  96,
  'NORMAL',
  c.id,
  'Application returned for revision',
  1,
  '2026-02-14 00:00:00+03'::timestamptz,
  '2026-02-14 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 85: Project 274 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  274,
  'APP-2026-001086',
  'NEW',
  'CLOSED',
  (created_at + interval '11 days'),
  96,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2026-02-09 00:00:00+03'::timestamptz,
  '2026-02-09 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 86: Project 275 → SUBMITTED (SUBMITTED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  275,
  'APP-2026-001087',
  'NEW',
  'SUBMITTED',
  (created_at + interval '10 days'),
  96,
  'NORMAL',
  c.id,
  'Application submitted and under review',
  1,
  '2026-02-15 00:00:00+03'::timestamptz,
  '2026-02-15 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 87: Project 276 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  276,
  'APP-2026-001088',
  'NEW',
  'CLOSED',
  (created_at + interval '13 days'),
  96,
  'NORMAL',
  c.id,
  'Application closed after completion',
  1,
  '2026-02-15 00:00:00+03'::timestamptz,
  '2026-02-15 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 88: Project 277 → APPROVED (FULL_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  277,
  'APP-2026-001089',
  'NEW',
  'APPROVED',
  (created_at + interval '13 days'),
  2,
  'HIGH',
  c.id,
  'Application has been approved',
  1,
  '2026-02-16 00:00:00+03'::timestamptz,
  '2026-02-16 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE';
-- Application 89: Project 278 → DRAFT (DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  278,
  'APP-2026-001090',
  'NEW',
  'DRAFT',
  NULL,
  NULL,
  'HIGH',
  c.id,
  'Draft application not yet submitted',
  1,
  '2026-02-12 00:00:00+03'::timestamptz,
  '2026-02-12 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 90: Project 279 → DRAFT (DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  279,
  'APP-2026-001091',
  'NEW',
  'DRAFT',
  NULL,
  NULL,
  'NORMAL',
  c.id,
  'Draft application not yet submitted',
  1,
  '2026-02-18 00:00:00+03'::timestamptz,
  '2026-02-18 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 91: Project 280 → APPROVED (SHORT_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  280,
  'APP-2026-001092',
  'NEW',
  'APPROVED',
  (created_at + interval '5 days'),
  6,
  'NORMAL',
  c.id,
  'Application has been approved',
  1,
  '2026-02-09 00:00:00+03'::timestamptz,
  '2026-02-09 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 92: Project 281 → WITHDRAWN (WITHDRAWN_DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  281,
  'APP-2026-001093',
  'NEW',
  'WITHDRAWN',
  (created_at + interval '11 days'),
  7,
  'NORMAL',
  c.id,
  'Application withdrawn by applicant',
  1,
  '2026-02-14 00:00:00+03'::timestamptz,
  '2026-02-14 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 93: Project 282 → WITHDRAWN (WITHDRAWN_DRAFT)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  282,
  'APP-2026-001094',
  'NEW',
  'WITHDRAWN',
  (created_at + interval '4 days'),
  7,
  'NORMAL',
  c.id,
  'Application withdrawn by applicant',
  1,
  '2026-02-13 00:00:00+03'::timestamptz,
  '2026-02-13 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 94: Project 205 → APPROVED (RETURNED_APPROVED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  205,
  'APP-2026-001095',
  'AMENDMENT',
  'APPROVED',
  (created_at + interval '9 days'),
  75,
  'HIGH',
  c.id,
  'Amendment: Application has been approved',
  75,
  '2026-02-14 00:00:00+03'::timestamptz,
  '2026-02-14 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 95: Project 249 → CLOSED (EVIDENCE_FIXED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  249,
  'APP-2026-001096',
  'AMENDMENT',
  'CLOSED',
  (created_at + interval '12 days'),
  92,
  'HIGH',
  c.id,
  'Amendment: Application closed after completion',
  92,
  '2026-02-10 00:00:00+03'::timestamptz,
  '2026-02-10 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 96: Project 207 → CLOSED (CONDITIONS_MET)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  207,
  'APP-2026-001097',
  'AMENDMENT',
  'CLOSED',
  (created_at + interval '7 days'),
  77,
  'NORMAL',
  c.id,
  'Amendment: Application closed after completion',
  77,
  '2026-02-13 00:00:00+03'::timestamptz,
  '2026-02-13 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 97: Project 277 → EVIDENCE_REJECTED (EVIDENCE_REJECTED_OPEN)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  277,
  'APP-2026-001098',
  'AMENDMENT',
  'EVIDENCE_REJECTED',
  (created_at + interval '7 days'),
  2,
  'HIGH',
  c.id,
  'Amendment: Submitted evidence not acceptable',
  2,
  '2026-02-12 00:00:00+03'::timestamptz,
  '2026-02-12 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NMEC_YE';
-- Application 98: Project 258 → AWAITING_CONDITIONS (AWAITING_CONDITIONS)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  258,
  'APP-2026-001099',
  'AMENDMENT',
  'AWAITING_CONDITIONS',
  (created_at + interval '13 days'),
  94,
  'NORMAL',
  c.id,
  'Amendment: Awaiting conditions to be met',
  94,
  '2026-02-20 00:00:00+03'::timestamptz,
  '2026-02-20 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';
-- Application 99: Project 271 → AWAITING_CONDITIONS (EVIDENCE_RESUBMITTED_AWAITING)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  271,
  'APP-2026-001100',
  'AMENDMENT',
  'AWAITING_CONDITIONS',
  (created_at + interval '6 days'),
  96,
  'NORMAL',
  c.id,
  'Amendment: Awaiting conditions to be met',
  96,
  '2026-02-21 00:00:00+03'::timestamptz,
  '2026-02-21 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'SUREC_31';
-- Application 100: Project 251 → CLOSED (APPROVED_CLOSED)
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  251,
  'APP-2026-001101',
  'AMENDMENT',
  'CLOSED',
  (created_at + interval '12 days'),
  93,
  'NORMAL',
  c.id,
  'Amendment: Application closed after completion',
  93,
  '2026-02-17 00:00:00+03'::timestamptz,
  '2026-02-17 00:00:00+03'::timestamptz
FROM committee.committees c WHERE c.committee_code = 'NBC_YE';

-- =============================================================================
-- APPLICATION HISTORY
-- =============================================================================
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 65, '2025-02-03 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001002';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-08 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001002';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-19 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001002';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-05 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001002';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-03-11 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001002';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2025-03-23 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001002';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2025-03-27 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2025-001002';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ARCHIVE', 'CLOSED', 'ARCHIVED', 2, '2025-04-10 00:00:00+03'::timestamptz, 'Application archived'
FROM core.applications a WHERE a.application_number = 'APP-2025-001002';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 71, '2025-01-26 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001011';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-15 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001011';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-03-07 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001011';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-12 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001011';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-03-17 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001011';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2025-03-27 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001011';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2025-04-03 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2025-001011';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 93, '2026-02-19 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001101';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-09 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001101';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-15 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001101';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-26 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001101';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-14 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001101';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-23 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001101';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-05-12 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001101';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 72, '2025-02-04 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001012';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'REJECT_SUBMITTED', 'SUBMITTED', 'REJECTED', 2, '2025-02-13 00:00:00+03'::timestamptz, 'Rejected after submission'
FROM core.applications a WHERE a.application_number = 'APP-2025-001012';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 73, '2025-02-07 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001013';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-17 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001013';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-03-02 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001013';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-15 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001013';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-03-23 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001013';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2025-04-07 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001013';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2025-04-25 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2025-001013';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ARCHIVE', 'CLOSED', 'ARCHIVED', 2, '2025-05-15 00:00:00+03'::timestamptz, 'Application archived'
FROM core.applications a WHERE a.application_number = 'APP-2025-001013';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 73, '2025-02-11 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001014';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-23 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001014';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-03-05 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001014';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'SCIENTIFIC_REVIEW', 'APPROVED', 8, '2025-03-15 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001014';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 74, '2025-02-02 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001015';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-08 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001015';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-12 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001015';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-04 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001015';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-03-12 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001015';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 75, '2025-01-29 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001017';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-07 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001017';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-21 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001017';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-06 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001017';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-03-22 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001017';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2025-03-25 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001017';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 76, '2025-01-31 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001018';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-13 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001018';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-21 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001018';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-05 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001018';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-03-15 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001018';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2025-03-17 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001018';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2025-03-20 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2025-001018';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 77, '2025-02-10 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001019';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-19 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001019';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-26 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001019';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-01 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001019';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-03-10 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001019';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2025-03-27 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001019';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 77, '2025-01-29 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001020';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-07 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001020';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-19 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001020';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-02-25 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001020';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-03-11 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001020';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2025-03-13 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001020';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2025-03-23 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2025-001020';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 66, '2025-02-08 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001003';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-10 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001003';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-03-02 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001003';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-18 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001003';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-04-01 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001003';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2025-04-15 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001003';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2025-05-02 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2025-001003';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 78, '2025-02-17 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001021';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-21 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001021';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-28 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001021';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'SCIENTIFIC_REVIEW', 'APPROVED', 8, '2025-03-03 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001021';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 79, '2025-02-01 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001022';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-11 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001022';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-13 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001022';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-02-22 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001022';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 79, '2025-02-09 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001023';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-21 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001023';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-03-03 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001023';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-15 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001023';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-03-24 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001023';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2025-04-03 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001023';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 80, '2025-02-09 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001024';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 81, '2025-02-13 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001025';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-03-04 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001025';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-03-08 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001025';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-12 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001025';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-03-16 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001025';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2025-03-21 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001025';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2025-04-08 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2025-001025';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 81, '2025-02-15 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001026';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, '', 'SUBMITTED', 'WITHDRAWN', 81, '2025-02-23 00:00:00+03'::timestamptz, 'Application withdrawn after submission'
FROM core.applications a WHERE a.application_number = 'APP-2025-001026';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 82, '2025-02-13 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001027';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-19 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001027';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-28 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001027';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-07 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001027';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-03-23 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001027';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2025-04-02 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001027';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 83, '2025-02-03 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001028';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-14 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001028';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-16 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001028';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'SCIENTIFIC_REVIEW', 'APPROVED', 8, '2025-03-07 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001028';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 83, '2025-02-19 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001029';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-21 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001029';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-03-05 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001029';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 84, '2026-02-05 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001030';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-10 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001030';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-02-18 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001030';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-05 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001030';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-24 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001030';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-29 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001030';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 67, '2025-02-11 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001004';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-03-02 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001004';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-03-15 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001004';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-24 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001004';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 85, '2026-02-06 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001031';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-21 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001031';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-06 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001031';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-11 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001031';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-13 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001031';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-15 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001031';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-04-02 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001031';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 85, '2026-02-10 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001033';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-25 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001033';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-06 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001033';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-23 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001033';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-04 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001033';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-22 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001033';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-05-06 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001033';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'WITHDRAW', 'DRAFT', 'WITHDRAWN', 85, '2026-02-14 00:00:00+03'::timestamptz, 'Application withdrawn from draft'
FROM core.applications a WHERE a.application_number = 'APP-2026-001034';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 86, '2026-01-26 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001035';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-07 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001035';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-02-22 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001035';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-07 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001035';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-16 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001035';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-25 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001035';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-03-30 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001035';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 86, '2026-01-29 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001036';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-02 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001036';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-02-15 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001036';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-02-19 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001036';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-02-25 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001036';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 86, '2026-01-30 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001037';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 87, '2026-01-26 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001038';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-01-29 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001038';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-02-13 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001038';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-02-28 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001038';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-05 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001038';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-17 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001038';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 87, '2026-02-13 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001039';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 87, '2026-01-30 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001040';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-10 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001040';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-02-14 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001040';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-02-18 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001040';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-08 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001040';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-15 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001040';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-04-03 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001040';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 67, '2025-02-05 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001005';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-15 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001005';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 87, '2026-01-30 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001041';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-14 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001041';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-06 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001041';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-16 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001041';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-21 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001041';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-27 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001041';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-04-11 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001041';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 87, '2026-02-09 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001042';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-28 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001042';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-03 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001042';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-17 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001042';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-06 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001042';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-24 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001042';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-04-27 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001042';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ARCHIVE', 'CLOSED', 'ARCHIVED', 2, '2026-05-04 00:00:00+03'::timestamptz, 'Application archived'
FROM core.applications a WHERE a.application_number = 'APP-2026-001042';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 88, '2026-01-29 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001043';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-01 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001043';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-02-21 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001043';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-13 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001043';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-18 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001043';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-27 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001043';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 88, '2026-02-08 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001044';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, '', 'SUBMITTED', 'WITHDRAWN', 88, '2026-02-25 00:00:00+03'::timestamptz, 'Application withdrawn after submission'
FROM core.applications a WHERE a.application_number = 'APP-2026-001044';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 88, '2026-02-10 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001045';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-20 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001045';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-01 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001045';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-11 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001045';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-22 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001045';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-11 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001045';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 88, '2026-02-14 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001046';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-02 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001046';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-05 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001046';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 89, '2026-02-10 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001047';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-02 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001047';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-04 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001047';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-18 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001047';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-20 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001047';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-25 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001047';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 89, '2026-02-04 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001049';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-18 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001049';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-05 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001049';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'WITHDRAW', 'DRAFT', 'WITHDRAWN', 68, '2025-02-04 00:00:00+03'::timestamptz, 'Application withdrawn from draft'
FROM core.applications a WHERE a.application_number = 'APP-2025-001006';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 90, '2026-02-09 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001051';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-20 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001051';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-09 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001051';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'SCIENTIFIC_REVIEW', 'APPROVED', 8, '2026-03-28 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001051';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 90, '2026-02-02 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001052';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-15 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001052';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-02-17 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001052';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-02-19 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001052';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 90, '2026-02-08 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001053';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-25 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001053';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-09 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001053';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-27 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001053';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-11 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001053';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-29 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001053';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 90, '2026-02-13 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001054';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-15 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001054';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-02 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001054';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-07 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001054';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-13 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001054';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-24 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001054';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-04-01 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001054';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 91, '2026-02-25 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001055';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-11 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001055';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-18 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001055';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 91, '2026-02-14 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001056';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-05 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001056';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-13 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001056';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'RETURN_SCIENTIFIC', 'SCIENTIFIC_REVIEW', 'SUBMITTED', 6, '2026-03-27 00:00:00+03'::timestamptz, 'Returned from scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001056';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-30 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001056';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-04-05 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001056';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'REJECT_FROM_SCIENTIFIC', 'SCIENTIFIC_REVIEW', 'REJECTED', 6, '2026-04-12 00:00:00+03'::timestamptz, 'Rejected at scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001056';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 91, '2026-02-06 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001057';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-25 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001057';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'REJECT_FROM_INITIAL', 'INITIAL_REVIEW', 'REJECTED', 2, '2026-02-28 00:00:00+03'::timestamptz, 'Rejected at initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001057';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 91, '2026-02-11 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001058';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-22 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001058';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-09 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001058';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-13 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001058';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 92, '2026-02-18 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001059';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-26 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001059';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-17 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001059';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-30 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001059';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-13 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001059';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-15 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001059';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-04-17 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001059';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ARCHIVE', 'CLOSED', 'ARCHIVED', 2, '2026-04-19 00:00:00+03'::timestamptz, 'Application archived'
FROM core.applications a WHERE a.application_number = 'APP-2026-001059';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 92, '2026-02-18 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001060';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-27 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001060';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-10 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001060';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-25 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001060';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-01 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001060';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-05 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001060';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-04-22 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001060';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 69, '2025-02-01 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001007';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-08 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001007';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-20 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001007';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-03-10 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001007';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 92, '2026-02-18 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001061';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-04 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001061';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-19 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001061';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-04-01 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001061';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-10 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001061';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-20 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001061';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 93, '2026-02-17 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001062';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-09 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001062';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-14 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001062';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-04-02 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001062';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-17 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001062';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-05-03 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001062';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-05-19 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001062';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 93, '2026-02-13 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001063';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-04 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001063';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-19 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001063';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-29 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001063';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-07 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001063';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-23 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001063';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 93, '2026-02-07 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001065';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-21 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001065';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-02-24 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001065';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-04 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001065';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-13 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001065';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-30 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001065';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 93, '2026-02-17 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001067';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 94, '2026-02-10 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001069';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-22 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001069';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-03 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001069';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-05 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001069';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-22 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001069';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-25 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001069';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-04-06 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001069';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 94, '2026-02-18 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001070';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-04 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001070';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-21 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001070';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-24 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001070';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-08 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001070';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_CONDITIONAL', 'COMMITTEE_REVIEW', 'AWAITING_CONDITIONS', 8, '2026-04-17 00:00:00+03'::timestamptz, 'Conditional approval granted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001070';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CONDITIONS_MET', 'AWAITING_CONDITIONS', 'APPROVED', 8, '2026-05-04 00:00:00+03'::timestamptz, 'Conditions have been met'
FROM core.applications a WHERE a.application_number = 'APP-2026-001070';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-05-20 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001070';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 69, '2025-01-31 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001008';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 94, '2026-02-19 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001071';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-24 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001071';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-13 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001071';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'SCIENTIFIC_REVIEW', 'APPROVED', 8, '2026-03-29 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001071';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 94, '2026-02-11 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001072';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-17 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001072';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-04 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001072';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 94, '2026-02-17 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001074';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-23 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001074';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-02-25 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001074';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-14 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001074';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-19 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001074';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-25 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001074';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-04-06 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001074';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 95, '2026-02-12 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001075';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-03 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001075';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-16 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001075';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-21 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001075';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-10 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001075';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-14 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001075';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 95, '2026-02-13 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001076';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-24 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001076';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-11 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001076';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-19 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001076';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-05 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001076';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-13 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001076';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-04-30 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001076';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 95, '2026-02-20 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001078';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-01 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001078';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-14 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001078';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 95, '2026-02-26 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001079';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 95, '2026-03-02 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001080';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-07 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001080';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-18 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001080';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-24 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001080';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-26 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001080';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-08 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001080';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 70, '2025-01-31 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001009';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-03 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001009';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-13 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001009';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2025-02-18 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001009';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2025-02-27 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001009';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2025-03-17 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001009';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2025-04-06 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2025-001009';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ARCHIVE', 'CLOSED', 'ARCHIVED', 2, '2025-04-17 00:00:00+03'::timestamptz, 'Application archived'
FROM core.applications a WHERE a.application_number = 'APP-2025-001009';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 95, '2026-02-20 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001081';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-12 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001081';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-25 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001081';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'SCIENTIFIC_REVIEW', 'APPROVED', 8, '2026-03-29 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001081';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 95, '2026-02-15 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001082';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 96, '2026-02-14 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001083';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-16 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001083';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-02-25 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001083';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-15 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001083';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-26 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001083';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-04-07 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001083';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 96, '2026-02-26 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001084';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-09 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001084';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-12 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001084';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-04-01 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001084';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'RETURN_ETHICAL', 'ETHICAL_REVIEW', 'INITIAL_REVIEW', 8, '2026-04-11 00:00:00+03'::timestamptz, 'Returned from ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001084';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-04-22 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001084';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-05-05 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001084';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-05-13 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001084';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-05-19 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001084';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 96, '2026-02-23 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001085';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-01 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001085';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-13 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001085';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-24 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001085';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-29 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001085';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_RETURN', 'COMMITTEE_REVIEW', 'RETURNED', 8, '2026-04-11 00:00:00+03'::timestamptz, 'Application returned for revision'
FROM core.applications a WHERE a.application_number = 'APP-2026-001085';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 96, '2026-02-14 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001086';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-20 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001086';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-02-22 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001086';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-04 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001086';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-17 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001086';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-03-19 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001086';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-04-03 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001086';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 96, '2026-03-05 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001087';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 96, '2026-02-27 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001088';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-17 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001088';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-30 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001088';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-04-19 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001088';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-23 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001088';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-05-01 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001088';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-05-20 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001088';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 2, '2026-03-04 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001089';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-17 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001089';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-04-03 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001089';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-04-15 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001089';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-30 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001089';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-05-05 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001089';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 71, '2025-02-06 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2025-001010';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2025-02-17 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001010';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2025-02-27 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2025-001010';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'SCIENTIFIC_REVIEW', 'APPROVED', 8, '2025-03-14 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2025-001010';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 6, '2026-02-11 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001092';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-19 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001092';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-09 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001092';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'SCIENTIFIC_REVIEW', 'APPROVED', 8, '2026-03-23 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001092';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'WITHDRAW', 'DRAFT', 'WITHDRAWN', 7, '2026-02-19 00:00:00+03'::timestamptz, 'Application withdrawn from draft'
FROM core.applications a WHERE a.application_number = 'APP-2026-001093';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'WITHDRAW', 'DRAFT', 'WITHDRAWN', 7, '2026-02-19 00:00:00+03'::timestamptz, 'Application withdrawn from draft'
FROM core.applications a WHERE a.application_number = 'APP-2026-001094';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 75, '2026-02-19 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-10 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-21 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-26 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-05 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_RETURN', 'COMMITTEE_REVIEW', 'RETURNED', 8, '2026-04-21 00:00:00+03'::timestamptz, 'Application returned for revision'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'RESUBMIT', 'RETURNED', 'SUBMITTED', 75, '2026-05-06 00:00:00+03'::timestamptz, 'Application resubmitted after revision'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-05-09 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-05-15 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-05-18 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-05-24 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_APPROVE', 'COMMITTEE_REVIEW', 'APPROVED', 8, '2026-06-11 00:00:00+03'::timestamptz, 'Application approved'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 92, '2026-02-27 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-15 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-30 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-04-05 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-22 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_CONDITIONAL', 'COMMITTEE_REVIEW', 'AWAITING_CONDITIONS', 8, '2026-04-30 00:00:00+03'::timestamptz, 'Conditional approval granted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CONDITIONS_NOT_MET', 'AWAITING_CONDITIONS', 'EVIDENCE_REJECTED', 6, '2026-05-10 00:00:00+03'::timestamptz, 'Conditions not met'
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT_EVIDENCE', 'EVIDENCE_REJECTED', 'AWAITING_CONDITIONS', 92, '2026-05-19 00:00:00+03'::timestamptz, 'New evidence submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CONDITIONS_MET', 'AWAITING_CONDITIONS', 'APPROVED', 8, '2026-06-05 00:00:00+03'::timestamptz, 'Conditions have been met'
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-06-08 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 77, '2026-02-15 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-20 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-12 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-04-01 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-03 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_CONDITIONAL', 'COMMITTEE_REVIEW', 'AWAITING_CONDITIONS', 8, '2026-04-13 00:00:00+03'::timestamptz, 'Conditional approval granted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CONDITIONS_MET', 'AWAITING_CONDITIONS', 'APPROVED', 8, '2026-04-19 00:00:00+03'::timestamptz, 'Conditions have been met'
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CLOSE', 'APPROVED', 'CLOSED', 2, '2026-04-25 00:00:00+03'::timestamptz, 'Application closed'
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 2, '2026-02-22 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001098';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-02-25 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001098';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-02 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001098';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-03-04 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001098';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-03-24 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001098';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_CONDITIONAL', 'COMMITTEE_REVIEW', 'AWAITING_CONDITIONS', 8, '2026-03-27 00:00:00+03'::timestamptz, 'Conditional approval granted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001098';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CONDITIONS_NOT_MET', 'AWAITING_CONDITIONS', 'EVIDENCE_REJECTED', 6, '2026-03-31 00:00:00+03'::timestamptz, 'Conditions not met'
FROM core.applications a WHERE a.application_number = 'APP-2026-001098';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 94, '2026-03-06 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001099';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-19 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001099';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-03-26 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001099';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-04-08 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001099';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-13 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001099';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_CONDITIONAL', 'COMMITTEE_REVIEW', 'AWAITING_CONDITIONS', 8, '2026-05-03 00:00:00+03'::timestamptz, 'Conditional approval granted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001099';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT', 'DRAFT', 'SUBMITTED', 96, '2026-03-11 00:00:00+03'::timestamptz, 'Application submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'ACCEPT_INITIAL', 'SUBMITTED', 'INITIAL_REVIEW', 2, '2026-03-21 00:00:00+03'::timestamptz, 'Accepted for initial review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_SCIENTIFIC', 'INITIAL_REVIEW', 'SCIENTIFIC_REVIEW', 6, '2026-04-01 00:00:00+03'::timestamptz, 'Sent for scientific review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_ETHICAL', 'SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 6, '2026-04-08 00:00:00+03'::timestamptz, 'Sent for ethical review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SEND_TO_COMMITTEE', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 8, '2026-04-23 00:00:00+03'::timestamptz, 'Sent for committee review'
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'COMMITTEE_CONDITIONAL', 'COMMITTEE_REVIEW', 'AWAITING_CONDITIONS', 8, '2026-04-26 00:00:00+03'::timestamptz, 'Conditional approval granted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'CONDITIONS_NOT_MET', 'AWAITING_CONDITIONS', 'EVIDENCE_REJECTED', 6, '2026-05-05 00:00:00+03'::timestamptz, 'Conditions not met'
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, 'SUBMIT_EVIDENCE', 'EVIDENCE_REJECTED', 'AWAITING_CONDITIONS', 96, '2026-05-11 00:00:00+03'::timestamptz, 'New evidence submitted'
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 14, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001002';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001011';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001101';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 8, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001012';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 14, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001013';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001014';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 6, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001015';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001017';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001018';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001019';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001020';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001003';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001021';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 5, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001022';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001023';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 2, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001024';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001025';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 12, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001026';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001027';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001028';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 4, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001029';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001030';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 5, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001004';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001031';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001033';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 12, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001034';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001035';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 6, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001036';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 2, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001037';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001038';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 2, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001039';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001040';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 3, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001005';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001041';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 14, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001042';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001043';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 12, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001044';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001045';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 4, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001046';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001047';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 4, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001049';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 12, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001006';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001051';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 5, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001052';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001053';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001054';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 4, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001055';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 8, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001056';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 8, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001057';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 5, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001058';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 14, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001059';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001060';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 5, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001007';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001061';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001062';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001063';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001065';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 2, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001067';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001069';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001070';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 2, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001008';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001071';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 4, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001072';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001074';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001075';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001076';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 4, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001078';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 2, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001079';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001080';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 14, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001009';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001081';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 2, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001082';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001083';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001084';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 9, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001085';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001086';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 2, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001087';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001088';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001089';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2025-001010';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001092';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 12, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001093';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 12, a.created_at, 'COMPLETED', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001094';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 7, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 13, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 11, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001098';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 10, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001099';
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, 10, a.created_at, 'ACTIVE', 1
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 65, 'Application submitted', '2025-02-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001002';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001002';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001002';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001002';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-03-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001002';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-03-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001002';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2025-03-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001002';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 21, 2, 'Application archived', '2025-04-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001002';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 71, 'Application submitted', '2025-01-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001011';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001011';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-03-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001011';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-12 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001011';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-03-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001011';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-03-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001011';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2025-04-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001011';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 93, 'Application submitted', '2026-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001101';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-09 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001101';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001101';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001101';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001101';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001101';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-05-12 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001101';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 72, 'Application submitted', '2025-02-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001012';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 4, 2, 'Rejected after submission', '2025-02-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001012';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 73, 'Application submitted', '2025-02-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001013';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001013';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-03-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001013';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001013';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-03-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001013';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-04-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001013';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2025-04-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001013';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 21, 2, 'Application archived', '2025-05-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001013';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 73, 'Application submitted', '2025-02-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001014';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001014';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-03-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001014';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-03-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001014';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 74, 'Application submitted', '2025-02-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001015';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001015';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-12 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001015';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001015';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-03-12 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001015';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 75, 'Application submitted', '2025-01-29 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001017';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001017';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001017';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001017';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-03-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001017';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-03-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001017';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 76, 'Application submitted', '2025-01-31 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001018';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001018';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001018';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001018';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-03-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001018';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-03-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001018';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2025-03-20 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001018';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 77, 'Application submitted', '2025-02-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001019';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001019';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001019';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001019';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-03-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001019';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-03-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001019';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 77, 'Application submitted', '2025-01-29 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001020';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001020';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001020';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-02-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001020';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-03-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001020';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-03-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001020';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2025-03-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001020';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 66, 'Application submitted', '2025-02-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001003';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001003';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-03-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001003';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001003';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-04-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001003';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-04-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001003';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2025-05-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001003';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 78, 'Application submitted', '2025-02-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001021';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001021';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-28 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001021';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-03-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001021';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 79, 'Application submitted', '2025-02-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001022';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001022';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001022';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-02-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001022';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 79, 'Application submitted', '2025-02-09 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001023';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001023';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-03-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001023';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001023';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-03-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001023';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-04-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001023';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 80, 'Application submitted', '2025-02-09 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001024';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 81, 'Application submitted', '2025-02-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001025';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-03-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001025';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-03-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001025';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-12 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001025';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-03-16 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001025';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-03-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001025';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2025-04-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001025';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 81, 'Application submitted', '2025-02-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001026';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 26, 81, 'Application withdrawn after submission', '2025-02-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001026';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 82, 'Application submitted', '2025-02-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001027';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001027';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-28 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001027';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001027';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-03-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001027';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-04-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001027';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 83, 'Application submitted', '2025-02-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001028';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001028';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-16 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001028';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-03-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001028';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 83, 'Application submitted', '2025-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001029';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001029';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-03-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001029';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 84, 'Application submitted', '2026-02-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001030';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001030';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-02-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001030';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001030';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001030';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-29 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001030';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 67, 'Application submitted', '2025-02-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001004';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-03-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001004';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-03-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001004';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001004';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 85, 'Application submitted', '2026-02-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001031';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001031';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001031';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001031';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001031';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001031';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-04-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001031';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 85, 'Application submitted', '2026-02-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001033';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001033';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001033';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001033';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001033';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001033';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-05-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001033';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 25, 85, 'Application withdrawn from draft', '2026-02-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001034';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 86, 'Application submitted', '2026-01-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001035';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001035';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-02-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001035';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001035';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-16 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001035';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001035';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-03-30 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001035';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 86, 'Application submitted', '2026-01-29 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001036';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001036';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-02-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001036';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001036';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-02-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001036';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 86, 'Application submitted', '2026-01-30 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001037';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 87, 'Application submitted', '2026-01-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001038';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-01-29 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001038';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-02-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001038';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-02-28 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001038';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001038';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001038';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 87, 'Application submitted', '2026-02-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001039';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 87, 'Application submitted', '2026-01-30 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001040';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001040';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-02-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001040';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-02-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001040';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001040';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001040';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-04-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001040';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 67, 'Application submitted', '2025-02-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001005';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001005';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 87, 'Application submitted', '2026-01-30 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001041';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001041';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001041';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-16 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001041';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001041';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001041';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-04-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001041';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 87, 'Application submitted', '2026-02-09 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001042';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-28 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001042';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001042';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001042';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001042';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001042';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-04-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001042';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 21, 2, 'Application archived', '2026-05-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001042';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 88, 'Application submitted', '2026-01-29 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001043';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001043';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-02-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001043';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001043';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001043';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001043';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 88, 'Application submitted', '2026-02-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001044';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 26, 88, 'Application withdrawn after submission', '2026-02-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001044';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 88, 'Application submitted', '2026-02-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001045';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-20 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001045';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001045';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001045';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001045';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001045';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 88, 'Application submitted', '2026-02-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001046';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001046';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001046';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 89, 'Application submitted', '2026-02-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001047';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001047';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001047';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001047';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-20 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001047';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001047';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 89, 'Application submitted', '2026-02-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001049';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001049';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001049';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 25, 68, 'Application withdrawn from draft', '2025-02-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001006';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 90, 'Application submitted', '2026-02-09 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001051';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-20 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001051';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-09 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001051';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-28 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001051';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 90, 'Application submitted', '2026-02-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001052';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001052';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-02-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001052';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001052';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 90, 'Application submitted', '2026-02-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001053';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001053';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-09 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001053';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001053';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001053';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-29 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001053';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 90, 'Application submitted', '2026-02-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001054';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001054';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001054';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001054';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001054';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001054';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-04-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001054';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 91, 'Application submitted', '2026-02-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001055';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001055';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001055';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 91, 'Application submitted', '2026-02-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001056';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001056';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001056';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 8, 6, 'Returned from scientific review', '2026-03-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001056';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-30 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001056';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-04-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001056';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 16, 6, 'Rejected at scientific review', '2026-04-12 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001056';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 91, 'Application submitted', '2026-02-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001057';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001057';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 15, 2, 'Rejected at initial review', '2026-02-28 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001057';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 91, 'Application submitted', '2026-02-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001058';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001058';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-09 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001058';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001058';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 92, 'Application submitted', '2026-02-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001059';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001059';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001059';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-30 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001059';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001059';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001059';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-04-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001059';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 21, 2, 'Application archived', '2026-04-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001059';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 92, 'Application submitted', '2026-02-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001060';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001060';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001060';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001060';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001060';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001060';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-04-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001060';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 69, 'Application submitted', '2025-02-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001007';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001007';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-20 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001007';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-03-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001007';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 92, 'Application submitted', '2026-02-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001061';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001061';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001061';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-04-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001061';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001061';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-20 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001061';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 93, 'Application submitted', '2026-02-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001062';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-09 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001062';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001062';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-04-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001062';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001062';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-05-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001062';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-05-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001062';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 93, 'Application submitted', '2026-02-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001063';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001063';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001063';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-29 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001063';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001063';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001063';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 93, 'Application submitted', '2026-02-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001065';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001065';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-02-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001065';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001065';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001065';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-30 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001065';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 93, 'Application submitted', '2026-02-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001067';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 94, 'Application submitted', '2026-02-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001069';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001069';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001069';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001069';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001069';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001069';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-04-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001069';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 94, 'Application submitted', '2026-02-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001070';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001070';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001070';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001070';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001070';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 18, 8, 'Conditional approval granted', '2026-04-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001070';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 19, 8, 'Conditions have been met', '2026-05-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001070';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-05-20 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001070';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 69, 'Application submitted', '2025-01-31 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001008';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 94, 'Application submitted', '2026-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001071';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001071';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001071';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-29 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001071';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 94, 'Application submitted', '2026-02-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001072';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001072';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001072';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 94, 'Application submitted', '2026-02-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001074';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001074';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-02-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001074';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001074';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001074';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001074';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-04-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001074';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 95, 'Application submitted', '2026-02-12 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001075';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001075';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-16 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001075';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001075';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001075';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001075';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 95, 'Application submitted', '2026-02-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001076';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001076';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001076';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001076';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001076';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001076';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-04-30 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001076';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 95, 'Application submitted', '2026-02-20 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001078';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001078';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001078';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 95, 'Application submitted', '2026-02-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001079';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 95, 'Application submitted', '2026-03-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001080';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001080';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001080';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001080';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001080';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001080';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 70, 'Application submitted', '2025-01-31 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001009';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001009';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001009';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2025-02-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001009';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2025-02-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001009';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-03-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001009';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2025-04-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001009';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 21, 2, 'Application archived', '2025-04-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001009';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 95, 'Application submitted', '2026-02-20 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001081';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-12 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001081';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001081';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-29 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001081';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 95, 'Application submitted', '2026-02-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001082';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 96, 'Application submitted', '2026-02-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001083';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-16 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001083';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-02-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001083';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001083';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001083';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-04-07 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001083';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 96, 'Application submitted', '2026-02-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-09 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-12 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-04-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 10, 8, 'Returned from ethical review', '2026-04-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-04-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-05-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-05-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-05-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001084';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 96, 'Application submitted', '2026-02-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001085';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001085';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001085';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001085';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-29 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001085';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 13, 8, 'Application returned for revision', '2026-04-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001085';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 96, 'Application submitted', '2026-02-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001086';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-20 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001086';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-02-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001086';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001086';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001086';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001086';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-04-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001086';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 96, 'Application submitted', '2026-03-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001087';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 96, 'Application submitted', '2026-02-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001088';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001088';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-30 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001088';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-04-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001088';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001088';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-05-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001088';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-05-20 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001088';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 2, 'Application submitted', '2026-03-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001089';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001089';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-04-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001089';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-04-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001089';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-30 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001089';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-05-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001089';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 71, 'Application submitted', '2025-02-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001010';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2025-02-17 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001010';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2025-02-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001010';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2025-03-14 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2025-001010';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 6, 'Application submitted', '2026-02-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001092';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001092';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-09 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001092';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-03-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001092';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 25, 7, 'Application withdrawn from draft', '2026-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001093';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 25, 7, 'Application withdrawn from draft', '2026-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001094';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 75, 'Application submitted', '2026-02-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 13, 8, 'Application returned for revision', '2026-04-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 14, 75, 'Application resubmitted after revision', '2026-05-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-05-09 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-05-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-05-18 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-05-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 11, 8, 'Application approved', '2026-06-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001095';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 92, 'Application submitted', '2026-02-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-30 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-04-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 18, 8, 'Conditional approval granted', '2026-04-30 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 22, 6, 'Conditions not met', '2026-05-10 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 23, 92, 'New evidence submitted', '2026-05-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 19, 8, 'Conditions have been met', '2026-06-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-06-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001096';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 77, 'Application submitted', '2026-02-15 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001097';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-20 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001097';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-12 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001097';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-04-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001097';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001097';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 18, 8, 'Conditional approval granted', '2026-04-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001097';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 19, 8, 'Conditions have been met', '2026-04-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001097';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 20, 2, 'Application closed', '2026-04-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001097';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 2, 'Application submitted', '2026-02-22 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001098';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-02-25 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001098';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-02 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001098';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-03-04 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001098';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-03-24 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001098';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 18, 8, 'Conditional approval granted', '2026-03-27 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001098';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 22, 6, 'Conditions not met', '2026-03-31 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001098';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 94, 'Application submitted', '2026-03-06 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001099';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-19 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001099';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-03-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001099';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-04-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001099';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-13 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001099';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 18, 8, 'Conditional approval granted', '2026-05-03 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001099';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 1, 96, 'Application submitted', '2026-03-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001100';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 2, 2, 'Accepted for initial review', '2026-03-21 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001100';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 5, 6, 'Sent for scientific review', '2026-04-01 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001100';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 7, 6, 'Sent for ethical review', '2026-04-08 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001100';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 9, 8, 'Sent for committee review', '2026-04-23 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001100';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 18, 8, 'Conditional approval granted', '2026-04-26 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001100';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 22, 6, 'Conditions not met', '2026-05-05 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001100';
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, 23, 96, 'New evidence submitted', '2026-05-11 00:00:00+03'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = 'APP-2026-001100';

-- =============================================================================
-- REVIEW ASSIGNMENTS
-- =============================================================================
-- Create review assignments for applications in review states
-- Scientific reviewers for SCIENTIFIC_REVIEW state
-- Ethics reviewers for ETHICAL_REVIEW state
-- =============================================================================
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001002'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001002'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001002'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001002'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001011'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001011'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001011'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001011'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001101'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001101'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001101'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001101'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 11, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001012'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 11 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 12, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001012'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 12 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 13, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001012'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 13 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 14, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001012'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 14 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001013'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001013'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001013'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001013'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001014'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001014'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001014'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001014'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 11, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001015'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 11 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 12, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001015'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 12 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 13, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001015'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 13 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 14, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001015'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 14 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001017'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001017'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001017'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001017'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 11, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001018'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 11 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 12, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001018'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 12 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 13, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001018'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 13 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 14, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001018'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 14 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001019'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001019'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001019'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001019'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001020'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001020'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001020'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001020'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001003'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001003'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001003'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001003'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001021'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001021'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001021'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001021'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001022'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001022'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001022'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001022'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001023'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001023'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001023'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001023'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 31, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001025'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 31 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 32, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001025'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 32 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 33, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001025'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 33 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 34, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001025'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 34 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 31, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001027'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 31 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 32, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001027'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 32 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 33, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001027'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 33 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 34, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001027'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 34 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001028'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001028'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001028'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001028'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001029'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001029'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001030'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001030'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001030'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001030'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001004'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001004'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001004'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001004'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 11, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001031'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 11 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 12, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001031'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 12 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 13, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001031'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 13 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 14, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001031'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 14 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001033'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001033'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001033'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001033'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001035'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001035'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001035'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001035'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 11, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001036'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 11 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 12, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001036'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 12 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 13, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001036'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 13 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 14, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001036'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 14 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001038'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001038'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001038'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001038'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001040'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001040'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001040'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001040'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001041'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001041'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001041'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001041'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001042'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001042'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001042'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001042'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001043'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001043'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001043'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001043'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001045'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001045'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001045'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001045'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001046'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001046'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 22, 'SCIENTIFIC', 9, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001047'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 22 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 23, 'SCIENTIFIC', 9, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001047'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 23 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 24, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001047'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 24 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 25, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001047'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 25 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 22, 'SCIENTIFIC', 9, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001049'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 22 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 23, 'SCIENTIFIC', 9, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001049'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 23 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 36, 'SCIENTIFIC', 10, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001051'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 36 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 37, 'SCIENTIFIC', 10, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001051'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 37 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 38, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001051'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 38 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 36, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001051'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 36 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 36, 'SCIENTIFIC', 10, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001052'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 36 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 37, 'SCIENTIFIC', 10, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001052'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 37 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 38, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001052'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 38 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 36, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001052'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 36 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 36, 'SCIENTIFIC', 10, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001053'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 36 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 37, 'SCIENTIFIC', 10, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001053'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 37 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 38, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001053'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 38 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 36, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001053'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 36 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 36, 'SCIENTIFIC', 10, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001054'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 36 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 37, 'SCIENTIFIC', 10, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001054'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 37 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 38, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001054'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 38 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 36, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001054'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 36 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001055'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001055'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001056'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001056'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001056'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001056'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 11, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001057'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 11 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 12, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001057'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 12 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 13, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001057'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 13 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 14, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001057'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 14 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001058'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001058'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001058'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001058'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001059'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001059'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001059'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001059'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001060'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001060'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001060'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001060'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001007'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001007'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001007'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001007'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001061'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001061'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001061'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001061'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001062'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001062'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001062'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001062'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001063'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001063'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001063'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001063'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001065'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001065'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001065'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001065'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001069'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001069'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001069'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001069'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001070'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001070'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001070'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001070'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001071'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001071'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001071'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001071'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001072'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001072'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001074'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001074'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001074'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001074'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001075'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001075'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001075'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001075'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 11, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001076'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 11 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 12, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001076'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 12 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 13, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001076'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 13 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 14, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001076'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 14 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001078'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001078'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001080'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001080'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001080'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001080'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001009'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001009'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001009'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001009'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001081'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001081'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001081'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001081'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001083'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001083'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001083'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001083'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001084'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001084'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001084'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001084'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001086'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001086'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001086'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001086'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001088'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001088'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001088'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001088'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 11, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001089'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 11 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 12, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001089'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 12 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 13, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001089'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 13 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 14, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001089'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 14 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001010'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001010'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001010'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2025-001010'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001092'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001092'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001092'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001092'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001095'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001095'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001095'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001095'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001096'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001096'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001096'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001096'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001097'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001097'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001097'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001097'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 11, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001098'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 11 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 12, 'SCIENTIFIC', 6, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001098'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 12 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 13, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001098'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 13 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 14, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001098'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 14 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001099'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 28, 'SCIENTIFIC', 7, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001099'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 28 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 29, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001099'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 29 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 27, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001099'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 27 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 17, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001100'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 17 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 18, 'SCIENTIFIC', 8, (a.created_at + interval '21 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001100'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 18 AND ra.review_type = 'SCIENTIFIC');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 19, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001100'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 19 AND ra.review_type = 'ETHICAL');
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, 20, 'ETHICAL', 1, (a.created_at + interval '28 days')
FROM core.applications a WHERE a.application_number = 'APP-2026-001100'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = 20 AND ra.review_type = 'ETHICAL');

-- =============================================================================
-- SCIENTIFIC REVIEWS
-- =============================================================================
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001002'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001011'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001101'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'REJECTED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001012'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001013'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001014'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001015'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001017'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001018'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001019'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001020'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001003'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001021'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001022'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001023'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001025'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001027'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001028'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001029'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001030'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001004'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001031'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001033'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001035'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001036'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001038'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001040'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001041'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001042'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001043'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001045'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001046'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001047'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001049'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001051'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001052'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001053'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001054'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001055'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'REJECTED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001056'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'REJECTED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001057'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001058'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001059'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001060'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001007'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001061'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001062'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001063'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001065'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001069'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001070'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001071'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001072'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001074'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001075'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001076'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001078'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001080'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001009'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001081'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001083'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001084'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'REVISION',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001085'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001086'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001088'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001089'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2025-001010'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001092'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001095'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001096'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001097'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001098'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001099'
LIMIT 1;
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = 'APP-2026-001100'
LIMIT 1;

-- =============================================================================
-- ETHICS REVIEWS
-- =============================================================================
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001002'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001011'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001101'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'REJECTED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001012'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001013'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001014'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001015'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001017'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001018'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001019'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001020'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001003'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001021'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001022'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001023'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001025'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001027'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001028'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001030'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001004'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001031'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001033'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001035'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001036'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001038'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001040'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001041'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001042'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001043'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001045'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001047'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001051'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001052'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001053'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001054'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'REJECTED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001056'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'REJECTED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001057'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001058'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001059'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001060'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001007'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001061'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001062'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001063'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001065'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001069'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001070'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001071'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001074'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001075'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001076'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001080'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001009'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001081'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001083'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001084'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001086'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001088'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001089'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2025-001010'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001092'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001095'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001096'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001097'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'APPROVED',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001098'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'CONDITIONAL',
  'Risk level assessed as 1. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001099'
LIMIT 1;
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  'CONDITIONAL',
  'Risk level assessed as 2. Adequate mitigation measures identified.',
  'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = 'APP-2026-001100'
LIMIT 1;

-- =============================================================================
-- APPLICATION CONDITIONS
-- =============================================================================
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Provide updated informed consent documents reflecting the revised protocol.', 'MINOR', 'GENERAL', (a.created_at + interval '60 days')::timestamptz, 'MET', 1, 6, (a.created_at + interval '45 days')::timestamptz
FROM core.applications a WHERE a.application_number = 'APP-2026-001070';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Submit evidence of community engagement activities prior to study initiation.', 'MAJOR', 'SCIENTIFIC', (a.created_at + interval '60 days')::timestamptz, 'MET', 1, 6, (a.created_at + interval '45 days')::timestamptz
FROM core.applications a WHERE a.application_number = 'APP-2026-001070';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Provide updated informed consent documents reflecting the revised protocol.', 'MINOR', 'GENERAL', (a.created_at + interval '60 days')::timestamptz, 'MET', 1, 6, (a.created_at + interval '45 days')::timestamptz
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Submit evidence of community engagement activities prior to study initiation.', 'MAJOR', 'SCIENTIFIC', (a.created_at + interval '60 days')::timestamptz, 'MET', 1, 6, (a.created_at + interval '45 days')::timestamptz
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Provide certified translation of consent forms into Arabic.', 'MINOR', 'ETHICAL', (a.created_at + interval '60 days')::timestamptz, 'MET', 1, 6, (a.created_at + interval '45 days')::timestamptz
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Provide updated informed consent documents reflecting the revised protocol.', 'MINOR', 'GENERAL', (a.created_at + interval '60 days')::timestamptz, 'MET', 1, 6, (a.created_at + interval '45 days')::timestamptz
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Submit evidence of community engagement activities prior to study initiation.', 'MAJOR', 'SCIENTIFIC', (a.created_at + interval '60 days')::timestamptz, 'MET', 1, 6, (a.created_at + interval '45 days')::timestamptz
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Provide certified translation of consent forms into Arabic.', 'MINOR', 'ETHICAL', (a.created_at + interval '60 days')::timestamptz, 'MET', 1, 6, (a.created_at + interval '45 days')::timestamptz
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Provide updated informed consent documents reflecting the revised protocol.', 'MINOR', 'GENERAL', (a.created_at + interval '60 days')::timestamptz, 'MET', 1, 6, (a.created_at + interval '45 days')::timestamptz
FROM core.applications a WHERE a.application_number = 'APP-2026-001098';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Submit evidence of community engagement activities prior to study initiation.', 'MAJOR', 'SCIENTIFIC', (a.created_at + interval '60 days')::timestamptz, 'OPEN', 1, NULL, NULL
FROM core.applications a WHERE a.application_number = 'APP-2026-001098';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Provide updated informed consent documents reflecting the revised protocol.', 'MINOR', 'GENERAL', (a.created_at + interval '60 days')::timestamptz, 'OPEN', 1, NULL, NULL
FROM core.applications a WHERE a.application_number = 'APP-2026-001099';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Submit evidence of community engagement activities prior to study initiation.', 'MAJOR', 'SCIENTIFIC', (a.created_at + interval '60 days')::timestamptz, 'OPEN', 1, NULL, NULL
FROM core.applications a WHERE a.application_number = 'APP-2026-001099';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Provide updated informed consent documents reflecting the revised protocol.', 'MINOR', 'GENERAL', (a.created_at + interval '60 days')::timestamptz, 'OPEN', 1, NULL, NULL
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Submit evidence of community engagement activities prior to study initiation.', 'MAJOR', 'SCIENTIFIC', (a.created_at + interval '60 days')::timestamptz, 'OPEN', 1, NULL, NULL
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, 'Provide certified translation of consent forms into Arabic.', 'MINOR', 'ETHICAL', (a.created_at + interval '60 days')::timestamptz, 'OPEN', 1, NULL, NULL
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';

-- =============================================================================
-- APPLICATION AMENDMENTS
-- =============================================================================
-- Create amendment records linking amendment applications to their parent
-- =============================================================================
INSERT INTO core.application_amendments (application_id, amendment_number, amendment_reason, amendment_description, submitted_by, submitted_at, status_code)
SELECT a.id, 'AMD-2026-001095', 'Protocol amendment: addition of new study site', 'Amendment to APP-2025-001017: Protocol amendment: addition of new study site', 75, a.created_at, 'APPROVED'
FROM core.applications a WHERE a.application_number = 'APP-2026-001095';
INSERT INTO core.application_amendments (application_id, amendment_number, amendment_reason, amendment_description, submitted_by, submitted_at, status_code)
SELECT a.id, 'AMD-2026-001096', 'Protocol amendment: revised inclusion criteria', 'Amendment to APP-2026-001061: Protocol amendment: revised inclusion criteria', 92, a.created_at, 'CLOSED'
FROM core.applications a WHERE a.application_number = 'APP-2026-001096';
INSERT INTO core.application_amendments (application_id, amendment_number, amendment_reason, amendment_description, submitted_by, submitted_at, status_code)
SELECT a.id, 'AMD-2026-001097', 'Protocol amendment: extended study duration', 'Amendment to APP-2025-001019: Protocol amendment: extended study duration', 77, a.created_at, 'CLOSED'
FROM core.applications a WHERE a.application_number = 'APP-2026-001097';
INSERT INTO core.application_amendments (application_id, amendment_number, amendment_reason, amendment_description, submitted_by, submitted_at, status_code)
SELECT a.id, 'AMD-2026-001098', 'Protocol amendment: added new biological sample collection', 'Amendment to APP-2026-001089: Protocol amendment: added new biological sample collection', 2, a.created_at, 'EVIDENCE_REJECTED'
FROM core.applications a WHERE a.application_number = 'APP-2026-001098';
INSERT INTO core.application_amendments (application_id, amendment_number, amendment_reason, amendment_description, submitted_by, submitted_at, status_code)
SELECT a.id, 'AMD-2026-001099', 'Protocol amendment: revised data collection instruments', 'Amendment to APP-2026-001070: Protocol amendment: revised data collection instruments', 94, a.created_at, 'AWAITING_CONDITIONS'
FROM core.applications a WHERE a.application_number = 'APP-2026-001099';
INSERT INTO core.application_amendments (application_id, amendment_number, amendment_reason, amendment_description, submitted_by, submitted_at, status_code)
SELECT a.id, 'AMD-2026-001100', 'Protocol amendment: added genetic analysis component', 'Amendment to APP-2026-001083: Protocol amendment: added genetic analysis component', 96, a.created_at, 'AWAITING_CONDITIONS'
FROM core.applications a WHERE a.application_number = 'APP-2026-001100';
INSERT INTO core.application_amendments (application_id, amendment_number, amendment_reason, amendment_description, submitted_by, submitted_at, status_code)
SELECT a.id, 'AMD-2026-001101', 'Protocol amendment: modification of recruitment strategy', 'Amendment to APP-2026-001063: Protocol amendment: modification of recruitment strategy', 93, a.created_at, 'CLOSED'
FROM core.applications a WHERE a.application_number = 'APP-2026-001101';

-- =============================================================================
-- UPDATE SEQUENCES TO MATCH INSERTED DATA
-- =============================================================================

SELECT setval('committee.committees_id_seq', (SELECT MAX(id) FROM committee.committees), true);
SELECT setval('committee.committee_members_id_seq', (SELECT MAX(id) FROM committee.committee_members), true);
SELECT setval('core.applications_id_seq', (SELECT MAX(id) FROM core.applications), true);
SELECT setval('core.application_history_id_seq', (SELECT MAX(id) FROM core.application_history), true);
SELECT setval('workflow.workflow_instances_id_seq', (SELECT MAX(id) FROM workflow.workflow_instances), true);
SELECT setval('workflow.workflow_actions_id_seq', (SELECT MAX(id) FROM workflow.workflow_actions), true);
SELECT setval('committee.review_assignments_id_seq', (SELECT MAX(id) FROM committee.review_assignments), true);
SELECT setval('committee.scientific_reviews_id_seq', (SELECT MAX(id) FROM committee.scientific_reviews), true);
SELECT setval('committee.ethics_reviews_id_seq', (SELECT MAX(id) FROM committee.ethics_reviews), true);
SELECT setval('committee.application_conditions_id_seq', (SELECT MAX(id) FROM committee.application_conditions), true);
SELECT setval('core.application_amendments_id_seq', (SELECT MAX(id) FROM core.application_amendments), true);

COMMIT;

