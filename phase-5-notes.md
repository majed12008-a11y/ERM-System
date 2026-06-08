# Phase 5: Reporting Views + Materialized Views — ملاحظات التنفيذ

**التاريخ:** 2026-06-03
**الحالة:** مكتمل ✅

---

## ما تم تنفيذه
1. ✅ **11 Standard Views** في `reporting` Schema:
   - `vw_dashboard_application_stats` — إحصائيات الطلبات
   - `vw_dashboard_committee_workload` — عبء اللجان
   - `vw_dashboard_review_times` — أوقات المراجعة
   - `vw_dashboard_institution_stats` — إحصائيات المؤسسات
   - `vw_kpi_approval_rate` — نسبة الموافقات
   - `vw_kpi_average_review_duration` — متوسط مدة المراجعة
   - `vw_user_applications` — طلبات المستخدم
   - `vw_committee_members_active` — الأعضاء النشطون
   - `vw_upcoming_meetings` — الاجتماعات القادمة
   - `vw_pending_sla_tasks` — مهام SLA المتأخرة
   - `vw_application_timeline` — الخط الزمني للطلبات

2. ✅ **2 Materialized Views**:
   - `mv_daily_application_snapshot` — لقطة يومية
   - `mv_committee_performance` — أداء اللجان


---

## الهدف
إنشاء طبقة تقارير للوحات المؤشرات والمؤشرات الوطنية.

## Standard Views
1. `vw_dashboard_application_stats` — إحصائيات الطلبات لكل حالة
2. `vw_dashboard_committee_workload` — عبء العمل على اللجان
3. `vw_dashboard_review_times` — أوقات المراجعة
4. `vw_dashboard_institution_stats` — إحصائيات المؤسسات
5. `vw_kpi_approval_rate` — نسبة الموافقات
6. `vw_kpi_average_review_duration` — متوسط مدة المراجعة
7. `vw_user_applications` — طلبات المستخدم
8. `vw_committee_members_active` — الأعضاء النشطون لكل لجنة

## Materialized Views
9. `mv_daily_application_snapshot` — لقطة يومية للطلبات
10. `mv_committee_performance` — أداء اللجان

## ملاحظات
- جميع الـ Views تنشأ في `reporting` Schema
- الـ Materialized Views تُنعش يدوياً أو عبر وظيفة مجدولة
- GRANT SELECT على الـ views للمستخدمين المصرح لهم
