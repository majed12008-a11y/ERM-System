# RLS Inventory — Ethics ERM System

> **المرجع السريع لجميع جداول RLS**
> آخر تحديث: 2026-06-27 | الإصدار: 1.0

---

## التغطية الكاملة (66 جدولاً)

| # | Schema | Table | SELECT | INSERT | UPDATE | DELETE | ملاحظات |
|---|--------|-------|--------|--------|--------|--------|---------|
| 1 | committee | accreditation_assessment_items | ✓ | ✓ | ✓ | ✓ | |
| 2 | committee | accreditation_assessments | ✓ | ✓ | ✓ | ✗ | Soft delete |
| 3 | committee | accreditation_conditions | ✓ | ✓ | ✓ | ✗ | Soft delete |
| 4 | committee | accreditation_cycle_metrics | ✓ | ✓ | ✓ | ✗ | Soft delete |
| 5 | committee | accreditation_cycles | ✓ | ✓ | ✓ | ✓ | |
| 6 | committee | accreditation_decisions | ✓ | ✓ | ✗ | ✗ | إضافات فقط |
| 7 | committee | accreditation_evidence | ✓ | ✓ | ✓ | ✗ | Soft delete |
| 8 | committee | accreditation_standard_versions | ✓ | ✓ | ✓ | ✓ | |
| 9 | committee | accreditation_standards | ✓ | ✓ | ✓ | ✓ | |
| 10 | committee | committee_meetings | ✓ | ✓ | ✓ | ✗ | Soft delete |
| 11 | committee | consent_review_comments | ✓ | ✓ | ✓ | ✓ | |
| 12 | committee | consent_template_versions | ✓ | ✓ | ✓ | ✓ | |
| 13 | committee | consent_templates | ✓ | ✓ | ✓ | ✓ | |
| 14 | committee | ethics_reviews | ✓ | ✓ | ✓ | ✗ | Soft delete |
| 15 | committee | ethics_risk_assessments | ✓ | ✓ | ✓ | ✓ | |
| 16 | committee | ethics_risk_items | ✓ | ✓ | ✓ | ✓ | |
| 17 | committee | member_conflicts | ✓ | ✓ | ✓ | ✓ | |
| 18 | committee | member_qualifications | ✓ | ✓ | ✓ | ✓ | |
| 19 | committee | member_terms | ✓ | ✓ | ✓ | ✓ | |
| 20 | committee | review_assignments | ✓ | ✓ | ✓ | ✗ | Soft delete |
| 21 | committee | scientific_reviews | ✓ | ✓ | ✓ | ✗ | Soft delete |
| 22 | communication | announcements | ✓ | ✓ | ✓ | ✓ | |
| 23 | communication | message_attachments | ✓ | ✓ | ✓ | ✓ | |
| 24 | communication | message_recipients | ✓ | ✓ | ✓ | ✓ | |
| 25 | communication | messages | ✓ | ✓ | ✓ | ✓ | |
| 26 | communication | notification_channels | ✓ | ✓ | ✓ | ✓ | |
| 27 | communication | notification_logs | ✓ | ✓ | ✓ | ✓ | |
| 28 | communication | notification_templates | ✓ | ✓ | ✓ | ✓ | |
| 29 | communication | notifications | ✓ | ✓ | ✓ | ✓ | |
| 30 | core | application_consents | ✓ | ✓ | ✓ | ✓ | |
| 31 | core | applications | ✓ | ✓ | ✓ | ✗ | Soft delete |
| 32 | core | projects | ✓ | ✓ | ✓ | ✗ | Soft delete |
| 33 | documents | documents | ✓ | ✓ * | ✓ | ✗ | (*) أُضيفت في RC1.2 |
| 34 | integration | data_sync_jobs | ✓ | ✓ | ✓ | ✗ | |
| 35 | integration | integration_credentials | ✓ | ✓ | ✓ | ✓ | |
| 36 | integration | integration_failures | ✓ | ✗ | ✓ | ✗ | لا يُكتب |
| 37 | monitoring | compliance_reviews | ✓ | ✓ | ✓ | ✓ | |
| 38 | monitoring | corrective_actions | ✓ | ✓ | ✓ | ✓ | |
| 39 | monitoring | deviations | ✓ | ✓ | ✓ | ✓ | |
| 40 | monitoring | inspection_reports | ✓ | ✓ | ✓ | ✓ | |
| 41 | monitoring | inspections | ✓ | ✓ | ✓ | ✓ | |
| 42 | monitoring | monitoring_findings | ✓ | ✓ | ✓ | ✓ | |
| 43 | monitoring | monitoring_plans | ✓ | ✓ | ✓ | ✓ | |
| 44 | monitoring | monitoring_visits | ✓ | ✓ | ✓ | ✓ | |
| 45 | monitoring | preventive_actions | ✓ | ✓ | ✓ | ✓ | |
| 46 | monitoring | protocol_violations | ✓ | ✓ | ✓ | ✓ | |
| 47 | reference | licenses_registry | ✓ | ✓ | ✓ | ✓ | |
| 48 | reporting | analytics_snapshots | ✓ | ✓ | ✓ | ✓ | |
| 49 | reporting | dashboard_widgets | ✓ | ✓ | ✓ | ✓ | |
| 50 | reporting | kpi_results | ✓ | ✓ | ✓ | ✓ | |
| 51 | reporting | report_definitions | ✓ | ✓ | ✓ | ✓ | |
| 52 | reporting | report_executions | ✓ | ✓ | ✓ | ✓ | |
| 53 | safety | corrective_actions | ✓ | ✓ | ✗ | ✗ | إضافات فقط |
| 54 | safety | risk_incidents | ✓ | ✓ | ✗ | ✗ | إضافات فقط |
| 55 | safety | risk_mitigations | ✓ | ✓ | ✗ | ✗ | إضافات فقط |
| 56 | safety | risk_register | ✓ | ✓ | ✓ | ✗ | |
| 57 | security | password_reset_tokens | ✓ | ✓ | ✓ | ✗ | |
| 58 | security | user_responsibilities | ✓ | ✓ | ✓ | ✓ | |
| 59 | security | users | ✓ | ✓ | ✓ | ✗ | يستخدم fn_register_user |
| 60 | system | saved_searches | ✓ | ✓ | ✓ | ✓ | |
| 61 | system | search_audit | ✓ | ✗ | ✗ | ✗ | للقراءة فقط |
| 62 | workflow | workflow_events | ✓ | ✗ | ✗ | ✗ | للقراءة فقط |
| 63 | workflow | workflow_instances | ✓ | ✓ | ✓ | ✗ | |
| 64 | workflow | workflow_schedulers | ✓ | ✓ | ✓ | ✗ | |
| 65 | workflow | workflow_tasks | ✓ | ✓ | ✓ | ✗ | |
| 66 | workflow | workflow_triggers | ✓ | ✓ | ✓ | ✗ | |

