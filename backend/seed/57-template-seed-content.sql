/*
 * 57-template-seed-content.sql
 * =============================
 * Template Content Seed: Representative templates for all categories.
 * Requires: 55-template-schema.sql and 56-template-categories-variables.sql applied first.
 */

-- ============================================================
-- TEMPLATE PARTIALS (shared components)
-- ============================================================
INSERT INTO templates.template_partials (code, name_ar, name_en, engine, content, content_hash, version) VALUES
    ('header_standard', 'رأس الصفحة القياسي', 'Standard Page Header', 'handlebars',
     '<div style="text-align:center;border-bottom:2px solid #1a5276;padding-bottom:10px;margin-bottom:20px;"><h1 style="color:#1a5276;margin:0;">{{institutionNameAr}}</h1><h3 style="color:#2c3e50;margin:5px 0;">{{committeeNameAr}}</h3><p style="font-size:12px;color:#666;">{{committeeAddress}}</p></div>',
     'd41d8cd98f00b204e9800998ecf8427e', '1.0.0'),
    ('header_email', 'رأس البريد الإلكتروني', 'Email Header', 'handlebars',
     '<div style="background:#1a5276;color:white;padding:15px 20px;font-family:Arial,sans-serif;"><h2 style="margin:0;">{{institutionNameAr}}</h2><p style="margin:5px 0 0;font-size:14px;">{{committeeNameAr}}</p></div>',
     'd41d8cd98f00b204e9800998ecf8427e', '1.0.0'),
    ('footer_standard', 'تذييل الصفحة القياسي', 'Standard Page Footer', 'handlebars',
     '<div style="border-top:1px solid #ccc;padding-top:8px;margin-top:30px;font-size:11px;color:#666;text-align:center;"><p>{{committeeNameAr}} – {{institutionNameAr}}</p><p>{{committeeAddress}} | هاتف: {{chairpersonName}}</p><p>تاريخ الطباعة: {{today}}</p></div>',
     'd41d8cd98f00b204e9800998ecf8427e', '1.0.0'),
    ('footer_email', 'تذييل البريد الإلكتروني', 'Email Footer', 'handlebars',
     '<div style="border-top:1px solid #ddd;padding-top:10px;margin-top:20px;font-size:12px;color:#888;font-family:Arial,sans-serif;"><p>هذه الرسالة آلية، يرجى عدم الرد عليها.</p><p>{{institutionNameAr}} – {{committeeNameAr}}</p><p>{{today}}</p></div>',
     'd41d8cd98f00b204e9800998ecf8427e', '1.0.0'),
    ('disclaimer_standard', 'إخلاء مسؤولية', 'Standard Disclaimer', 'handlebars',
     '<div style="border:1px solid #e74c3c;padding:10px;margin:15px 0;background:#fdf2f2;font-size:12px;"><p><strong>تنبيه:</strong> هذا المستند صادر عن {{committeeNameAr}} ويحتوي على معلومات سرية. لا يجوز نسخه أو توزيعه دون إذن خطي.</p></div>',
     'd41d8cd98f00b204e9800998ecf8427e', '1.0.0');

-- ============================================================
-- 1. PROTOCOL — Research Protocol
-- ============================================================
INSERT INTO templates.templates (category_id, code, name_ar, name_en, description, engine, default_locale, default_output_format, variable_sources, tags)
SELECT id, 'protocol-full', 'بروتوكول بحثي كامل', 'Full Research Protocol', 'قالب بروتوكول البحث العلمي المعتمد من اللجنة', 'handlebars', 'ar', 'PDF', $json$[{"source":"application"},{"source":"committee"},{"source":"institution"},{"source":"user"}]$json$::jsonb, ARRAY['PROTOCOL','RESEARCH']
FROM templates.categories WHERE code = 'PROTOCOL';

