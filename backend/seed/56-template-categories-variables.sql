/*
 * 56-template-categories-variables.sql
 * =====================================
 *
 * البيانات الأولية لمحرك القوالب: التصنيفات والمتغيرات.
 * Template Engine Seed Data: Categories and Variables.
 *
 * يجب تطبيق هذا الملف بعد 55-template-schema.sql.
 */

-- ============================================================
-- CATEGORIES
-- ============================================================
INSERT INTO templates.categories (code, name_ar, name_en, description, default_output_format, approval_required, sort_order) VALUES
    ('PROTOCOL', 'بروتوكول بحثي', 'Research Protocol', 'قوالب بروتوكولات البحث العلمي', 'PDF', true, 1),
    ('CONSENT', 'نموذج موافقة', 'Consent Form', 'نماذج الموافقة المستنيرة للمشاركين في البحث', 'PDF', true, 2),
    ('DECISION', 'قرار لجنة', 'Committee Decision', 'قرارات لجنة أخلاقيات البحث العلمي', 'PDF', true, 3),
    ('CERTIFICATE', 'شهادة اعتماد', 'Certificate', 'شهادات الاعتماد الأخلاقي للبحوث', 'PDF', true, 4),
    ('CONDITION', 'خطاب اشتراط', 'Condition Letter', 'خطابات الاشتراطات والقرارات المشروطة', 'PDF', true, 5),
    ('NOTIFICATION', 'إشعار', 'Notification', 'الإشعارات والتنبيهات النظامية', 'EMAIL', false, 6),
    ('EMAIL', 'بريد إلكتروني', 'Email', 'قوالب رسائل البريد الإلكتروني', 'EMAIL', false, 7),
    ('REPORT', 'تقرير', 'Report', 'التقارير الدورية والإحصائية', 'PDF', true, 8),
    ('MEETING', 'اجتماع', 'Meeting', 'محاضر الاجتماعات وجداول الأعمال', 'PDF', true, 9),
    ('RISK', 'تقييم مخاطر', 'Risk Assessment', 'تقارير تقييم المخاطر', 'PDF', true, 10),
    ('ACCREDITATION', 'اعتماد', 'Accreditation', 'وثائق الاعتماد المؤسسي', 'PDF', true, 11),
    ('SAFETY', 'سلامة', 'Safety', 'تقارير سلامة المشاركين والأحداث الجسيمة', 'PDF', true, 12);

