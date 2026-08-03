-- ============================================================
-- 58-official-templates-en.sql
-- ============================================================
-- قوالب المستندات الرسمية الإنجليزية لكل الوثائق الرسمية،
-- والقوالب الأساسية الناقصة (متابعة/محضر/تقدم) بالعربية والإنجليزية.
-- الأجزاء (body) تُغلَّف بواسطة محرك المستندات.
-- Idempotent.
-- ============================================================

-- ============================================================
-- 1. Review Form Output — English
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'REVIEW_FORM_DOC', 'Scientific Review Form', 'HTML',
  $tpl$<div class="letter-body" dir="ltr">
  <div class="review-meta">
    <span class="label">Reviewer:</span> {{reviewerName}}
    <span class="label">Date:</span> {{reviewDate}}
    <span class="label">Application No:</span> {{applicationNumber}}
    {{#if totalScore}}<span class="label">Total Score:</span> {{totalScore}} / 5{{/if}}
  </div>
  {{#each sections}}
    <h3 class="section-heading">{{title}}</h3>
    <table class="doc-section">
      <tbody>
        {{#each rows}}<tr><td class="field-label">{{label}}</td><td>{{value}}</td></tr>{{/each}}
      </tbody>
    </table>
  {{/each}}
  <p class="signature-note">Reviewer Signature</p>
</div>$tpl$,
  1, true, 'en', 'REVIEW_FORM', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 2. Safety (SAE) Report — English
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'SAFETY_REPORT_DOC', 'Serious Adverse Event Report', 'HTML',
  $tpl$<div class="letter-body" dir="ltr">
  <div class="review-meta">
    <span class="label">Report No:</span> {{documentNumber}}
    <span class="label">Application No:</span> {{applicationNumber}}
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
  1, true, 'en', 'SAFETY_REPORT', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 3. Closure Report — English
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'CLOSURE_REPORT_DOC', 'Study Closure Report', 'HTML',
  $tpl$<div class="letter-body" dir="ltr">
  <div class="review-meta">
    <span class="label">Application No:</span> {{applicationNumber}}
    <span class="label">Date:</span> {{issueDateEn}}
  </div>
  {{#each sections}}
    <h3 class="section-heading">{{title}}</h3>
    <table class="doc-section">
      <tbody>
        {{#each rows}}<tr><td class="field-label">{{label}}</td><td>{{value}}</td></tr>{{/each}}
      </tbody>
    </table>
  {{/each}}
  <p class="signature-note">Principal Investigator Signature</p>
</div>$tpl$,
  1, true, 'en', 'CLOSURE_REPORT', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 4. Monitoring Report — Arabic
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'MONITORING_REPORT_DOC', 'تقرير المراقبة الميداني', 'HTML',
  $tpl$<div class="letter-body" dir="rtl">
  <div class="review-meta">
    <span class="label">رقم التقرير:</span> {{documentNumber}}
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
  {{#if correctiveActions.length}}
  <h3 class="section-heading">الإجراءات التصحيحية</h3>
  <ol class="conditions-list">
    {{#each correctiveActions}}<li>{{this}}</li>{{/each}}
  </ol>
  {{/if}}
  <p class="signature-note">توقيع المراقب / Monitor Signature</p>
</div>$tpl$,
  1, true, 'ar', 'MONITORING_REPORT', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 5. Monitoring Report — English
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'MONITORING_REPORT_DOC', 'Site Monitoring Report', 'HTML',
  $tpl$<div class="letter-body" dir="ltr">
  <div class="review-meta">
    <span class="label">Report No:</span> {{documentNumber}}
    <span class="label">Application No:</span> {{applicationNumber}}
    <span class="label">Date:</span> {{issueDateEn}}
  </div>
  {{#each sections}}
    <h3 class="section-heading">{{title}}</h3>
    <table class="doc-section">
      <tbody>
        {{#each rows}}<tr><td class="field-label">{{label}}</td><td>{{value}}</td></tr>{{/each}}
      </tbody>
    </table>
  {{/each}}
  {{#if correctiveActions.length}}
  <h3 class="section-heading">Corrective Actions</h3>
  <ol class="conditions-list">
    {{#each correctiveActions}}<li>{{this}}</li>{{/each}}
  </ol>
  {{/if}}
  <p class="signature-note">Monitor Signature</p>
</div>$tpl$,
  1, true, 'en', 'MONITORING_REPORT', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 6. Meeting Minutes — Arabic
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'MEETING_MINUTES_DOC', 'محضر اجتماع اللجنة', 'HTML',
  $tpl$<div class="letter-body" dir="rtl">
  <div class="review-meta">
    <span class="label">مرجع الاجتماع:</span> {{meetingReference}}
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
  <p class="signature-note">رئيس اللجنة / Committee Chair</p>
</div>$tpl$,
  1, true, 'ar', 'MEETING_DOCUMENT', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 7. Meeting Minutes — English
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'MEETING_MINUTES_DOC', 'Committee Meeting Minutes', 'HTML',
  $tpl$<div class="letter-body" dir="ltr">
  <div class="review-meta">
    <span class="label">Meeting Reference:</span> {{meetingReference}}
    <span class="label">Date:</span> {{issueDateEn}}
  </div>
  {{#each sections}}
    <h3 class="section-heading">{{title}}</h3>
    <table class="doc-section">
      <tbody>
        {{#each rows}}<tr><td class="field-label">{{label}}</td><td>{{value}}</td></tr>{{/each}}
      </tbody>
    </table>
  {{/each}}
  <p class="signature-note">Committee Chair</p>
</div>$tpl$,
  1, true, 'en', 'MEETING_DOCUMENT', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 8. Progress Report — Arabic
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'PROGRESS_REPORT_DOC', 'تقرير التقدم', 'HTML',
  $tpl$<div class="letter-body" dir="rtl">
  <div class="review-meta">
    <span class="label">رقم التقرير:</span> {{documentNumber}}
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
  <p class="signature-note">الباحث الرئيسي / Principal Investigator</p>
</div>$tpl$,
  1, true, 'ar', 'MONITORING_REPORT', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;

-- ============================================================
-- 9. Progress Report — English
-- ============================================================
INSERT INTO documents.templates
  (template_code, template_name, template_type, template_content, version_no, is_active, language, document_category, is_default)
VALUES (
  'PROGRESS_REPORT_DOC', 'Progress Report', 'HTML',
  $tpl$<div class="letter-body" dir="ltr">
  <div class="review-meta">
    <span class="label">Report No:</span> {{documentNumber}}
    <span class="label">Application No:</span> {{applicationNumber}}
    <span class="label">Date:</span> {{issueDateEn}}
  </div>
  {{#each sections}}
    <h3 class="section-heading">{{title}}</h3>
    <table class="doc-section">
      <tbody>
        {{#each rows}}<tr><td class="field-label">{{label}}</td><td>{{value}}</td></tr>{{/each}}
      </tbody>
    </table>
  {{/each}}
  <p class="signature-note">Principal Investigator</p>
</div>$tpl$,
  1, true, 'en', 'MONITORING_REPORT', true
)
ON CONFLICT (template_code, language, version_no) DO NOTHING;
