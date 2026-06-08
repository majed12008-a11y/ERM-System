-- ============================================================
-- 09-MEETINGS, AGENDA, ATTENDANCE, MINUTES
-- ============================================================

-- Meeting 1: Past meeting that approved App 1
INSERT INTO committee.committee_meetings (committee_id, meeting_number, meeting_date, location, meeting_status, chairperson_id)
SELECT c.id, 'IRB-MTG-2024-001', '2024-05-20 13:00:00+03'::timestamptz, 'قاعة الاجتماعات الرئيسية - مبنى الإدارة', 'COMPLETED', u.id
FROM committee.committees c, security.users u
WHERE c.committee_code = 'IRB-KSU-01' AND u.username = 'chairperson';

-- Meeting 2: Upcoming meeting for App 2 and 3
INSERT INTO committee.committee_meetings (committee_id, meeting_number, meeting_date, location, meeting_status, chairperson_id)
SELECT c.id, 'IRB-MTG-2024-002', '2024-10-15 13:00:00+03'::timestamptz, 'قاعة الاجتماعات الرئيسية - مبنى الإدارة', 'SCHEDULED', u.id
FROM committee.committees c, security.users u
WHERE c.committee_code = 'IRB-KSU-01' AND u.username = 'chairperson';

-- Meeting 3: Past meeting
INSERT INTO committee.committee_meetings (committee_id, meeting_number, meeting_date, location, meeting_status, chairperson_id)
SELECT c.id, 'IRB-MTG-2024-003', '2024-08-19 13:00:00+03'::timestamptz, 'قاعة الاجتماعات الرئيسية - مبنى الإدارة', 'COMPLETED', u.id
FROM committee.committees c, security.users u
WHERE c.committee_code = 'IRB-KSU-01' AND u.username = 'chairperson';

-- ============================================================
-- AGENDA
-- ============================================================

-- Agenda for Meeting 1
INSERT INTO committee.meeting_agendas (meeting_id, title, description)
SELECT m.id, 'استعراض ومناقشة طلب APP-2024-001 - دراسة الوارفارين', 'مناقشة نتائج المراجعة العلمية والأخلاقية والتصويت على الطلب'
FROM committee.committee_meetings m WHERE m.meeting_number = 'IRB-MTG-2024-001'
UNION ALL
SELECT m.id, 'مراجعة محاضر الاجتماع السابق', 'اعتماد محضر الاجتماع السابق ومناقشة التوصيات'
FROM committee.committee_meetings m WHERE m.meeting_number = 'IRB-MTG-2024-001';

-- Agenda for Meeting 2
INSERT INTO committee.meeting_agendas (meeting_id, title, description)
SELECT m.id, 'مناقشة طلب APP-2024-002 - علاج سرطان الثدي', 'مراجعة نتائج التقييم العلمي والأخلاقي والتصويت'
FROM committee.committee_meetings m WHERE m.meeting_number = 'IRB-MTG-2024-002'
UNION ALL
SELECT m.id, 'مناقشة طلب APP-2024-003 - التعديل على دراسة سرطان الثدي', 'مراجعة طلب التعديل المقدم'
FROM committee.committee_meetings m WHERE m.meeting_number = 'IRB-MTG-2024-002'
UNION ALL
SELECT m.id, 'تحديثات السياسات والإجراءات', 'مناقشة آخر التحديثات في سياسات اللجنة'
FROM committee.committee_meetings m WHERE m.meeting_number = 'IRB-MTG-2024-002';

-- Agenda for Meeting 3
INSERT INTO committee.meeting_agendas (meeting_id, title, description)
SELECT m.id, 'استعراض ومناقشة طلب APP-2024-002 - دراسة سرطان الثدي', 'المراجعة الأولية للطلب'
FROM committee.committee_meetings m WHERE m.meeting_number = 'IRB-MTG-2024-003';

-- ============================================================
-- ATTENDANCE
-- ============================================================