INSERT INTO templates.template_versions (template_id, version, status, content, content_hash, variable_definitions, change_summary, created_by)
SELECT t.id, '1.0.0', 'DRAFT', $json${
  "ar": {
    "subject": "بروتوكول بحثي",
    "body": "<h2>بروتوكول البحث العلمي</h2><p><strong>رقم المرجع:</strong> {{applicationReferenceNumber}}</p><p><strong>تاريخ التقديم:</strong> {{applicationSubmittedAt}}</p><hr/><h3>معلومات المشروع</h3><table border=\"1\" cellpadding=\"8\" cellspacing=\"0\" style=\"width:100%;border-collapse:collapse;\"><tr><td style=\"width:30%;background:#f5f5f5;\"><strong>عنوان المشروع (عربي)</strong></td><td>{{projectTitleAr}}</td></tr><tr><td style=\"background:#f5f5f5;\"><strong>عنوان المشروع (إنجليزي)</strong></td><td>{{projectTitleEn}}</td></tr><tr><td style=\"background:#f5f5f5;\"><strong>مستوى المخاطر</strong></td><td>{{projectRiskLevel}}</td></tr><tr><td style=\"background:#f5f5f5;\"><strong>مصدر التمويل</strong></td><td>{{projectFundingSource}}</td></tr></table><h3>مقدم الطلب</h3><p><strong>الاسم:</strong> {{applicationSubmittedBy}}</p><p><strong>نوع الطلب:</strong> {{applicationType}}</p><h3>الباحث الرئيسي</h3><p><strong>الاسم:</strong> {{piFullName}}<br/><strong>البريد الإلكتروني:</strong> {{piEmail}}<br/><strong>الهاتف:</strong> {{piPhone}}</p>{{> disclaimer_standard}}<p style=\"text-align:left;\"><strong>تاريخ الطباعة:</strong> {{today}}</p>",
    "en": {
      "subject": "Research Protocol",
      "body": "<h2>Research Protocol</h2><p><strong>Reference:</strong> {{applicationReferenceNumber}}</p><hr/><h3>Project Information</h3><p><strong>Title (Arabic):</strong> {{projectTitleAr}}<br/><strong>Title (English):</strong> {{projectTitleEn}}<br/><strong>Risk Level:</strong> {{projectRiskLevel}}</p><h3>Principal Investigator</h3><p><strong>Name:</strong> {{piFullName}}<br/><strong>Email:</strong> {{piEmail}}</p>"
    }
  }
}$json$::jsonb, 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6',
$json$[{"code":"applicationReferenceNumber","required":true,"description":"رقم المرجع"},{"code":"applicationSubmittedAt","required":false,"description":"تاريخ التقديم"},{"code":"projectTitleAr","required":true,"description":"عنوان المشروع"},{"code":"projectTitleEn","required":false,"description":"عنوان المشروع إنجليزي"},{"code":"projectRiskLevel","required":true,"description":"مستوى المخاطر"},{"code":"applicationSubmittedBy","required":true,"description":"مقدم الطلب"},{"code":"applicationType","required":true,"description":"نوع الطلب"},{"code":"piFullName","required":true,"description":"الباحث الرئيسي"},{"code":"piEmail","required":false,"description":"بريد الباحث"},{"code":"piPhone","required":false,"description":"هاتف الباحث"},{"code":"today","required":true,"description":"تاريخ الطباعة"}]$json$::jsonb,
'النسخة الأولية للبروتوكول البحثي', 1
FROM templates.templates AS t WHERE t.code = 'protocol-full';

-- ============================================================
-- 2. CONSENT — Consent Form
-- ============================================================
INSERT INTO templates.templates (category_id, code, name_ar, name_en, description, engine, default_locale, default_output_format, variable_sources, tags)
SELECT id, 'consent-standard', 'نموذج موافقة مستنيرة', 'Standard Informed Consent', 'نموذج الموافقة المستنيرة للمشاركة في البحث', 'handlebars', 'ar', 'PDF', $json$[{"source":"application"},{"source":"consent"},{"source":"institution"},{"source":"committee"}]$json$::jsonb, ARRAY['CONSENT','INFORMED']
FROM templates.categories WHERE code = 'CONSENT';

INSERT INTO templates.template_versions (template_id, version, status, content, content_hash, variable_definitions, change_summary, created_by)
SELECT t.id, '1.0.0', 'DRAFT', $json${
  "ar": {
    "subject": "نموذج موافقة مستنيرة",
    "body": "<h2>نموذج الموافقة المستنيرة</h2><p><strong>رقم المرجع:</strong> {{applicationReferenceNumber}}</p><hr/><h3>دعوة للمشاركة في البحث</h3><p>أنت مدعو للمشاركة في البحث العلمي بعنوان: <strong>{{projectTitleAr}}</strong></p><h3>نوع الموافقة</h3><p>{{consentType}}</p><h3>حالة الموافقة</h3><p>{{consentStatus}}</p><p><strong>تاريخ التوقيع:</strong> {{consentSignedDate}}</p><h3>معلومات الاتصال</h3><p><strong>اسم الباحث الرئيسي:</strong> {{piFullName}}<br/><strong>الهاتف:</strong> {{piPhone}}<br/><strong>البريد الإلكتروني:</strong> {{piEmail}}</p><p><strong>اللجنة:</strong> {{committeeNameAr}}<br/><strong>رئيس اللجنة:</strong> {{chairpersonName}}</p><hr/><p style=\"text-align:center;\"><strong>المؤسسة:</strong> {{institutionNameAr}}</p><p style=\"text-align:center;\">{{today}}</p>",
    "en": {
      "subject": "Informed Consent Form",
      "body": "<h2>Informed Consent Form</h2><p><strong>Reference:</strong> {{applicationReferenceNumber}}</p><hr/><h3>Research Title</h3><p>{{projectTitleEn}}</p><h3>Consent Type</h3><p>{{consentType}}</p><h3>Status</h3><p>{{consentStatus}}</p>"
    }
  }
}$json$::jsonb, 'b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7',
$json$[{"code":"applicationReferenceNumber","required":true,"description":"رقم المرجع"},{"code":"projectTitleAr","required":true,"description":"عنوان المشروع"},{"code":"projectTitleEn","required":false,"description":"عنوان المشروع إنجليزي"},{"code":"consentType","required":true,"description":"نوع الموافقة"},{"code":"consentStatus","required":true,"description":"حالة الموافقة"},{"code":"consentSignedDate","required":false,"description":"تاريخ التوقيع"},{"code":"piFullName","required":true,"description":"اسم الباحث"},{"code":"piPhone","required":false,"description":"هاتف الباحث"},{"code":"piEmail","required":false,"description":"بريد الباحث"},{"code":"committeeNameAr","required":true,"description":"اسم اللجنة"},{"code":"chairpersonName","required":true,"description":"رئيس اللجنة"},{"code":"institutionNameAr","required":true,"description":"المؤسسة"},{"code":"today","required":true,"description":"تاريخ اليوم"}]$json$::jsonb,
'النسخة الأولية لنموذج الموافقة', 1
FROM templates.templates AS t WHERE t.code = 'consent-standard';

