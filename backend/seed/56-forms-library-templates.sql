-- ============================================================
-- 56-forms-library-templates.sql
-- ============================================================
-- قوالب المستندات الرسمية (أجزاء body) تُغلَّف بواسطة محرك
-- المستندات في الهيكل الرسمي (ترويسة/رقم/QR/توقيع/تذييل).
-- المتغيرات: documentNumber, documentTitle, issueDateAr/En,
-- qrCodeDataUrl, verifyUrl, committeeNameAr/En, institutionNameAr/En,
-- issuingAuthorityAr/En, sections[], signatories[], conditions[],
-- decisionSummary, bodyParagraphs[], appealNotice, lang, dir ...
-- Idempotent.
-- ============================================================

-- ============================================================
-- 1. Official Decision Letter — Arabic
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'DECISION_LETTER', 'خطاب القرار الرسمي', 'HTML',
  $tpl$<div class="letter-body" dir="rtl">
  <p class="recipient-line">
    <span class="label">المستلم:</span> {{recipientName}}
    <span class="label">رقم الطلب:</span> {{applicationNumber}}
  </p>
  <p class="salutation">السلام عليكم ورحمة الله وبركاته،</p>
  <div class="decision-summary">{{decisionSummary}}</div>
  {{#each bodyParagraphs}}<p class="body-para">{{this}}</p>{{/each}}
  {{#if conditions.length}}
  <h3 class="section-heading">الاشتراطات / Conditions</h3>
  <ol class="conditions-list">
    {{#each conditions}}<li>{{text}}{{#if category}} <em>({{category}})</em>{{/if}}</li>{{/each}}
  </ol>
  {{/if}}
  {{#if sections.length}}
  <h3 class="section-heading">تفاصيل القرار / Decision Details</h3>
  {{#each sections}}
    <table class="doc-section">
      <thead><tr><th colspan="2">{{title}}</th></tr></thead>
      <tbody>
        {{#each rows}}<tr><td class="field-label">{{label}}</td><td>{{value}}</td></tr>{{/each}}
      </tbody>
    </table>
  {{/each}}
  {{/if}}
  {{#if appealNotice}}<p class="appeal-note">{{appealNotice}}</p>{{/if}}
  <p class="signature-note">وتفضلوا بقبول فائق الاحترام والتقدير،</p>
</div>$tpl$,
  1, true, 'ar', 'OFFICIAL_LETTER', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 2. Official Decision Letter — English
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'DECISION_LETTER', 'Official Decision Letter', 'HTML',
  $tpl$<div class="letter-body" dir="ltr">
  <p class="recipient-line">
    <span class="label">To:</span> {{recipientName}}
    <span class="label">Application No:</span> {{applicationNumber}}
  </p>
  <p class="salutation">Dear Recipient,</p>
  <div class="decision-summary">{{decisionSummary}}</div>
  {{#each bodyParagraphs}}<p class="body-para">{{this}}</p>{{/each}}
  {{#if conditions.length}}
  <h3 class="section-heading">Conditions</h3>
  <ol class="conditions-list">
    {{#each conditions}}<li>{{text}}{{#if category}} <em>({{category}})</em>{{/if}}</li>{{/each}}
  </ol>
  {{/if}}
  {{#if sections.length}}
  <h3 class="section-heading">Decision Details</h3>
  {{#each sections}}
    <table class="doc-section">
      <thead><tr><th colspan="2">{{title}}</th></tr></thead>
      <tbody>
        {{#each rows}}<tr><td class="field-label">{{label}}</td><td>{{value}}</td></tr>{{/each}}
      </tbody>
    </table>
  {{/each}}
  {{/if}}
  {{#if appealNotice}}<p class="appeal-note">{{appealNotice}}</p>{{/if}}
  <p class="signature-note">Yours faithfully,</p>
</div>$tpl$,
  1, true, 'en', 'OFFICIAL_LETTER', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 3. Review Form Output — Arabic
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'REVIEW_FORM_DOC', 'نموذج المراجعة العلمية', 'HTML',
  $tpl$<div class="letter-body" dir="rtl">
  <div class="review-meta">
    <span class="label">المراجع:</span> {{reviewerName}}
    <span class="label">التاريخ:</span> {{reviewDate}}
    <span class="label">رقم الطلب:</span> {{applicationNumber}}
    {{#if totalScore}}<span class="label">مجموع التقييم:</span> {{totalScore}} / 5{{/if}}
  </div>
  {{#each sections}}
    <h3 class="section-heading">{{title}}</h3>
    <table class="doc-section">
      <tbody>
        {{#each rows}}<tr><td class="field-label">{{label}}</td><td>{{value}}</td></tr>{{/each}}
      </tbody>
    </table>
  {{/each}}
  <p class="signature-note">توقيع المراجع / Reviewer Signature</p>
</div>$tpl$,
  1, true, 'ar', 'REVIEW_FORM', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 4. Safety (SAE) Report — Arabic
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'SAFETY_REPORT_DOC', 'تقرير الحدث العكسي الخطير', 'HTML',
  $tpl$<div class="letter-body" dir="rtl">
  <div class="review-meta">
    <span class="label">رقم التقرير:</span> {{documentNumber}}
    <span class="label">رقم الطلب:</span> {{applicationNumber}}
  </div>
  {{#each sections}}
    <h3 class="section-heading">{{title}}</h3>
    <table class="doc-section">
      <tbody>
        {{#each rows}}<tr><td class="field-label">{{label}}</td><td>{{value}}</td></tr>{{/each}}
      </tbody>
    </table>
  {{/each}}
</div>$tpl$,
  1, true, 'ar', 'SAFETY_REPORT', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 5. Closure Report — Arabic
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'CLOSURE_REPORT_DOC', 'تقرير إغلاق الدراسة', 'HTML',
  $tpl$<div class="letter-body" dir="rtl">
  <div class="review-meta">
    <span class="label">رقم الطلب:</span> {{applicationNumber}}
    <span class="label">التاريخ:</span> {{issueDateAr}}
  </div>
  {{#each sections}}
    <h3 class="section-heading">{{title}}</h3>
    <table class="doc-section">
      <tbody>
        {{#each rows}}<tr><td class="field-label">{{label}}</td><td>{{value}}</td></tr>{{/each}}
      </tbody>
    </table>
  {{/each}}
  <p class="signature-note">توقيع الباحث الرئيسي / Principal Investigator Signature</p>
</div>$tpl$,
  1, true, 'ar', 'CLOSURE_REPORT', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;