-- Attendance for Meeting 1
INSERT INTO committee.attendance_logs (meeting_id, user_id, attendance_status, check_in_time)
SELECT m.id, u.id, 'PRESENT', '2024-05-20 12:55:00+03'::timestamptz
FROM committee.committee_meetings m, security.users u
WHERE m.meeting_number = 'IRB-MTG-2024-001' AND u.username = 'chairperson'
UNION ALL
SELECT m.id, u.id, 'PRESENT', '2024-05-20 12:50:00+03'::timestamptz
FROM committee.committee_meetings m, security.users u
WHERE m.meeting_number = 'IRB-MTG-2024-001' AND u.username = 'reviewer1'
UNION ALL
SELECT m.id, u.id, 'PRESENT', '2024-05-20 12:45:00+03'::timestamptz
FROM committee.committee_meetings m, security.users u
WHERE m.meeting_number = 'IRB-MTG-2024-001' AND u.username = 'reviewer2'
UNION ALL
SELECT m.id, u.id, 'ABSENT', NULL
FROM committee.committee_meetings m, security.users u
WHERE m.meeting_number = 'IRB-MTG-2024-001' AND u.username = 'reviewer3'
UNION ALL
SELECT m.id, u.id, 'PRESENT', '2024-05-20 12:55:00+03'::timestamptz
FROM committee.committee_meetings m, security.users u
WHERE m.meeting_number = 'IRB-MTG-2024-001' AND u.username = 'ethics_admin';

-- ============================================================
-- MINUTES
-- ============================================================

-- Minutes for Meeting 1
INSERT INTO committee.meeting_minutes (meeting_id, minutes_text, created_by)
SELECT m.id, 'عُقد الاجتماع الأول للجنة المؤسسية لمراجعة الأخلاقيات بتاريخ 20 مايو 2024.
تمت مناقشة الطلب APP-2024-001 (تأثير العوامل الوراثية على استجابة المرضى لدواء الوارفارين).
بعد العرض والتقييم، تمت الموافقة على الطلب بالإجماع.', u.id
FROM committee.committee_meetings m, security.users u
WHERE m.meeting_number = 'IRB-MTG-2024-001' AND u.username = 'chairperson';

-- ============================================================
-- VOTING SESSIONS AND VOTES
-- ============================================================

-- Voting Session for Meeting 1 (App 1)
INSERT INTO committee.voting_sessions (application_id, meeting_id, voting_type, voting_start, voting_end, status_code)
SELECT a.id, m.id, 'STANDARD', '2024-05-20 14:00:00+03'::timestamptz, '2024-05-20 14:30:00+03'::timestamptz, 'CLOSED'
FROM core.applications a, committee.committee_meetings m
WHERE a.application_number = 'APP-2024-001' AND m.meeting_number = 'IRB-MTG-2024-001';

-- Votes for Session
INSERT INTO committee.votes (voting_session_id, voter_id, vote_value, vote_time, comments)
SELECT vs.id, u.id, 'APPROVE', '2024-05-20 14:15:00+03'::timestamptz, 'دراسة مهمة ومنهجية قوية'
FROM committee.voting_sessions vs, security.users u
WHERE vs.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND u.username = 'chairperson'
UNION ALL
SELECT vs.id, u.id, 'APPROVE', '2024-05-20 14:10:00+03'::timestamptz, 'أوافق على الطلب'
FROM committee.voting_sessions vs, security.users u
WHERE vs.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND u.username = 'reviewer1'
UNION ALL
SELECT vs.id, u.id, 'APPROVE', '2024-05-20 14:20:00+03'::timestamptz, 'موافق مع التوصية بتوضيح آلية حفظ البيانات'
FROM committee.voting_sessions vs, security.users u
WHERE vs.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND u.username = 'reviewer2'
UNION ALL
SELECT vs.id, u.id, 'CONDITIONAL', '2024-05-20 14:05:00+03'::timestamptz, 'أوافق شريطة تعديل نموذج الموافقة'
FROM committee.voting_sessions vs, security.users u
WHERE vs.application_id = (SELECT id FROM core.applications WHERE application_number = 'APP-2024-001')
  AND u.username = 'ethics_admin';

-- Voting Session for Meeting 2 (not yet held - OPEN for App 2)
INSERT INTO committee.voting_sessions (application_id, meeting_id, voting_type, voting_start, voting_end, status_code)
SELECT a.id, m.id, 'STANDARD', '2024-10-15 14:00:00+03'::timestamptz, '2024-10-15 14:30:00+03'::timestamptz, 'OPEN'
FROM core.applications a, committee.committee_meetings m
WHERE a.application_number = 'APP-2024-002' AND m.meeting_number = 'IRB-MTG-2024-002';