-- ============================================================
-- TEMPLATE VARIABLES (Registry)
-- ============================================================
INSERT INTO templates.template_variables (code, name_ar, name_en, type, source_type, resolver_path, entity_whitelist_root, required, description_ar, description_en) VALUES
    -- Application variables
    ('applicationTitle', 'عنوان الطلب', 'Application Title', 'string', 'entity', 'application.title', 'application', true, 'عنوان الطلب المقدم', 'Title of the submitted application'),
    ('applicationReferenceNumber', 'رقم المرجع', 'Reference Number', 'string', 'entity', 'application.referenceNumber', 'application', true, 'رقم المرجع الخاص بالطلب', 'Application reference number'),
    ('applicationCurrentStatus', 'الحالة الحالية', 'Current Status', 'string', 'entity', 'application.currentStatus', 'application', true, 'الحالة الحالية للطلب', 'Current workflow status of the application'),
    ('applicationSubmittedAt', 'تاريخ التقديم', 'Submission Date', 'date', 'entity', 'application.submittedAt', 'application', false, 'تاريخ تقديم الطلب', 'Date the application was submitted'),
    ('applicationSubmittedBy', 'اسم مقدم الطلب', 'Applicant Name', 'string', 'entity', 'application.submittedBy', 'application', true, 'اسم الشخص الذي قدم الطلب', 'Name of the applicant who submitted the application'),
    ('applicationType', 'نوع الطلب', 'Application Type', 'string', 'entity', 'application.applicationType', 'application', true, 'نوع الطلب (جديد، تعديل، تمديد)', 'Application type (new, amendment, extension)'),

    -- Project variables
    ('projectTitleAr', 'عنوان المشروع (عربي)', 'Project Title (Arabic)', 'string', 'entity', 'application.project.titleAr', 'application', true, 'عنوان المشروع باللغة العربية', 'Project title in Arabic'),
    ('projectTitleEn', 'عنوان المشروع (إنجليزي)', 'Project Title (English)', 'string', 'entity', 'application.project.titleEn', 'application', false, 'عنوان المشروع باللغة الإنجليزية', 'Project title in English'),
    ('projectRiskLevel', 'مستوى المخاطر', 'Risk Level', 'string', 'entity', 'application.project.riskLevel', 'application', true, 'مستوى مخاطر المشروع', 'Project risk level'),
    ('projectFundingSource', 'مصدر التمويل', 'Funding Source', 'string', 'entity', 'application.project.fundingSource', 'application', false, 'مصدر تمويل المشروع', 'Source of project funding'),

    -- PI / Applicant variables
    ('piFullName', 'اسم الباحث الرئيسي', 'PI Full Name', 'string', 'entity', 'application.principalInvestigator.fullName', 'application', true, 'الاسم الكامل للباحث الرئيسي', 'Full name of the principal investigator'),
    ('piEmail', 'البريد الإلكتروني للباحث', 'PI Email', 'string', 'entity', 'application.principalInvestigator.email', 'application', false, 'البريد الإلكتروني للباحث الرئيسي', 'Email of the principal investigator'),
    ('piPhone', 'هاتف الباحث', 'PI Phone', 'string', 'entity', 'application.principalInvestigator.phone', 'application', false, 'رقم هاتف الباحث الرئيسي', 'Phone number of the principal investigator'),

    -- Committee variables
    ('committeeNameAr', 'اسم اللجنة (عربي)', 'Committee Name (Arabic)', 'string', 'entity', 'committee.nameAr', 'committee', true, 'اسم اللجنة باللغة العربية', 'Committee name in Arabic'),
    ('committeeNameEn', 'اسم اللجنة (إنجليزي)', 'Committee Name (English)', 'string', 'entity', 'committee.nameEn', 'committee', false, 'اسم اللجنة باللغة الإنجليزية', 'Committee name in English'),
    ('committeeAddress', 'عنوان اللجنة', 'Committee Address', 'string', 'entity', 'committee.address', 'committee', false, 'العنوان البريدي للجنة', 'Postal address of the committee'),
    ('chairpersonName', 'اسم رئيس اللجنة', 'Chairperson Name', 'string', 'entity', 'committee.chair.fullName', 'committee', true, 'اسم رئيس اللجنة', 'Name of the committee chairperson'),

    -- Institution variables
    ('institutionNameAr', 'اسم المؤسسة (عربي)', 'Institution Name (Arabic)', 'string', 'entity', 'institution.nameAr', 'institution', true, 'اسم المؤسسة باللغة العربية', 'Institution name in Arabic'),
    ('institutionNameEn', 'اسم المؤسسة (إنجليزي)', 'Institution Name (English)', 'string', 'entity', 'institution.nameEn', 'institution', false, 'اسم المؤسسة باللغة الإنجليزية', 'Institution name in English'),

    -- Workflow variables
    ('workflowCurrentState', 'الحالة الحالية لسير العمل', 'Workflow Current State', 'string', 'entity', 'workflow.currentState', 'workflow', true, 'الحالة الحالية في سير العمل', 'Current state in the workflow'),
    ('workflowPreviousState', 'الحالة السابقة', 'Previous State', 'string', 'entity', 'workflow.previousState', 'workflow', false, 'الحالة السابقة في سير العمل', 'Previous workflow state'),
    ('workflowTransitionedAt', 'تاريخ الانتقال', 'Transition Date', 'date', 'entity', 'workflow.transitionedAt', 'workflow', false, 'تاريخ الانتقال بين الحالات', 'Date of state transition'),

    -- Consent variables
    ('consentType', 'نوع الموافقة', 'Consent Type', 'string', 'entity', 'consent.type', 'consent', true, 'نوع الموافقة (شخص بالغ، ولي أمر، طارئ)', 'Consent type (adult, guardian, emergency)'),
    ('consentStatus', 'حالة الموافقة', 'Consent Status', 'string', 'entity', 'consent.status', 'consent', true, 'حالة الموافقة (مُوقّع، معلق)', 'Consent status (signed, pending)'),
    ('consentSignedDate', 'تاريخ التوقيع', 'Signed Date', 'date', 'entity', 'consent.signedDate', 'consent', false, 'تاريخ توقيع الموافقة', 'Date of consent signing'),

    -- Risk variables
    ('riskOverallScore', 'الدرجة الإجمالية', 'Overall Score', 'number', 'entity', 'risk.overallScore', 'risk', true, 'الدرجة الإجمالية لتقييم المخاطر', 'Overall risk assessment score'),
    ('riskLevel', 'مستوى المخاطرة', 'Risk Level', 'string', 'entity', 'risk.level', 'risk', true, 'مستوى المخاطرة (منخفض، متوسط، مرتفع)', 'Risk level (low, medium, high)'),
    ('riskMitigationPlan', 'خطة التخفيف', 'Mitigation Plan', 'string', 'entity', 'risk.mitigationPlan', 'risk', false, 'خطة تخفيف المخاطر', 'Risk mitigation plan'),

    -- Accreditation variables
    ('accreditationStatus', 'حالة الاعتماد', 'Accreditation Status', 'string', 'entity', 'accreditation.status', 'accreditation', true, 'حالة الاعتماد (ممنوح، معلق، ملغي)', 'Accreditation status (granted, suspended, revoked)'),
    ('accreditationValidUntil', 'صلاحية الاعتماد حتى', 'Valid Until', 'date', 'entity', 'accreditation.validUntil', 'accreditation', true, 'تاريخ انتهاء صلاحية الاعتماد', 'Accreditation expiry date'),

    -- User variables
    ('userDisplayName', 'اسم المستخدم', 'User Display Name', 'string', 'context', NULL, NULL, true, 'اسم المستخدم المعروض', 'Display name of the current user'),
    ('userEmail', 'البريد الإلكتروني', 'User Email', 'string', 'context', NULL, NULL, false, 'البريد الإلكتروني للمستخدم الحالي', 'Email of the current user'),
    ('userTitle', 'المسمى الوظيفي', 'User Title', 'string', 'context', NULL, NULL, false, 'المسمى الوظيفي للمستخدم', 'Job title of the current user'),

    -- Decision variables
    ('decisionNumber', 'رقم القرار', 'Decision Number', 'string', 'entity', 'application.decision.number', 'application', true, 'رقم قرار اللجنة', 'Committee decision number'),
    ('decisionDate', 'تاريخ القرار', 'Decision Date', 'date', 'entity', 'application.decision.date', 'application', true, 'تاريخ إصدار القرار', 'Decision issue date'),
    ('decisionResult', 'نتيجة القرار', 'Decision Result', 'string', 'entity', 'application.decision.result', 'application', true, 'نتيجة القرار (موافقة، رفض، تعديلات)', 'Decision result (approved, rejected, changes)'),

    -- Meeting variables
    ('meetingDate', 'تاريخ الاجتماع', 'Meeting Date', 'date', 'entity', 'meeting.date', 'meeting', true, 'تاريخ اجتماع اللجنة', 'Committee meeting date'),
    ('meetingAgenda', 'جدول الأعمال', 'Agenda', 'string', 'entity', 'meeting.agenda', 'meeting', false, 'جدول أعمال الاجتماع', 'Meeting agenda'),

    -- Review variables
    ('reviewResult', 'نتيجة المراجعة', 'Review Result', 'string', 'entity', 'review.result', 'review', true, 'نتيجة مراجعة الطلب', 'Application review result'),
    ('reviewComments', 'تعليقات المراجعة', 'Review Comments', 'string', 'entity', 'review.comments', 'review', false, 'تعليقات المراجع على الطلب', 'Reviewer comments on the application'),

    -- Organization
    ('organizationNameAr', 'اسم المنظمة (عربي)', 'Organization Name (Arabic)', 'string', 'entity', 'organization.nameAr', 'organization', true, 'اسم المنظمة باللغة العربية', 'Organization name in Arabic'),
    ('organizationNameEn', 'اسم المنظمة (إنجليزي)', 'Organization Name (English)', 'string', 'entity', 'organization.nameEn', 'organization', false, 'اسم المنظمة باللغة الإنجليزية', 'Organization name in English'),

    -- Timestamp variables (context)
    ('today', 'تاريخ اليوم', 'Current Date', 'date', 'context', NULL, NULL, true, 'تاريخ اليوم الحالي', 'Current date'),
    ('currentTime', 'الوقت الحالي', 'Current Time', 'string', 'context', NULL, NULL, false, 'الوقت الحالي', 'Current time');
