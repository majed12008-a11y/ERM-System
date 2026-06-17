-- ============================================================
-- 08-REVIEW FORMS, ASSIGNMENTS, AND REVIEWS
-- ============================================================

-- Review Forms
INSERT INTO committee.review_forms (form_code, form_name, review_type, version_no, is_active) VALUES
  ('SCI_REVIEW_V1', 'نموذج المراجعة العلمية', 'SCIENTIFIC', 1, true),
  ('ETH_REVIEW_V1', 'نموذج المراجعة الأخلاقية', 'ETHICS', 1, true),
  ('EXP_REVIEW_V1', 'نموذج المراجعة المستعجلة', 'EXPEDITED', 1, true);

-- Scientific Review Questions
INSERT INTO committee.review_questions (form_id, question_code, question_text, question_type, display_order, is_required)
SELECT f.id, 'SCI_Q01', 'هل أهداف البحث واضحة ومحددة؟', 'BOOLEAN', 1, true
FROM committee.review_forms f WHERE f.form_code = 'SCI_REVIEW_V1'
UNION ALL
SELECT f.id, 'SCI_Q02', 'هل منهجية البحث مناسبة لتحقيق الأهداف؟', 'SCALE', 2, true
FROM committee.review_forms f WHERE f.form_code = 'SCI_REVIEW_V1'
UNION ALL
SELECT f.id, 'SCI_Q03', 'هل حجم العينة مناسب للإجابة على أسئلة البحث؟', 'BOOLEAN', 3, true
FROM committee.review_forms f WHERE f.form_code = 'SCI_REVIEW_V1'
UNION ALL
SELECT f.id, 'SCI_Q04', 'هل التحليل الإحصائي المقترح مناسب؟', 'SCALE', 4, true
FROM committee.review_forms f WHERE f.form_code = 'SCI_REVIEW_V1'
UNION ALL
SELECT f.id, 'SCI_Q05', 'يرجى تقديم ملاحظاتك العامة حول الجانب العلمي من البحث', 'TEXT', 5, false
FROM committee.review_forms f WHERE f.form_code = 'SCI_REVIEW_V1';

-- Ethical Review Questions
INSERT INTO committee.review_questions (form_id, question_code, question_text, question_type, display_order, is_required)
SELECT f.id, 'ETH_Q01', 'هل تم تضمين نموذج الموافقة المستنيرة المناسب؟', 'BOOLEAN', 1, true
FROM committee.review_forms f WHERE f.form_code = 'ETH_REVIEW_V1'
UNION ALL
SELECT f.id, 'ETH_Q02', 'هل تم مراعاة خصوصية المشاركين وسرية البيانات؟', 'SCALE', 2, true
FROM committee.review_forms f WHERE f.form_code = 'ETH_REVIEW_V1'
UNION ALL
SELECT f.id, 'ETH_Q03', 'هل الفوائد المتوقعة تفوق المخاطر المحتملة؟', 'SCALE', 3, true
FROM committee.review_forms f WHERE f.form_code = 'ETH_REVIEW_V1'
UNION ALL
SELECT f.id, 'ETH_Q04', 'هل تم التعامل مع الفئات الضعيفة بشكل مناسب؟', 'BOOLEAN', 4, true
FROM committee.review_forms f WHERE f.form_code = 'ETH_REVIEW_V1'
UNION ALL
SELECT f.id, 'ETH_Q05', 'هل خطة المتابعة المستمرة للسلامة مناسبة؟', 'BOOLEAN', 5, true
FROM committee.review_forms f WHERE f.form_code = 'ETH_REVIEW_V1'
UNION ALL
SELECT f.id, 'ETH_Q06', 'يرجى تقديم ملاحظاتك حول الجوانب الأخلاقية', 'TEXT', 6, false
FROM committee.review_forms f WHERE f.form_code = 'ETH_REVIEW_V1';

-- ============================================================
-- REVIEW ASSIGNMENTS
-- ============================================================

-- Application 1 (APPROVED) - reviews completed
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, assigned_at, due_date, status_code)
SELECT a.id, u.id, 'SCIENTIFIC', admin.id, '2024-03-20 11:00:00+03'::timestamptz, '2024-04-03 11:00:00+03'::timestamptz, 'COMPLETED'
FROM core.applications a, security.users u, security.users admin, committee.committees c
WHERE a.application_number = 'APP-2024-001' AND u.username = 'reviewer1' AND admin.username = 'ethics_admin' AND c.committee_code = 'IRB-KSU-01'
  AND a.target_committee_id = c.id;

INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, assigned_at, due_date, status_code)
SELECT a.id, u.id, 'ETHICS', admin.id, '2024-04-05 09:30:00+03'::timestamptz, '2024-04-19 09:30:00+03'::timestamptz, 'COMPLETED'
FROM core.applications a, security.users u, security.users admin
WHERE a.application_number = 'APP-2024-001' AND u.username = 'reviewer2' AND admin.username = 'ethics_admin';

INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, assigned_at, due_date, status_code)
SELECT a.id, u.id, 'ETHICS', admin.id, '2024-04-05 09:30:00+03'::timestamptz, '2024-04-19 09:30:00+03'::timestamptz, 'COMPLETED'
FROM core.applications a, security.users u, security.users admin
WHERE a.application_number = 'APP-2024-001' AND u.username = 'reviewer3' AND admin.username = 'ethics_admin';

-- Application 2 (COMMITTEE_REVIEW) - scientific review in progress, ethical completed
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, assigned_at, due_date, status_code)
SELECT a.id, u.id, 'SCIENTIFIC', admin.id, '2024-06-18 11:00:00+03'::timestamptz, '2024-07-02 11:00:00+03'::timestamptz, 'COMPLETED'
FROM core.applications a, security.users u, security.users admin
WHERE a.application_number = 'APP-2024-002' AND u.username = 'reviewer1' AND admin.username = 'ethics_admin';

INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, assigned_at, due_date, status_code)
SELECT a.id, u.id, 'ETHICS', admin.id, '2024-07-10 10:00:00+03'::timestamptz, '2024-07-24 10:00:00+03'::timestamptz, 'COMPLETED'
FROM core.applications a, security.users u, security.users admin
WHERE a.application_number = 'APP-2024-002' AND u.username = 'reviewer2' AND admin.username = 'ethics_admin';

INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, assigned_at, due_date, status_code)
SELECT a.id, u.id, 'ETHICS', admin.id, '2024-07-10 10:00:00+03'::timestamptz, '2024-07-24 10:00:00+03'::timestamptz, 'COMPLETED'
FROM core.applications a, security.users u, security.users admin
WHERE a.application_number = 'APP-2024-002' AND u.username = 'reviewer3' AND admin.username = 'ethics_admin';

-- Application 3 (SCIENTIFIC_REVIEW) - scientific review in progress
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, assigned_at, due_date, status_code)
SELECT a.id, u.id, 'SCIENTIFIC', admin.id, '2024-08-28 11:00:00+03'::timestamptz, '2024-09-11 11:00:00+03'::timestamptz, 'IN_PROGRESS'
FROM core.applications a, security.users u, security.users admin
WHERE a.application_number = 'APP-2024-003' AND u.username = 'reviewer1' AND admin.username = 'ethics_admin';

-- Application 5 (SUBMITTED) - no reviews yet, just submitted

-- ============================================================
-- REVIEW RECOMMENDATIONS (completed reviews only)
-- ============================================================

-- App 1: Reviewer 1 - Scientific review (approve)
INSERT INTO committee.review_recommendations (application_id, reviewer_id, recommendation_type, justification, created_at)
SELECT a.id, u.id, 'APPROVE', 'المنهجية العلمية مناسبة والأهداف واضحة. الدراسة ذات أهمية سريرية كبيرة.', '2024-04-01 15:00:00+03'::timestamptz
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-001' AND u.username = 'reviewer1';

-- App 1: Reviewer 2 - Ethical review (approve)
INSERT INTO committee.review_recommendations (application_id, reviewer_id, recommendation_type, justification, created_at)
SELECT a.id, u.id, 'APPROVE', 'تم استيفاء جميع المتطلبات الأخلاقية. نموذج الموافقة المستنيرة مناسب.', '2024-04-16 14:00:00+03'::timestamptz
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-001' AND u.username = 'reviewer2';

-- App 1: Reviewer 3 - Ethical review (conditional)
INSERT INTO committee.review_recommendations (application_id, reviewer_id, recommendation_type, justification, created_at)
SELECT a.id, u.id, 'CONDITIONAL', 'أوافق شريطة توضيح آلية حفظ البيانات الحساسة في ملف المريض.', '2024-04-17 10:30:00+03'::timestamptz
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-001' AND u.username = 'reviewer3';

-- App 2: Reviewer 1 - Scientific review (approve)
INSERT INTO committee.review_recommendations (application_id, reviewer_id, recommendation_type, justification, created_at)
SELECT a.id, u.id, 'APPROVE', 'دراسة مهمة في مجال علاج سرطان الثدي. منهجية قوية.', '2024-06-30 12:00:00+03'::timestamptz
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-002' AND u.username = 'reviewer1';

-- App 2: Reviewer 2 - Ethical review (approve)
INSERT INTO committee.review_recommendations (application_id, reviewer_id, recommendation_type, justification, created_at)
SELECT a.id, u.id, 'APPROVE', 'الموافقة المستنيرة شاملة وتغطي جميع الجوانب الأخلاقية.', '2024-07-20 11:00:00+03'::timestamptz
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-002' AND u.username = 'reviewer2';

-- App 2: Reviewer 3 - Ethical review (reject)
INSERT INTO committee.review_recommendations (application_id, reviewer_id, recommendation_type, justification, created_at)
SELECT a.id, u.id, 'REJECT', 'يحتاج توضيح إضافي حول معايير تضمين واستبعاد المرضى في الدراسة.', '2024-07-22 09:00:00+03'::timestamptz
FROM core.applications a, security.users u
WHERE a.application_number = 'APP-2024-002' AND u.username = 'reviewer3';

-- ============================================================
-- REVIEW ANSWERS (for completed reviews with forms)
-- ============================================================