-- ============================================================
-- 3. DECISION — Committee Decision
-- ============================================================
INSERT INTO templates.templates (category_id, code, name_ar, name_en, description, engine, default_locale, default_output_format, variable_sources, tags)
SELECT id, 'decision-standard', 'قرار لجنة', 'Committee Decision', 'قرار لجنة أخلاقيات البحث العلمي بشأن طلب', 'handlebars', 'ar', 'PDF', $json$[{"source":"application"},{"source":"committee"},{"source":"institution"}]$json$::jsonb, ARRAY['DECISION','COMMITTEE']
FROM templates.categories WHERE code = 'DECISION';

INSERT INTO templates.template_versions (template_id, version, status, content, content_hash, variable_definitions, change_summary, created_by)
SELECT t.id, '1.0.0', 'DRAFT', $json${
  "ar": {
    "subject": "قرار لجنة أخلاقيات البحث العلمي",
    "body": "<h2 style=\"text-align:center;\">قرار لجنة أخلاقيات البحث العلمي</h2><p style=\"text-align:center;\"><strong>رقم القرار:</strong> {{decisionNumber}}</p><p style=\"text-align:center;\"><strong>تاريخ القرار:</strong> {{decisionDate}}</p><hr/><h3>بيانات الطلب</h3><table border=\"1\" cellpadding=\"8\" cellspacing=\"0\" style=\"width:100%;border-collapse:collapse;\"><tr><td style=\"width:30%;background:#f5f5f5;\"><strong>رقم المرجع</strong></td><td>{{applicationReferenceNumber}}</td></tr><tr><td style=\"background:#f5f5f5;\"><strong>عنوان البحث</strong></td><td>{{projectTitleAr}}</td></tr><tr><td style=\"background:#f5f5f5;\"><strong>مقدم الطلب</strong></td><td>{{applicationSubmittedBy}}</td></tr><tr><td style=\"background:#f5f5f5;\"><strong>الباحث الرئيسي</strong></td><td>{{piFullName}}</td></tr></table><h3>نتيجة القرار</h3><p style=\"font-size:16px;font-weight:bold;color:#1a5276;\">{{decisionResult}}</p><h3>معلومات اللجنة</h3><p><strong>اللجنة:</strong> {{committeeNameAr}}<br/><strong>رئيس اللجنة:</strong> {{chairpersonName}}</p>{{> footer_standard}}"
  },
  "en": {
    "subject": "Committee Decision",
    "body": "<h2>Research Ethics Committee Decision</h2><p><strong>Decision No:</strong> {{decisionNumber}}<br/><strong>Date:</strong> {{decisionDate}}</p><hr/><p><strong>Reference:</strong> {{applicationReferenceNumber}}</p><p><strong>Result:</strong> {{decisionResult}}</p>"
  }
}$json$::jsonb, 'c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8',
$json$[{"code":"decisionNumber","required":true,"description":"رقم القرار"},{"code":"decisionDate","required":true,"description":"تاريخ القرار"},{"code":"applicationReferenceNumber","required":true,"description":"رقم المرجع"},{"code":"projectTitleAr","required":true,"description":"عنوان البحث"},{"code":"applicationSubmittedBy","required":true,"description":"مقدم الطلب"},{"code":"piFullName","required":true,"description":"الباحث الرئيسي"},{"code":"decisionResult","required":true,"description":"نتيجة القرار"},{"code":"committeeNameAr","required":true,"description":"اسم اللجنة"},{"code":"institutionNameAr","required":true,"description":"المؤسسة"},{"code":"chairpersonName","required":true,"description":"رئيس اللجنة"},{"code":"today","required":true,"description":"تاريخ الطباعة"}]$json$::jsonb,
'النسخة الأولية لقرار اللجنة', 1
FROM templates.templates AS t WHERE t.code = 'decision-standard';

-- ============================================================
-- 4. CERTIFICATE — Certificate
-- ============================================================
INSERT INTO templates.templates (category_id, code, name_ar, name_en, description, engine, default_locale, default_output_format, variable_sources, tags)
SELECT id, 'certificate-approval', 'شهادة اعتماد أخلاقي', 'Ethical Approval Certificate', 'شهادة الاعتماد الأخلاقي للبحث', 'handlebars', 'ar', 'PDF', $json$[{"source":"application"},{"source":"committee"},{"source":"institution"},{"source":"accreditation"}]$json$::jsonb, ARRAY['CERTIFICATE','APPROVAL']
FROM templates.categories WHERE code = 'CERTIFICATE';

