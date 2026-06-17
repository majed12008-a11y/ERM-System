-- ============================================================
-- 19-ADDITIONAL COMMUNICATION DATA: announcements,
--    notification_channels, notification_templates, notification_logs
-- ============================================================

BEGIN;

-- ============================================================
-- NOTIFICATION CHANNELS
-- ============================================================
INSERT INTO communication.notification_channels (channel_code, channel_name, is_active) VALUES
  ('IN_APP', 'إشعار داخل التطبيق', true),
  ('EMAIL', 'البريد الإلكتروني', true),
  ('SMS', 'رسالة نصية', true),
  ('SYSTEM', 'إشعار النظام', true),
  ('PUSH', 'إشعار فوري', false);

-- ============================================================
-- NOTIFICATION TEMPLATES
-- ============================================================
INSERT INTO communication.notification_templates (template_code, template_name, channel_type, subject_template, body_template, is_active) VALUES
  ('APP_SUBMITTED', 'تقديم طلب جديد', 'IN_APP',
   'تم تقديم الطلب {{application_number}}',
   'تم تقديم طلب المراجعة الأخلاقية {{application_number}} لمشروع "{{project_title}}" بنجاح. سيتم مراجعة الطلب من قبل اللجنة.',
   true),
  ('APP_APPROVED', 'الموافقة على الطلب', 'IN_APP',
   'تمت الموافقة على الطلب {{application_number}}',
   'يسرنا إعلامكم بموافقة اللجنة المؤسسية على طلبكم رقم {{application_number}}. يمكنكم الاطلاع على القرار من خلال النظام.',
   true),
  ('APP_REJECTED', 'رفض الطلب', 'IN_APP',
   'الطلب {{application_number}} - قرار اللجنة',
   'نأسف لإعلامكم بأن اللجنة قررت رفض الطلب {{application_number}}. يمكنكم الاطلاع على أسباب الرفض وتقديم طلب استئناف.',
   true),
  ('REVIEW_ASSIGNED', 'تعيين مراجع', 'IN_APP',
   'تم تعيينك كمراجع للطلب {{application_number}}',
   'تم تعيينكم كمراجع للطلب {{application_number}}. يرجى تقديم مراجعتكم قبل تاريخ {{deadline}}.',
   true),
  ('REVIEW_SUBMITTED', 'تقديم مراجعة', 'IN_APP',
   'تم تقديم مراجعة للطلب {{application_number}}',
   'قام {{reviewer_name}} بتقديم مراجعة للطلب {{application_number}}. يمكنكم الاطلاع عليها من خلال النظام.',
   true),
  ('MEETING_REMINDER', 'تذكير باجتماع', 'IN_APP',
   'تذكير: اجتماع اللجنة المقرر {{meeting_date}}',
   'يُذكركم باجتماع اللجنة المقرر يوم {{meeting_date}} الساعة {{meeting_time}} في {{location}}.',
   true),
  ('SAE_REPORTED', 'تبليغ عن حدث سلبي خطير', 'IN_APP',
   'تبليغ عن حدث سلبي خطير - {{application_number}}',
   'تم تسجيل حدث سلبي خطير في الدراسة {{application_number}}. يرجى مراجعة التفاصيل واتخاذ الإجراءات اللازمة.',
   true),
  ('DEADLINE_REMINDER', 'تذكير بموعد تسليم', 'IN_APP',
   'تذكير: الموعد النهائي لتقديم {{item_type}}',
   'نذكركم بأن الموعد النهائي لتقديم {{item_type}} للطلب {{application_number}} هو {{deadline}}.',
   true);

-- ============================================================
-- ANNOUNCEMENTS
-- ============================================================
INSERT INTO communication.announcements (title, announcement_body, start_date, end_date, is_active, created_by)
SELECT 'تحديث سياسات اللجنة المؤسسية لمراجعة الأخلاقيات',
  'يسر اللجنة المؤسسية لمراجعة الأخلاقيات الإعلان عن تحديث سياسات وإجراءات تقديم الطلبات. اعتباراً من 1 نوفمبر 2024، يجب تقديم جميع الطلبات عبر النظام الإلكتروني الجديد. للاستفسارات يرجى التواصل مع مكتب اللجنة.',
  '2024-10-01'::date, '2024-11-30'::date, true,
  u.id
FROM security.users u WHERE u.username = 'ethics_admin';

INSERT INTO communication.announcements (title, announcement_body, start_date, end_date, is_active, created_by)
SELECT 'ورشة عمل: أساسيات الممارسة السريرية الجيدة (GCP)',
  'تنظم اللجنة ورشة عمل حول أساسيات الممارسة السريرية الجيدة (GCP) للباحثين. التاريخ: 15-16 نوفمبر 2024. المكان: قاعة المحاضرات الرئيسية. للتسجيل يرجى التواصل مع مكتب اللجنة.',
  '2024-10-15'::date, '2024-11-16'::date, true,
  u.id