-- Reviewer 1 answers on App 1 (Scientific Review Form)
INSERT INTO committee.review_answers (review_id, review_type, question_id, answer_text, answer_score)
SELECT ra.id, 'SCIENTIFIC', rq.id, 'YES', NULL
FROM committee.review_assignments ra, committee.review_questions rq, committee.review_forms rf
WHERE ra.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND ra.reviewer_id = (SELECT id FROM security.users WHERE username = 'reviewer1')
  AND rq.form_id = rf.id AND rf.form_code = 'SCI_REVIEW_V1' AND rq.question_code = 'SCI_Q01'
UNION ALL
SELECT ra.id, 'SCIENTIFIC', rq.id, NULL, 9
FROM committee.review_assignments ra, committee.review_questions rq, committee.review_forms rf
WHERE ra.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND ra.reviewer_id = (SELECT id FROM security.users WHERE username = 'reviewer1')
  AND rq.form_id = rf.id AND rf.form_code = 'SCI_REVIEW_V1' AND rq.question_code = 'SCI_Q02'
UNION ALL
SELECT ra.id, 'SCIENTIFIC', rq.id, 'YES', NULL
FROM committee.review_assignments ra, committee.review_questions rq, committee.review_forms rf
WHERE ra.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND ra.reviewer_id = (SELECT id FROM security.users WHERE username = 'reviewer1')
  AND rq.form_id = rf.id AND rf.form_code = 'SCI_REVIEW_V1' AND rq.question_code = 'SCI_Q03'
UNION ALL
SELECT ra.id, 'SCIENTIFIC', rq.id, NULL, 8
FROM committee.review_assignments ra, committee.review_questions rq, committee.review_forms rf
WHERE ra.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND ra.reviewer_id = (SELECT id FROM security.users WHERE username = 'reviewer1')
  AND rq.form_id = rf.id AND rf.form_code = 'SCI_REVIEW_V1' AND rq.question_code = 'SCI_Q04';

-- Reviewer 2 answers on App 1 (Ethical Review Form)
INSERT INTO committee.review_answers (review_id, review_type, question_id, answer_text, answer_score)
SELECT ra.id, 'ETHICS', rq.id, 'YES', NULL
FROM committee.review_assignments ra, committee.review_questions rq, committee.review_forms rf
WHERE ra.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND ra.reviewer_id = (SELECT id FROM security.users WHERE username = 'reviewer2')
  AND rq.form_id = rf.id AND rf.form_code = 'ETH_REVIEW_V1' AND rq.question_code = 'ETH_Q01'
UNION ALL
SELECT ra.id, 'ETHICS', rq.id, NULL, 10
FROM committee.review_assignments ra, committee.review_questions rq, committee.review_forms rf
WHERE ra.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND ra.reviewer_id = (SELECT id FROM security.users WHERE username = 'reviewer2')
  AND rq.form_id = rf.id AND rf.form_code = 'ETH_REVIEW_V1' AND rq.question_code = 'ETH_Q02'
UNION ALL
SELECT ra.id, 'ETHICS', rq.id, NULL, 9
FROM committee.review_assignments ra, committee.review_questions rq, committee.review_forms rf
WHERE ra.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND ra.reviewer_id = (SELECT id FROM security.users WHERE username = 'reviewer2')
  AND rq.form_id = rf.id AND rf.form_code = 'ETH_REVIEW_V1' AND rq.question_code = 'ETH_Q03'
UNION ALL
SELECT ra.id, 'ETHICS', rq.id, 'YES', NULL
FROM committee.review_assignments ra, committee.review_questions rq, committee.review_forms rf
WHERE ra.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND ra.reviewer_id = (SELECT id FROM security.users WHERE username = 'reviewer2')
  AND rq.form_id = rf.id AND rf.form_code = 'ETH_REVIEW_V1' AND rq.question_code = 'ETH_Q04'
UNION ALL
SELECT ra.id, 'ETHICS', rq.id, 'NO', NULL
FROM committee.review_assignments ra, committee.review_questions rq, committee.review_forms rf
WHERE ra.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND ra.reviewer_id = (SELECT id FROM security.users WHERE username = 'reviewer2')
  AND rq.form_id = rf.id AND rf.form_code = 'ETH_REVIEW_V1' AND rq.question_code = 'ETH_Q05';

-- Review Comments for App 1
INSERT INTO committee.review_comments (application_id, reviewer_id, comment_text, created_at)
SELECT a.id, u.id, 'الدراسة ممتازة وتتماشى مع أولويات البحث في المملكة.', '2024-04-01 15:30:00+03'::timestamptz
FROM core.applications a, security.users u WHERE a.application_number = 'APP-2024-001' AND u.username = 'reviewer1';

INSERT INTO committee.review_comments (application_id, reviewer_id, comment_text, created_at)
SELECT a.id, u.id, 'يوصى بتوضيح خطة التعامل مع العينات البيولوجية بعد انتهاء الدراسة.', '2024-04-16 14:30:00+03'::timestamptz
FROM core.applications a, security.users u WHERE a.application_number = 'APP-2024-001' AND u.username = 'reviewer2';