-- Voting Session for Meeting 2 (App 3 - OPEN)
INSERT INTO committee.voting_sessions (application_id, meeting_id, voting_type, voting_start, voting_end, status_code)
SELECT a.id, m.id, 'STANDARD', '2024-10-15 14:30:00+03'::timestamptz, '2024-10-15 15:00:00+03'::timestamptz, 'OPEN'
FROM core.applications a, committee.committee_meetings m
WHERE a.application_number = 'APP-2024-003' AND m.meeting_number = 'IRB-MTG-2024-002';

-- ============================================================
-- NOTIFICATIONS
-- ============================================================

INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, is_read, created_at)
SELECT u.id, 'APPLICATION_STATUS', 'تم تقديم الطلب APP-2024-001 بنجاح',
  'تم تقديم طلب المراجعة الأخلاقية لمشروع "تأثير العوامل الوراثية على استجابة المرضى لدواء الوارفارين" بنجاح.',
  true, '2024-03-15 09:00:00+03'::timestamptz
FROM security.users u WHERE u.username = 'researcher1';

INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, is_read, created_at)
SELECT u.id, 'APPLICATION_STATUS', 'تمت الموافقة على الطلب APP-2024-001',
  'يسرنا إعلامكم بموافقة اللجنة المؤسسية على طلبكم رقم APP-2024-001.',
  true, '2024-05-20 15:00:00+03'::timestamptz
FROM security.users u WHERE u.username = 'researcher1';

INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, is_read, created_at)
SELECT u.id, 'REVIEW_ASSIGNMENT', 'تم تعيينك كمراجع للطلب APP-2024-002',
  'تم تعيينكم كمراجع علمي للطلب APP-2024-002 (تقييم فعالية العلاج المناعي لدى مرضى سرطان الثدي). يرجى تقديم مراجعتكم قبل 2024-07-02.',
  false, '2024-06-18 11:00:00+03'::timestamptz
FROM security.users u WHERE u.username = 'reviewer1';

INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, is_read, created_at)
SELECT u.id, 'REVIEW_ASSIGNMENT', 'تم تعيينك كمراجع للطلب APP-2024-002',
  'تم تعيينكم كمراجع أخلاقي للطلب APP-2024-002. يرجى تقديم مراجعتكم قبل 2024-07-24.',
  true, '2024-07-10 10:00:00+03'::timestamptz
FROM security.users u WHERE u.username = 'reviewer2';

INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, is_read, created_at)
SELECT u.id, 'REVIEW_ASSIGNMENT', 'تم تعيينك كمراجع للطلب APP-2024-002',
  'تم تعيينكم كمراجع أخلاقي للطلب APP-2024-002.',
  false, '2024-07-10 10:00:00+03'::timestamptz
FROM security.users u WHERE u.username = 'reviewer3';

INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, is_read, created_at)
SELECT u.id, 'MEETING_REMINDER', 'تذكير: اجتماع اللجنة المقرر',
  'يُذكركم باجتماع اللجنة المؤسسية المقرر يوم 2024-10-15 الساعة 1:00 مساءً في قاعة الاجتماعات الرئيسية.',
  false, '2024-10-10 09:00:00+03'::timestamptz
FROM security.users u WHERE u.username IN ('chairperson', 'reviewer1', 'reviewer2', 'reviewer3', 'ethics_admin');

INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, is_read, created_at)
SELECT u.id, 'APPLICATION_STATUS', 'تم تقديم الطلب APP-2024-005',
  'تم تقديم طلب المراجعة المستعجلة APP-2024-005 بنجاح.',
  true, '2024-09-25 11:15:00+03'::timestamptz
FROM security.users u WHERE u.username = 'researcher2';

-- ============================================================
-- MESSAGES
-- ============================================================

INSERT INTO communication.messages (sender_id, subject, message_body, created_at)
SELECT u.id, 'استفسار حول طلب APP-2024-001',
  'السلام عليكم، أود الاستفسار عن حالة طلبي المقدم بخصوص دراسة الوارفارين. هل هناك أي تحديثات؟',
  '2024-04-10 10:00:00+03'::timestamptz