INSERT INTO templates.template_versions (template_id, version, status, content, content_hash, variable_definitions, change_summary, created_by)
SELECT t.id, '1.0.0', 'DRAFT', $json${
  "ar": {
    "subject": "شهادة اعتماد أخلاقي",
    "body": "<div style=\"border:4px double #1a5276;padding:30px;text-align:center;\"><h1 style=\"color:#1a5276;\">{{institutionNameAr}}</h1><h3>{{committeeNameAr}}</h3><hr style=\"border:1px solid #1a5276;\"/><h2 style=\"color:#1a5276;\">شهادة اعتماد أخلاقي</h2><p style=\"font-size:16px;\">رقم القرار: <strong>{{decisionNumber}}</strong></p><p style=\"font-size:14px;\">تاريخ القرار: <strong>{{decisionDate}}</strong></p><hr/><h3>البحث المعتمد</h3><p style=\"font-size:16px;\"><strong>{{projectTitleAr}}</strong></p><p><strong>{{projectTitleEn}}</strong></p><table align=\"center\" cellpadding=\"5\"><tr><td style=\"text-align:left;\"><strong>رقم المرجع:</strong></td><td>{{applicationReferenceNumber}}</td></tr><tr><td style=\"text-align:left;\"><strong>مقدم الطلب:</strong></td><td>{{applicationSubmittedBy}}</td></tr><tr><td style=\"text-align:left;\"><strong>الباحث الرئيسي:</strong></td><td>{{piFullName}}</td></tr><tr><td style=\"text-align:left;\"><strong>مستوى المخاطر:</strong></td><td>{{projectRiskLevel}}</td></tr></table><hr/><h3>الاعتماد</h3><p><strong>الحالة:</strong> {{accreditationStatus}}</p><p><strong>صالح حتى:</strong> {{accreditationValidUntil}}</p><br/><p>رئيس اللجنة</p><p><strong>{{chairpersonName}}</strong></p><p>{{committeeNameAr}}</p><p>{{today}}</p></div>",
    "en": {
      "subject": "Ethical Approval Certificate",
      "body": "<div style=\"border:4px double #1a5276;padding:30px;text-align:center;\"><h1>{{institutionNameEn}}</h1><h3>{{committeeNameEn}}</h3><hr/><h2>Ethical Approval Certificate</h2><p><strong>Decision No:</strong> {{decisionNumber}}<br/><strong>Date:</strong> {{decisionDate}}</p><hr/><p><strong>{{projectTitleEn}}</strong></p><p><strong>Reference:</strong> {{applicationReferenceNumber}}</p><p><strong>Status:</strong> {{accreditationStatus}}</p><p><strong>Valid Until:</strong> {{accreditationValidUntil}}</p></div>"
    }
  }
}$json$::jsonb, 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9',
$json$[{"code":"institutionNameAr","required":true,"description":"المؤسسة"},{"code":"committeeNameAr","required":true,"description":"اللجنة"},{"code":"decisionNumber","required":true,"description":"رقم القرار"},{"code":"decisionDate","required":true,"description":"تاريخ القرار"},{"code":"projectTitleAr","required":true,"description":"عنوان البحث"},{"code":"projectTitleEn","required":false,"description":"عنوان البحث إنجليزي"},{"code":"applicationReferenceNumber","required":true,"description":"رقم المرجع"},{"code":"applicationSubmittedBy","required":true,"description":"مقدم الطلب"},{"code":"piFullName","required":true,"description":"الباحث الرئيسي"},{"code":"projectRiskLevel","required":true,"description":"مستوى المخاطر"},{"code":"accreditationStatus","required":true,"description":"حالة الاعتماد"},{"code":"accreditationValidUntil","required":true,"description":"صلاحية الاعتماد"},{"code":"chairpersonName","required":true,"description":"رئيس اللجنة"},{"code":"today","required":true,"description":"تاريخ الإصدار"},{"code":"institutionNameEn","required":false,"description":"المؤسسة إنجليزي"},{"code":"committeeNameEn","required":false,"description":"اللجنة إنجليزي"}]$json$::jsonb,
'النسخة الأولية لشهادة الاعتماد', 1
FROM templates.templates AS t WHERE t.code = 'certificate-approval';

-- ============================================================
-- 5. CONDITION — Condition Letter
-- ============================================================
INSERT INTO templates.templates (category_id, code, name_ar, name_en, description, engine, default_locale, default_output_format, variable_sources, tags)
SELECT id, 'condition-letter', 'خطاب اشتراطات', 'Condition Letter', 'خطاب الاشتراطات والقرارات المشروطة', 'handlebars', 'ar', 'PDF', $json$[{"source":"application"},{"source":"committee"},{"source":"workflow"}]$json$::jsonb, ARRAY['CONDITION','LETTER']
FROM templates.categories WHERE code = 'CONDITION';

