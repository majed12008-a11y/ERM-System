# سجل العيوب — RC1.2

> **Defect Registry — Pre-existing & Known Issues**
> آخر تحديث: 2026-06-27

---

## معايير التصنيف

| الأولوية | التعريف |
|----------|---------|
| 🔴 حرج | يمنع الإطلاق |
| 🟡 متوسط | يؤثر على وظيفة معينة |
| 🔵 منخفض | تحسين أو خطأ غير مؤثر |

---

## العيوب النشطة (6)

### BUG-001: `GET /cycles/:id` returns 500 instead of 200/404

| الحقل | القيمة |
|-------|--------|
| الأولوية | 🟡 متوسط |
| الملف | `src/test/accreditation-api.test.ts` |
| المسار | `GET /api/v1/accreditation/cycles/:id` |
| السلوك الفعلي | 500 Internal Server Error |
| السلوك المتوقع | 200 (موجود) / 404 (غير موجود) |
| الاختبارات المتأثرة | 2 (`cycle detail`, `unknown cycle`) |
| تاريخ الاكتشاف | قبل RC1.2 |
| الحالة | قيد التحقيق |
| ملاحظات | يُرجّح أن السبب خطأ في تحميل البيانات المتداخلة (nested entities) |

### BUG-002: `PATCH /cycles/:id/status` returns 500

| الحقل | القيمة |
|-------|--------|
| الأولوية | 🟡 متوسط |
| الملف | `src/test/accreditation-api.test.ts` |
| المسار | `PATCH /api/v1/accreditation/cycles/:id/status` |
| السلوك الفعلي | 500 (لكل الحالات) |
| السلوك المتوقع | 200 (انتقال صحيح) / 422 (انتقال غير صحيح) |
| الاختبارات المتأثرة | 2 (`valid transition`, `invalid transition`) |
| تاريخ الاكتشاف | قبل RC1.2 |
| الحالة | قيد التحقيق |
| ملاحظات | يُرجّح أن سببها دالة SECURITY DEFINER في `32-accreditation-rls.sql` أو عدم وجود middleware |

### BUG-003: `POST /cycles/:cycleId/assessments` returns 500

| الحقل | القيمة |
|-------|--------|
| الأولوية | 🟡 متوسط |
| الملف | `src/test/accreditation-api.test.ts` |
| المسار | `POST /api/v1/accreditation/cycles/:cycleId/assessments` |
| السلوك الفعلي | 500 (لكل الحالات) |
| السلوك المتوقع | 200 (دورة UNDER_REVIEW) / 422 (دورة غير UNDER_REVIEW) |
| الاختبارات المتأثرة | 2 (`valid assessment`, `blocked assessment`) |
| تاريخ الاكتشاف | قبل RC1.2 |
| الحالة | قيد التحقيق |
| ملاحظات | يُرجّح أن سببها عدم توفر بيانات الدورة UNDER_REVIEW في seed data |

---

## العيوب المعلقة مؤقتاً (3)

### BUG-004: Integration tests expect port 3000

| الحقل | القيمة |
|-------|--------|
| الأولوية | 🔵 منخفض |
| الملف | `src/test/integration.test.ts` |
| الوصف | الاختبارات تتصل بـ `localhost:3000` لكن الخادم يعمل على `:8080` |
| الاختبارات المتأثرة | 54 (كلها skipped) |
| الحالة | مؤقت — لا تؤثر على نتائج الاختبارات |
| خطة المعالجة | تحديث ملف `.env.test` أو تكوين CI لاستخدام port 3000 |

### BUG-005: Integration tests hardcode credentials

| الحقل | القيمة |
|-------|--------|
| الأولوية | 🔵 منخفض |
| الملف | `src/test/integration.test.ts` |
| الوصف | تستخدم `admin:admin123` مباشرة بدلاً من متغيرات بيئة |
| الحالة | مؤقت — آمن في بيئة التطوير فقط |

### BUG-006: rls-isolation.test.ts depends on server

| الحقل | القيمة |
|-------|--------|
| الأولوية | 🔵 منخفض |
| الملف | `src/test/rls-isolation.test.ts` |
| الوصف | يحتاج خادم قيد التشغيل على port 3000 |
| الحالة | مؤقت — أُنشئ لاختبار RLS end-to-end |

---

## ملخص

| الحالة | العدد |
|--------|-------|
| 🔴 حرج | 0 |
| 🟡 متوسط | 3 (accreditation) |
| 🔵 منخفض | 3 (integration tests) |
| **المجموع** | **6** |
