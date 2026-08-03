# ERM-System Forms Library — JSON Schemas (v2)

> Version 2.0 · 2026-08-02
> JSON Schema (draft 2020-12) for each v2 form, stored in `forms.form_definitions.form_schema`. The renderer interprets these; the backend validates submissions against them.
> **v2 reconciliation (2026-08-02):** 8 forms are seeded in the live DB (all `schema_version 1.0.0`, renderer `schema-form`): `ADMIN_SCREENING`, `SCI_REVIEW_PRIMARY`, `ETH_REVIEW`, `ANNUAL_PROGRESS`, `SAE_REPORT`, `SITE_MONITORING`, `STUDY_CLOSURE`, `COMM_MINUTES`. Full schemas for the four flagship forms are reproduced below (verified against seed `55-forms-library.sql`). Field types available to the renderer: `text/textarea/number/date/boolean/select/radio/scale`; `email/tel/file/checkbox` and `placeholder/default/help/multiline/step/readOnly/hidden` are **target** additions (see `08-ui-specs.md`). `computed.total_score` is UI-supported (live score) but **not yet server-materialized** — target.

---

## 1. FRM-003 — Scientific Review (Primary/Secondary Reviewer Assessment)

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "formCode": "SCI_REVIEW_PRIMARY",
  "version": "1.0.0",
  "sections": [
    {
      "id": "reviewer",
      "title": { "ar": "بيانات المراجع", "en": "Reviewer Information" },
      "fields": [
        { "name": "reviewer_name", "label": { "ar": "اسم المراجع", "en": "Reviewer Name" }, "type": "text", "required": true, "maxLength": 200 },
        { "name": "review_date", "label": { "ar": "تاريخ المراجعة", "en": "Review Date" }, "type": "date", "required": true },
        { "name": "application_number", "label": { "ar": "رقم الطلب", "en": "Application Number" }, "type": "text", "required": true, "pattern": "^REC-\\d{4}-\\d{6}$" }
      ]
    },
    {
      "id": "scientific_merit",
      "title": { "ar": "الجدارة العلمية", "en": "Scientific Merit" },
      "fields": [
        { "name": "objectives_clarity", "label": { "ar": "وضوح الأهداف", "en": "Clarity of Objectives" }, "type": "scale", "required": true, "min": 1, "max": 5 },
        { "name": "study_design", "label": { "ar": "تصميم الدراسة", "en": "Study Design" }, "type": "select", "required": true,
          "options": [
            { "value": "RCT", "label": { "ar": "تجربة عشوائية مضبوطة", "en": "Randomized Controlled Trial" } },
            { "value": "COHORT", "label": { "ar": "دراسة أترابية", "en": "Cohort Study" } },
            { "value": "CASE_CONTROL", "label": { "ar": "دراسة حالات وشواهد", "en": "Case-Control Study" } },
            { "value": "QUALITATIVE", "label": { "ar": "دراسة نوعية", "en": "Qualitative Study" } },
            { "value": "OTHER", "label": { "ar": "أخرى", "en": "Other" } }
          ] },
        { "name": "sample_size_adequate", "label": { "ar": "كفاية حجم العينة", "en": "Adequacy of Sample Size" }, "type": "scale", "required": true, "min": 1, "max": 5 },
        { "name": "statistical_plan", "label": { "ar": "الخطة الإحصائية", "en": "Statistical Plan" }, "type": "textarea", "required": false, "rows": 4 },
        { "name": "scientific_comment", "label": { "ar": "تعليق علمي", "en": "Scientific Comment" }, "type": "textarea", "required": false, "rows": 6 }
      ]
    },
    {
      "id": "verdict",
      "title": { "ar": "القرار", "en": "Verdict" },
      "fields": [
        { "name": "recommendation", "label": { "ar": "التوصية", "en": "Recommendation" }, "type": "radio", "required": true,
          "options": [
            { "value": "APPROVE", "label": { "ar": "الموافقة", "en": "Approve" } },
            { "value": "APPROVE_WITH_CHANGES", "label": { "ar": "الموافقة مع تعديلات", "en": "Approve with Changes" } },
            { "value": "REJECT", "label": { "ar": "الرفض", "en": "Reject" } },
            { "value": "RETURN", "label": { "ar": "إعادة للمراجعة", "en": "Return for Revision" } }
          ] },
        { "name": "recommendation_justification", "label": { "ar": "مبرر القرار", "en": "Justification" }, "type": "textarea", "required": true, "rows": 4,
          "conditional": { "field": "recommendation", "equals": "REJECT" } },
        { "name": "changes_required", "label": { "ar": "التعديلات المطلوبة", "en": "Required Changes" }, "type": "textarea", "required": false, "rows": 4 }
      ]
    }
  ],
  "computed": { "total_score": { "type": "mean", "fields": ["objectives_clarity", "sample_size_adequate"] } }
}
```

## 2. FRM-025 — Serious Adverse Event (SAE) Report

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "formCode": "SAE_REPORT",
  "version": "1.0.0",
  "sections": [
    {
      "id": "event",
      "title": { "ar": "بيانات الحدث", "en": "Event Details" },
      "fields": [
        { "name": "event_date", "label": { "ar": "تاريخ الحدث", "en": "Event Date" }, "type": "date", "required": true },
        { "name": "report_timeliness", "label": { "ar": "الالتزام بالتبليغ", "en": "Reporting Timeliness" }, "type": "select", "required": true,
          "options": [
            { "value": "WITHIN_24H", "label": { "ar": "خلال 24 ساعة", "en": "Within 24 hours" } },
            { "value": "WITHIN_7D", "label": { "ar": "خلال 7 أيام", "en": "Within 7 days" } },
            { "value": "DELAYED", "label": { "ar": "متأخر", "en": "Delayed" } }
          ] },
        { "name": "event_type", "label": { "ar": "نوع الحدث", "en": "Event Type" }, "type": "select", "required": true,
          "options": [
            { "value": "DEATH", "label": { "ar": "وفاة", "en": "Death" } },
            { "value": "LIFE_THREATENING", "label": { "ar": "يهدد الحياة", "en": "Life-threatening" } },
            { "value": "HOSPITALIZATION", "label": { "ar": "تنويم بالمستشفى", "en": "Hospitalization" } },
            { "value": "DISABILITY", "label": { "ar": "إعاقة دائمة", "en": "Persistent Disability" } },
            { "value": "CONGENITAL", "label": { "ar": "تشوه خلقي", "en": "Congenital Anomaly" } },
            { "value": "OTHER_SERIOUS", "label": { "ar": "حدث خطير آخر", "en": "Other Serious Event" } }
          ] },
        { "name": "severity", "label": { "ar": "الشدة", "en": "Severity" }, "type": "select", "required": true,
          "options": [
            { "value": "G1", "label": { "ar": "درجة 1", "en": "Grade 1" } },
            { "value": "G2", "label": { "ar": "درجة 2", "en": "Grade 2" } },
            { "value": "G3", "label": { "ar": "درجة 3", "en": "Grade 3" } },
            { "value": "G4", "label": { "ar": "درجة 4", "en": "Grade 4" } },
            { "value": "G5", "label": { "ar": "درجة 5", "en": "Grade 5" } }
          ] },
        { "name": "relationship", "label": { "ar": "العلاقة السببية", "en": "Causality" }, "type": "select", "required": true,
          "options": [
            { "value": "UNRELATED", "label": { "ar": "غير مرتبط", "en": "Unrelated" } },
            { "value": "POSSIBLE", "label": { "ar": "ممكن", "en": "Possible" } },
            { "value": "PROBABLE", "label": { "ar": "مرجح", "en": "Probable" } },
            { "value": "DEFINITE", "label": { "ar": "مؤكد", "en": "Definite" } }
          ] },
        { "name": "expectedness", "label": { "ar": "التوقع", "en": "Expectedness" }, "type": "select", "required": true,
          "options": [
            { "value": "EXPECTED", "label": { "ar": "متوقع", "en": "Expected" } },
            { "value": "UNEXPECTED", "label": { "ar": "غير متوقع", "en": "Unexpected" } }
          ] }
      ]
    },
    {
      "id": "participant",
      "title": { "ar": "بيانات المشارك", "en": "Participant" },
      "fields": [
        { "name": "participant_id", "label": { "ar": "معرّف المشارك (مشفر)", "en": "Participant ID (coded)" }, "type": "text", "required": true },
        { "name": "participant_outcome", "label": { "ar": "حالة المشارك", "en": "Outcome" }, "type": "select", "required": true,
          "options": [
            { "value": "RECOVERED", "label": { "ar": "تعافى", "en": "Recovered" } },
            { "value": "RECOVERING", "label": { "ar": "في تحسن", "en": "Recovering" } },
            { "value": "DEATH", "label": { "ar": "وفاة", "en": "Death" } },
            { "value": "UNKNOWN", "label": { "ar": "غير معروف", "en": "Unknown" } }
          ] }
      ]
    },
    {
      "id": "actions",
      "title": { "ar": "الإجراءات", "en": "Actions Taken" },
      "fields": [
        { "name": "event_description", "label": { "ar": "وصف الحدث", "en": "Event Description" }, "type": "textarea", "required": true, "rows": 6 },
        { "name": "action_taken", "label": { "ar": "الإجراء المتخذ", "en": "Action Taken" }, "type": "textarea", "required": true, "rows": 4 },
        { "name": "protocol_change", "label": { "ar": "هل يتطلب تعديل البروتوكول؟", "en": "Does this require a protocol amendment?" }, "type": "boolean", "required": true }
      ]
    }
  ]
}
```