FROM security.users u WHERE u.username = 'ethics_admin';

INSERT INTO communication.announcements (title, announcement_body, start_date, end_date, is_active, created_by)
SELECT 'مواعيد اجتماعات اللجنة للربع الرابع 2024',
  'نعلن عن مواعيد اجتماعات اللجنة للربع الرابع من عام 2024: الاجتماع الرابع: 15 أكتوبر، الاجتماع الخامس: 19 نوفمبر، الاجتماع السادس: 17 ديسمبر. جميع الاجتماعات تبدأ الساعة 1:00 ظهراً في قاعة الاجتماعات الرئيسية.',
  '2024-09-20'::date, '2024-12-20'::date, true,
  u.id
FROM security.users u WHERE u.username = 'chairperson';

INSERT INTO communication.announcements (title, announcement_body, start_date, end_date, is_active, created_by)
SELECT 'إيقاف استقبال طلبات المراجعة خلال عطلة عيد الفطر',
  'نود إعلامكم بأن مكتب اللجنة سيكون مغلقاً خلال عطلة عيد الفطر المبارك من 10 إلى 15 أبريل 2025. سيتوقف استقبال الطلبات خلال هذه الفترة. نتمنى للجميع عيداً مباركاً.',
  '2025-04-01'::date, '2025-04-20'::date, true,
  u.id
FROM security.users u WHERE u.username = 'ethics_admin';

-- ============================================================
-- NOTIFICATION LOGS (delivery records for existing notifications)
-- ============================================================
INSERT INTO communication.notification_logs (notification_id, delivery_status, provider_reference, error_message, logged_at)
SELECT n.id, 'DELIVERED', 'INAPP-REF-001', NULL, n.created_at + interval '1 minute'
FROM communication.notifications n
WHERE n.subject LIKE '%APP-2024-001%' AND n.notification_type = 'APPLICATION_STATUS' AND n.subject LIKE '%تقديم%';

INSERT INTO communication.notification_logs (notification_id, delivery_status, provider_reference, error_message, logged_at)
SELECT n.id, 'DELIVERED', 'INAPP-REF-002', NULL, n.created_at + interval '1 minute'
FROM communication.notifications n
WHERE n.subject LIKE '%APP-2024-001%' AND n.notification_type = 'APPLICATION_STATUS' AND n.subject LIKE '%الموافقة%';

INSERT INTO communication.notification_logs (notification_id, delivery_status, provider_reference, error_message, logged_at)
SELECT n.id, 'DELIVERED', 'INAPP-REF-003', NULL, n.created_at + interval '30 seconds'
FROM communication.notifications n
WHERE n.subject LIKE '%الطلب APP-2024-002%' AND n.notification_type = 'REVIEW_ASSIGNMENT' AND n.subject LIKE '%مراجع علمي%';

INSERT INTO communication.notification_logs (notification_id, delivery_status, provider_reference, error_message, logged_at)
SELECT n.id, 'DELIVERED', 'INAPP-REF-004', NULL, n.created_at + interval '30 seconds'
FROM communication.notifications n
WHERE n.subject LIKE '%الطلب APP-2024-002%' AND n.notification_type = 'REVIEW_ASSIGNMENT' AND n.subject LIKE '%مراجع أخلاقي%' AND n.is_read = true;

INSERT INTO communication.notification_logs (notification_id, delivery_status, provider_reference, error_message, logged_at)
SELECT n.id, 'DELIVERED', 'INAPP-REF-005', NULL, n.created_at + interval '30 seconds'
FROM communication.notifications n
WHERE n.subject LIKE '%الطلب APP-2024-002%' AND n.notification_type = 'REVIEW_ASSIGNMENT' AND n.subject LIKE '%مراجع أخلاقي%' AND n.is_read = false;

INSERT INTO communication.notification_logs (notification_id, delivery_status, provider_reference, error_message, logged_at)
SELECT n.id, 'DELIVERED', 'INAPP-REF-006', NULL, n.created_at + interval '5 minutes'
FROM communication.notifications n
WHERE n.subject LIKE '%اجتماع اللجنة%';

INSERT INTO communication.notification_logs (notification_id, delivery_status, provider_reference, error_message, logged_at)
SELECT n.id, 'DELIVERED', 'INAPP-REF-007', NULL, n.created_at + interval '1 minute'
FROM communication.notifications n
WHERE n.subject LIKE '%APP-2024-005%' AND n.notification_type = 'APPLICATION_STATUS';

COMMIT;