INSERT INTO templates.template_versions (template_id, version, status, content, content_hash, variable_definitions, change_summary, created_by)
SELECT t.id, '1.0.0', 'DRAFT', $json${
  "ar": {
    "subject": "خطاب اشتراطات - قرار مشروط",
    "body": "<h2 style=\"text-align:center;\">قرار مشروط</h2><p><strong>رقم المرجع:</strong> {{applicationReferenceNumber}}</p><p><strong>تاريخ القرار:</strong> {{decisionDate}}</p><hr/><h3>السيد/ {{applicationSubmittedBy}}</h3><p>تحية طيبة وبعد،</p><p>بالإشارة إلى طلبكم رقم <strong>{{applicationReferenceNumber}}</strong> والمقدم بتاريخ <strong>{{applicationSubmittedAt}}</strong> بخصوص مشروع <strong>{{projectTitleAr}}</strong>.</p><p>نفيدكم بأن اللجنة وبعد دراسة الطلب قد اتخذت القرار التالي:</p><p style=\"font-size:16px;background:#fef9e7;padding:10px;border-right:4px solid #f1c40f;\"><strong>{{decisionResult}}</strong></p><p>يرجى الالتزام بالاشتراطات المرفقة واستيفاء المتطلبات خلال الفترة المحددة.</p><h3>معلومات المتابعة</h3><p><strong>الحالة الحالية:</strong> {{workflowCurrentState}}<br/><strong>تاريخ الانتقال:</strong> {{workflowTransitionedAt}}</p><p>وتفضلوا بقبول فائق الاحترام،</p><p><strong>{{chairpersonName}}</strong><br/>{{committeeNameAr}}</p>{{> footer_standard}}"
  },
  "en": {
    "subject": "Condition Letter",
    "body": "<h2>Conditional Decision</h2><p><strong>Reference:</strong> {{applicationReferenceNumber}}<br/><strong>Decision Date:</strong> {{decisionDate}}</p><hr/><p>Dear {{applicationSubmittedBy}},</p><p>Regarding your application <strong>{{applicationReferenceNumber}}</strong> for the project <strong>{{projectTitleEn}}</strong>.</p><p>The committee has decided: <strong>{{decisionResult}}</strong></p>"
  }
}$json$::jsonb, 'e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0',
$json$[{"code":"applicationReferenceNumber","required":true,"description":"رقم المرجع"},{"code":"decisionDate","required":true,"description":"تاريخ القرار"},{"code":"applicationSubmittedBy","required":true,"description":"مقدم الطلب"},{"code":"applicationSubmittedAt","required":false,"description":"تاريخ التقديم"},{"code":"projectTitleAr","required":true,"description":"عنوان المشروع"},{"code":"projectTitleEn","required":false,"description":"عنوان المشروع إنجليزي"},{"code":"decisionResult","required":true,"description":"نتيجة القرار"},{"code":"workflowCurrentState","required":true,"description":"الحالة الحالية"},{"code":"workflowTransitionedAt","required":false,"description":"تاريخ الانتقال"},{"code":"chairpersonName","required":true,"description":"رئيس اللجنة"},{"code":"committeeNameAr","required":true,"description":"اللجنة"},{"code":"institutionNameAr","required":true,"description":"المؤسسة"},{"code":"today","required":true,"description":"تاريخ الطباعة"}]$json$::jsonb,
'النسخة الأولية لخطاب الاشتراطات', 1
FROM templates.templates AS t WHERE t.code = 'condition-letter';

-- ============================================================
-- 6. NOTIFICATION — Status Change Notification
-- ============================================================
INSERT INTO templates.templates (category_id, code, name_ar, name_en, description, engine, default_locale, default_output_format, variable_sources, tags)
SELECT id, 'notification-status-change', 'إشعار تغيير الحالة', 'Status Change Notification', 'إشعار بتغيير حالة الطلب', 'handlebars', 'ar', 'EMAIL', $json$[{"source":"application"},{"source":"workflow"},{"source":"user"}]$json$::jsonb, ARRAY['NOTIFICATION','STATUS']
FROM templates.categories WHERE code = 'NOTIFICATION';

INSERT INTO templates.template_versions (template_id, version, status, content, content_hash, variable_definitions, change_summary, created_by)
SELECT t.id, '1.0.0', 'DRAFT', $json${
  "ar": {
    "subject": "تحديث حالة الطلب رقم {{applicationReferenceNumber}}",
    "body": "<h2>تحديث حالة الطلب</h2><p>عزيزي/ {{applicationSubmittedBy}}،</p><p>نود إعلامك بأن حالة طلبك رقم <strong>{{applicationReferenceNumber}}</strong> قد تم تحديثها.</p><table cellpadding=\"5\" style=\"margin:15px 0;\"><tr><td><strong>الحالة السابقة:</strong></td><td>{{workflowPreviousState}}</td></tr><tr><td><strong>الحالة الحالية:</strong></td><td><strong>{{workflowCurrentState}}</strong></td></tr><tr><td><strong>تاريخ التحديث:</strong></td><td>{{workflowTransitionedAt}}</td></tr></table>"
  },
  "en": {
    "subject": "Application Status Update — {{applicationReferenceNumber}}",
    "body": "<h2>Application Status Update</h2><p>Dear {{applicationSubmittedBy}},</p><p>Your application <strong>{{applicationReferenceNumber}}</strong> status has been updated.</p><table cellpadding=\"5\"><tr><td><strong>Previous:</strong></td><td>{{workflowPreviousState}}</td></tr><tr><td><strong>Current:</strong></td><td><strong>{{workflowCurrentState}}</strong></td></tr></table>"
  }
}$json$::jsonb, 'f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1',
$json$[{"code":"applicationReferenceNumber","required":true,"description":"رقم المرجع"},{"code":"applicationSubmittedBy","required":true,"description":"مقدم الطلب"},{"code":"workflowPreviousState","required":false,"description":"الحالة السابقة"},{"code":"workflowCurrentState","required":true,"description":"الحالة الحالية"},{"code":"workflowTransitionedAt","required":false,"description":"تاريخ التحديث"},{"code":"today","required":true,"description":"تاريخ الإرسال"}]$json$::jsonb,
'النسخة الأولية لإشعار تغيير الحالة', 1
FROM templates.templates AS t WHERE t.code = 'notification-status-change';

-- ============================================================
-- 7. EMAIL — Generic Email
-- ============================================================
INSERT INTO templates.templates (category_id, code, name_ar, name_en, description, engine, default_locale, default_output_format, variable_sources, tags)
SELECT id, 'email-generic', 'بريد إلكتروني عام', 'Generic Email', 'قالب بريد إلكتروني عام للمراسلات', 'handlebars', 'ar', 'EMAIL', $json$[{"source":"application"},{"source":"user"},{"source":"committee"}]$json$::jsonb, ARRAY['EMAIL','GENERIC']
FROM templates.categories WHERE code = 'EMAIL';