FROM security.users u WHERE u.username = 'researcher1';

INSERT INTO communication.message_recipients (message_id, recipient_id)
SELECT m.id, u.id
FROM communication.messages m, security.users u
WHERE m.subject LIKE 'استفسار حول طلب%' AND u.username = 'ethics_admin';

INSERT INTO communication.messages (sender_id, subject, message_body, created_at)
SELECT u.id, 'رد: استفسار حول طلب APP-2024-001',
  'وعليكم السلام، الطلب قيد المراجعة العلمية وقد تم تعيين المراجعين. سيتم إعلامكم عند اكتمال المراجعة.',
  '2024-04-10 14:00:00+03'::timestamptz
FROM security.users u WHERE u.username = 'ethics_admin';

INSERT INTO communication.message_recipients (message_id, recipient_id)
SELECT m2.id, u.id
FROM communication.messages m2, security.users u
WHERE m2.subject LIKE 'رد: استفسار حول طلب%' AND u.username = 'researcher1';

-- ============================================================
-- DOCUMENTS
-- ============================================================

-- Document type IDs
DO $$
DECLARE
  v_proto_id bigint; v_icf_id bigint; v_cv_id bigint; v_irb_id bigint;
  v_app1_id bigint; v_user_id bigint;
BEGIN
  SELECT id INTO v_proto_id FROM documents.document_types WHERE type_code = 'PROTOCOL';
  SELECT id INTO v_icf_id FROM documents.document_types WHERE type_code = 'ICF';
  SELECT id INTO v_cv_id FROM documents.document_types WHERE type_code = 'CV';
  SELECT id INTO v_irb_id FROM documents.document_types WHERE type_code = 'IRB_APPROVAL';
  SELECT id INTO v_user_id FROM security.users WHERE username = 'researcher1';

  -- Documents for App 1
  SELECT id INTO v_app1_id FROM core.applications WHERE application_number = 'APP-2024-001';

  INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, uploaded_by)
  VALUES (v_proto_id, 'Application', v_app1_id, 'بروتوكول البحث - دراسة الوارفارين', 'protocol_warfarin_v2.pdf', 'protocol_warfarin_v2.pdf', 'application/pdf', 245760, 'uploads/documents/protocol_warfarin_v2.pdf', v_user_id);

  INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, uploaded_by)
  VALUES (v_icf_id, 'Application', v_app1_id, 'نموذج الموافقة المستنيرة - وارفارين', 'icf_warfarin.pdf', 'icf_warfarin.pdf', 'application/pdf', 102400, 'uploads/documents/icf_warfarin.pdf', v_user_id);

  INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, uploaded_by)
  VALUES (v_cv_id, 'Application', v_app1_id, 'السيرة الذاتية - الباحث الرئيسي', 'cv_researcher1.pdf', 'cv_researcher1.pdf', 'application/pdf', 158720, 'uploads/documents/cv_researcher1.pdf', v_user_id);

  INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, uploaded_by)
  VALUES (v_irb_id, 'Application', v_app1_id, 'خطاب الموافقة IRB - دراسة الوارفارين', 'irb_approval_warfarin.pdf', 'irb_approval_warfarin.pdf', 'application/pdf', 89000, 'uploads/documents/irb_approval_warfarin.pdf', (SELECT id FROM security.users WHERE username = 'ethics_admin'));

  -- Documents for App 2
  SELECT id INTO v_app1_id FROM core.applications WHERE application_number = 'APP-2024-002';

  INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, uploaded_by)
  VALUES (v_proto_id, 'Application', v_app1_id, 'بروتوكول البحث - علاج سرطان الثدي', 'protocol_breast_cancer_v1.pdf', 'protocol_breast_cancer_v1.pdf', 'application/pdf', 312000, 'uploads/documents/protocol_breast_cancer_v1.pdf', v_user_id);

  INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, uploaded_by)
  VALUES (v_icf_id, 'Application', v_app1_id, 'نموذج الموافقة المستنيرة - سرطان الثدي', 'icf_breast_cancer.pdf', 'icf_breast_cancer.pdf', 'application/pdf', 115200, 'uploads/documents/icf_breast_cancer.pdf', v_user_id);
END $$;