## 3. FRM-024 — Continuing Review / Annual Progress Report

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "formCode": "ANNUAL_PROGRESS",
  "version": "1.0.0",
  "sections": [
    {
      "id": "period",
      "title": { "ar": "فترة التقرير", "en": "Reporting Period" },
      "fields": [
        { "name": "period_start", "label": { "ar": "بداية الفترة", "en": "Period Start" }, "type": "date", "required": true },
        { "name": "period_end", "label": { "ar": "نهاية الفترة", "en": "Period End" }, "type": "date", "required": true }
      ]
    },
    {
      "id": "progress",
      "title": { "ar": "التقدم", "en": "Progress" },
      "fields": [
        { "name": "participants_enrolled", "label": { "ar": "عدد المشاركين المسجلين", "en": "Participants Enrolled" }, "type": "number", "required": true, "min": 0 },
        { "name": "participants_completed", "label": { "ar": "عدد المشاركين المكملين", "en": "Participants Completed" }, "type": "number", "required": true, "min": 0 },
        { "name": "adverse_events", "label": { "ar": "الأحداث العكسية", "en": "Adverse Events" }, "type": "number", "required": true, "min": 0 },
        { "name": "summary", "label": { "ar": "ملخص التقدم", "en": "Progress Summary" }, "type": "textarea", "required": true, "rows": 6 }
      ]
    }
  ]
}
```

## 4. FRM-002 — Administrative Screening Checklist

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "formCode": "ADMIN_SCREENING",
  "version": "1.0.0",
  "sections": [
    {
      "id": "completeness",
      "title": { "ar": "الاكتمال الإداري", "en": "Administrative Completeness" },
      "fields": [
        { "name": "protocol_complete", "label": { "ar": "البروتوكول مكتمل", "en": "Protocol complete" }, "type": "boolean", "required": true },
        { "name": "consent_submitted", "label": { "ar": "نموذج الموافقة مرفق", "en": "Consent form attached" }, "type": "boolean", "required": true },
        { "name": "declaration_signed", "label": { "ar": "إقرار الباحث موقع", "en": "Researcher declaration signed" }, "type": "boolean", "required": true },
        { "name": "documents_verified", "label": { "ar": "المستندات المطلوبة مكتملة", "en": "Required documents verified" }, "type": "boolean", "required": true }
      ]
    },
    {
      "id": "outcome",
      "title": { "ar": "النتيجة", "en": "Outcome" },
      "fields": [
        { "name": "outcome", "label": { "ar": "النتيجة", "en": "Outcome" }, "type": "radio", "required": true,
          "options": [
            { "value": "COMPLETE", "label": { "ar": "مكتمل", "en": "Complete" } },
            { "value": "INCOMPLETE", "label": { "ar": "ناقص", "en": "Incomplete" } },
            { "value": "REJECTED", "label": { "ar": "مرفوض", "en": "Rejected" } }
          ] },
        { "name": "comments", "label": { "ar": "ملاحظات", "en": "Comments" }, "type": "textarea", "required": false, "rows": 4 }
      ]
    }
  ]
}
```

---

All other v1 forms follow the same meta-schema (sections → fields with bilingual labels, conditional logic, computed values). The full set is seeded into `forms.form_definitions` by `backend/seed/55-forms-library.sql`.