INSERT INTO templates.template_versions (template_id, version, status, content, content_hash, variable_definitions, change_summary, created_by)
SELECT t.id, '1.0.0', 'DRAFT', $json${
  "ar": {
    "subject": "رسالة من {{committeeNameAr}}",
    "body": "<p>عزيزي/ {{userDisplayName}}،</p><p>{{bodyContent}}</p><hr/><p>للاستفسار، يرجى الاتصال على {{committeeNameAr}}.</p>"
  },
  "en": {
    "subject": "Message from {{committeeNameEn}}",
    "body": "<p>Dear {{userDisplayName}},</p><p>{{bodyContent}}</p>"
  }
}$json$::jsonb, 'a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2',
$json$[{"code":"committeeNameAr","required":true,"description":"اسم اللجنة"},{"code":"committeeNameEn","required":false,"description":"اسم اللجنة إنجليزي"},{"code":"userDisplayName","required":true,"description":"اسم المستخدم"},{"code":"bodyContent","required":true,"description":"محتوى الرسالة"},{"code":"institutionNameAr","required":true,"description":"المؤسسة"},{"code":"today","required":true,"description":"تاريخ الإرسال"}]$json$::jsonb,
'النسخة الأولية للبريد الإلكتروني العام', 1
FROM templates.templates AS t WHERE t.code = 'email-generic';

-- ============================================================
-- 8. REPORT — Annual Report
-- ============================================================
INSERT INTO templates.templates (category_id, code, name_ar, name_en, description, engine, default_locale, default_output_format, variable_sources, tags)
SELECT id, 'report-annual', 'تقرير سنوي', 'Annual Report', 'قالب التقرير السنوي للجنة أخلاقيات البحث', 'handlebars', 'ar', 'PDF', $json$[{"source":"committee"},{"source":"institution"},{"source":"user"}]$json$::jsonb, ARRAY['REPORT','ANNUAL']
FROM templates.categories WHERE code = 'REPORT';

INSERT INTO templates.template_versions (template_id, version, status, content, content_hash, variable_definitions, change_summary, created_by)
SELECT t.id, '1.0.0', 'DRAFT', $json${
  "ar": {
    "subject": "تقرير سنوي",
    "body": "<h2 style=\"text-align:center;\">تقرير سنوي</h2><p style=\"text-align:center;\">{{committeeNameAr}} – {{institutionNameAr}}</p><p style=\"text-align:center;\">السنة: {{reportYear}}</p><hr/><h3>ملخص تنفيذي</h3><p>{{executiveSummary}}</p><h3>الإحصائيات</h3><table border=\"1\" cellpadding=\"8\" cellspacing=\"0\" style=\"width:100%;border-collapse:collapse;\"><tr style=\"background:#1a5276;color:white;\"><th>البيان</th><th>العدد</th></tr><tr><td>إجمالي الطلبات المستلمة</td><td>{{totalApplications}}</td></tr><tr><td>الطلبات المعتمدة</td><td>{{approvedApplications}}</td></tr><tr><td>الطلبات المرفوضة</td><td>{{rejectedApplications}}</td></tr><tr><td>الطلبات قيد المراجعة</td><td>{{pendingApplications}}</td></tr></table><p style=\"text-align:left;\">{{today}}</p>{{> footer_standard}}"
  }
}$json$::jsonb, 'b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3',
$json$[{"code":"committeeNameAr","required":true,"description":"اسم اللجنة"},{"code":"institutionNameAr","required":true,"description":"المؤسسة"},{"code":"reportYear","required":true,"description":"السنة"},{"code":"executiveSummary","required":true,"description":"الملخص التنفيذي"},{"code":"totalApplications","required":true,"description":"إجمالي الطلبات"},{"code":"approvedApplications","required":true,"description":"الطلبات المعتمدة"},{"code":"rejectedApplications","required":true,"description":"الطلبات المرفوضة"},{"code":"pendingApplications","required":true,"description":"الطلبات قيد المراجعة"},{"code":"chairpersonName","required":true,"description":"رئيس اللجنة"},{"code":"today","required":true,"description":"تاريخ التقرير"}]$json$::jsonb,
'النسخة الأولية للتقرير السنوي', 1
FROM templates.templates AS t WHERE t.code = 'report-annual';

-- ============================================================
-- 9. MEETING — Meeting Minutes
-- ============================================================
INSERT INTO templates.templates (category_id, code, name_ar, name_en, description, engine, default_locale, default_output_format, variable_sources, tags)
SELECT id, 'meeting-minutes', 'محضر اجتماع', 'Meeting Minutes', 'محضر اجتماع لجنة أخلاقيات البحث العلمي', 'handlebars', 'ar', 'PDF', $json$[{"source":"committee"},{"source":"meeting"}]$json$::jsonb, ARRAY['MEETING','MINUTES']
FROM templates.categories WHERE code = 'MEETING';

