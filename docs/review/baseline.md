# Baseline Review Snapshot

تاريخ المراجعة: 2026-07-09

## Commit الحالي

`2278edbd8c2a83a3a74a320be08e414f2a5f4af1`

## عدد الجداول

`209` جدول.

المصدر: عد `CREATE TABLE` في `database/canonical/tables/*.sql`.

## عدد الـ APIs

`145` عملية API.

المصدر: عد عمليات HTTP (`get`, `post`, `put`, `patch`, `delete`) في ملفات `backend/openapi/modules/*.yaml`.

## عدد الاختبارات

`454` اختبارًا مكتشفًا عبر Vitest:

- Backend: `451` اختبارًا (`366` ناجحًا، `85` متجاوزًا)، مع `4` test suites فاشلة.
- Frontend: `3` اختبارات (`2` ناجحة، `1` فاشل).
- ملفات الاختبار: `14` ملفًا.

## Build Status

`npm run build`: ناجح.

تفصيل بوابات الجودة الحالية:

- `npm run lint`: فاشل. Backend typecheck نجح، وFrontend ESLint فشل بـ `219` خطأ و`15` تحذيرًا.
- `npm test`: فاشل. Backend فشل بسبب suites تكاملية تعتمد على خدمة Backend عاملة على `http://localhost:8080`; Frontend لديه اختبار واحد فاشل في صفحة تسجيل الدخول.

## Known Issues

- Frontend ESLint يحتوي على أخطاء واسعة، أبرزها `@typescript-eslint/no-explicit-any` ومخالفات React hooks / Fast Refresh.
- اختبارات Backend التكاملية تفشل محليًا عند عدم تشغيل Backend على المنفذ `8080`، وتظهر `ECONNREFUSED` في ملفات مثل `integration.test.ts`, `integration-v2.test.ts`, `rls-isolation.test.ts`, و`accreditation-api.test.ts`.
- اختبار `frontend/src/test/LoginPage.test.tsx` يفشل لأن النص `Sign In` يظهر في أكثر من عنصر، بينما الاختبار يستخدم `getByText`.
- توجد ملاحظة معمارية معروفة في المشروع حول PostgreSQL 18.3 على Windows وسياسات `FOR INSERT ... WITH CHECK`; تم توثيق workaround في seed الخاص بالتسجيل.