---

## الإحصائيات

| المقياس | العدد | النسبة |
|---------|-------|--------|
| إجمالي الجداول مع RLS | 66 | 100% |
| ✓ SELECT | 66 | 100% |
| ✓ INSERT | 62 | 93.9% |
| ✓ UPDATE | 59 | 89.4% |
| ✓ DELETE | 30 | 45.5% |
| سياسات كاملة (4/4) | 30 | 45.5% |

---

## جداول تحتاج مراجعة مستقبلية

| الجدول | السياسة المفقودة | التأثير |
|--------|-----------------|---------|
| `integration.integration_failures` | INSERT | لا يُكتب — آمن حالياً |
| `system.search_audit` | INSERT, UPDATE, DELETE | للقراءة فقط — آمن |
| `workflow.workflow_events` | INSERT, UPDATE, DELETE | للقراءة فقط — آمن |
| `safety.corrective_actions` | UPDATE, DELETE | إضافات فقط |
| `safety.risk_incidents` | UPDATE, DELETE | إضافات فقط |
| `safety.risk_mitigations` | UPDATE, DELETE | إضافات فقط |
| `committee.accreditation_decisions` | UPDATE, DELETE | إضافات فقط |

---

## المراجع

- `docs/security/RLS-Audit-Report.md` — تقرير التدقيق الشامل
- `docs/security/RLS-Hardening-Report.md` — تقرير التعزيز
- `backend/scripts/rls-audit.sql` — مجموعة الاختبارات الآلية