INSERT INTO templates.template_versions (template_id, version, status, content, content_hash, variable_definitions, change_summary, created_by)
SELECT t.id, '1.0.0', 'DRAFT', $json${
  "ar": {
    "subject": "محضر اجتماع",
    "body": "<h2 style=\"text-align:center;\">محضر اجتماع</h2><p style=\"text-align:center;\"><strong>التاريخ:</strong> {{meetingDate}}</p><hr/><h3>الحضور</h3><p>رئيس اللجنة: {{chairpersonName}}</p><p>أعضاء: {{committeeNameAr}}</p><hr/><h3>جدول الأعمال</h3><p>{{meetingAgenda}}</p><hr/><h3>القرارات</h3><p>{{meetingDecisions}}</p><p style=\"text-align:left;\">تم المحضر في: {{today}}</p>{{> footer_standard}}"
  }
}$json$::jsonb, 'c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4',
$json$[{"code":"meetingDate","required":true,"description":"تاريخ الاجتماع"},{"code":"chairpersonName","required":true,"description":"رئيس اللجنة"},{"code":"committeeNameAr","required":true,"description":"اللجنة"},{"code":"meetingAgenda","required":false,"description":"جدول الأعمال"},{"code":"meetingDecisions","required":true,"description":"القرارات"},{"code":"institutionNameAr","required":true,"description":"المؤسسة"},{"code":"today","required":true,"description":"تاريخ المحضر"}]$json$::jsonb,
'النسخة الأولية لمحضر الاجتماع', 1
FROM templates.templates AS t WHERE t.code = 'meeting-minutes';

-- ============================================================
-- 10. RISK — Risk Assessment
-- ============================================================
INSERT INTO templates.templates (category_id, code, name_ar, name_en, description, engine, default_locale, default_output_format, variable_sources, tags)
SELECT id, 'risk-assessment', 'تقييم مخاطر', 'Risk Assessment', 'تقرير تقييم مخاطر البحث', 'handlebars', 'ar', 'PDF', $json$[{"source":"application"},{"source":"risk"},{"source":"committee"}]$json$::jsonb, ARRAY['RISK','ASSESSMENT']
FROM templates.categories WHERE code = 'RISK';

INSERT INTO templates.template_versions (template_id, version, status, content, content_hash, variable_definitions, change_summary, created_by)
SELECT t.id, '1.0.0', 'DRAFT', $json${
  "ar": {
    "subject": "تقرير تقييم المخاطر",
    "body": "<h2 style=\"text-align:center;\">تقرير تقييم المخاطر</h2><p><strong>رقم المرجع:</strong> {{applicationReferenceNumber}}</p><hr/><h3>معلومات المشروع</h3><p><strong>العنوان:</strong> {{projectTitleAr}}<br/><strong>الباحث الرئيسي:</strong> {{piFullName}}</p><h3>نتيجة تقييم المخاطر</h3><table border=\"1\" cellpadding=\"8\" cellspacing=\"0\" style=\"width:100%;border-collapse:collapse;\"><tr><td style=\"width:40%;background:#f5f5f5;\"><strong>الدرجة الإجمالية</strong></td><td>{{riskOverallScore}}</td></tr><tr><td style=\"background:#f5f5f5;\"><strong>مستوى المخاطرة</strong></td><td><strong>{{riskLevel}}</strong></td></tr></table><h3>خطة التخفيف</h3><p>{{riskMitigationPlan}}</p>{{> footer_standard}}"
  },
  "en": {
    "subject": "Risk Assessment Report",
    "body": "<h2>Risk Assessment Report</h2><p><strong>Reference:</strong> {{applicationReferenceNumber}}</p><hr/><p><strong>Project:</strong> {{projectTitleEn}}<br/><strong>PI:</strong> {{piFullName}}</p><p><strong>Score:</strong> {{riskOverallScore}}<br/><strong>Level:</strong> {{riskLevel}}</p>"
  }
}$json$::jsonb, 'd0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5',
$json$[{"code":"applicationReferenceNumber","required":true,"description":"رقم المرجع"},{"code":"projectTitleAr","required":true,"description":"عنوان المشروع"},{"code":"projectTitleEn","required":false,"description":"عنوان المشروع إنجليزي"},{"code":"piFullName","required":true,"description":"الباحث الرئيسي"},{"code":"riskOverallScore","required":true,"description":"الدرجة الإجمالية"},{"code":"riskLevel","required":true,"description":"مستوى المخاطرة"},{"code":"riskMitigationPlan","required":false,"description":"خطة التخفيف"},{"code":"institutionNameAr","required":true,"description":"المؤسسة"},{"code":"committeeNameAr","required":true,"description":"اللجنة"},{"code":"today","required":true,"description":"تاريخ التقرير"}]$json$::jsonb,
'النسخة الأولية لتقييم المخاطر', 1
FROM templates.templates AS t WHERE t.code = 'risk-assessment';

-- ============================================================
-- 11. ACCREDITATION — Accreditation Certificate
-- ============================================================
INSERT INTO templates.templates (category_id, code, name_ar, name_en, description, engine, default_locale, default_output_format, variable_sources, tags)
SELECT id, 'accreditation-cert', 'وثيقة اعتماد مؤسسي', 'Institutional Accreditation', 'وثيقة الاعتماد المؤسسي للجنة أخلاقيات البحث', 'handlebars', 'ar', 'PDF', $json$[{"source":"accreditation"},{"source":"institution"},{"source":"committee"}]$json$::jsonb, ARRAY['ACCREDITATION','INSTITUTIONAL']
FROM templates.categories WHERE code = 'ACCREDITATION';

INSERT INTO templates.template_versions (template_id, version, status, content, content_hash, variable_definitions, change_summary, created_by)
SELECT t.id, '1.0.0', 'DRAFT', $json${
  "ar": {
    "subject": "وثيقة اعتماد مؤسسي",
    "body": "<div style=\"border:4px double #1a5276;padding:40px;text-align:center;\"><h1 style=\"color:#1a5276;\">{{institutionNameAr}}</h1><h2>وثيقة اعتماد مؤسسي</h2><hr/><p style=\"font-size:14px;\">نشهد بأن</p><h3>{{organizationNameAr}}</h3><p style=\"font-size:14px;\"><strong>{{organizationNameEn}}</strong></p><p>قد حصلت على الاعتماد المؤسسي من {{committeeNameAr}}</p><table align=\"center\" cellpadding=\"5\" style=\"margin:15px auto;\"><tr><td><strong>حالة الاعتماد:</strong></td><td>{{accreditationStatus}}</td></tr><tr><td><strong>صالح حتى:</strong></td><td>{{accreditationValidUntil}}</td></tr></table><hr/><p>رئيس اللجنة</p><p style=\"font-size:16px;\"><strong>{{chairpersonName}}</strong></p><p>{{today}}</p></div>",
    "en": {
      "subject": "Institutional Accreditation Certificate",
      "body": "<div style=\"border:4px double #1a5276;padding:40px;text-align:center;\"><h1>{{institutionNameEn}}</h1><h2>Institutional Accreditation</h2><hr/><h3>{{organizationNameEn}}</h3><p>is hereby accredited by {{committeeNameEn}}</p><p><strong>Status:</strong> {{accreditationStatus}}<br/><strong>Valid Until:</strong> {{accreditationValidUntil}}</p></div>"
    }
  }
}$json$::jsonb, 'e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6',
$json$[{"code":"institutionNameAr","required":true,"description":"المؤسسة"},{"code":"institutionNameEn","required":false,"description":"المؤسسة إنجليزي"},{"code":"organizationNameAr","required":true,"description":"المنظمة"},{"code":"organizationNameEn","required":false,"description":"المنظمة إنجليزي"},{"code":"committeeNameAr","required":true,"description":"اللجنة"},{"code":"committeeNameEn","required":false,"description":"اللجنة إنجليزي"},{"code":"accreditationStatus","required":true,"description":"حالة الاعتماد"},{"code":"accreditationValidUntil","required":true,"description":"صلاحية الاعتماد"},{"code":"chairpersonName","required":true,"description":"رئيس اللجنة"},{"code":"today","required":true,"description":"تاريخ الإصدار"}]$json$::jsonb,
'النسخة الأولية لشهادة الاعتماد المؤسسي', 1
FROM templates.templates AS t WHERE t.code = 'accreditation-cert';

-- ============================================================
-- 12. SAFETY — Safety Report
-- ============================================================
INSERT INTO templates.templates (category_id, code, name_ar, name_en, description, engine, default_locale, default_output_format, variable_sources, tags)
SELECT id, 'safety-report', 'تقرير سلامة', 'Safety Report', 'تقرير سلامة المشاركين والأحداث الجسيمة', 'handlebars', 'ar', 'PDF', $json$[{"source":"application"},{"source":"committee"},{"source":"risk"}]$json$::jsonb, ARRAY['SAFETY','REPORT']
FROM templates.categories WHERE code = 'SAFETY';

INSERT INTO templates.template_versions (template_id, version, status, content, content_hash, variable_definitions, change_summary, created_by)
SELECT t.id, '1.0.0', 'DRAFT', $json${
  "ar": {
    "subject": "تقرير سلامة المشاركين",
    "body": "<h2 style=\"text-align:center;\">تقرير سلامة المشاركين</h2><p><strong>رقم المرجع:</strong> {{applicationReferenceNumber}}</p><hr/><h3>معلومات المشروع</h3><p><strong>العنوان:</strong> {{projectTitleAr}}<br/><strong>مستوى المخاطر:</strong> {{projectRiskLevel}}<br/><strong>الباحث الرئيسي:</strong> {{piFullName}}</p><h3>تفاصيل التقرير</h3><p><strong>نوع الحدث:</strong> {{safetyEventType}}<br/><strong>تاريخ الحدث:</strong> {{safetyEventDate}}<br/><strong>وصف الحدث:</strong> {{safetyEventDescription}}</p><h3>الإجراءات المتخذة</h3><p>{{safetyActionTaken}}</p><h3>التوصيات</h3><p>{{safetyRecommendations}}</p>{{> footer_standard}}"
  }
}$json$::jsonb, 'f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7',
$json$[{"code":"applicationReferenceNumber","required":true,"description":"رقم المرجع"},{"code":"projectTitleAr","required":true,"description":"عنوان المشروع"},{"code":"projectRiskLevel","required":true,"description":"مستوى المخاطر"},{"code":"piFullName","required":true,"description":"الباحث الرئيسي"},{"code":"safetyEventType","required":true,"description":"نوع الحدث"},{"code":"safetyEventDate","required":true,"description":"تاريخ الحدث"},{"code":"safetyEventDescription","required":true,"description":"وصف الحدث"},{"code":"safetyActionTaken","required":true,"description":"الإجراءات المتخذة"},{"code":"safetyRecommendations","required":true,"description":"التوصيات"},{"code":"institutionNameAr","required":true,"description":"المؤسسة"},{"code":"committeeNameAr","required":true,"description":"اللجنة"},{"code":"today","required":true,"description":"تاريخ التقرير"}]$json$::jsonb,
'النسخة الأولية لتقرير السلامة', 1
FROM templates.templates AS t WHERE t.code = 'safety-report';
