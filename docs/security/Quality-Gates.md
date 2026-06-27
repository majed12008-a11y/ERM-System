# Quality Gates — RC1.2

> **معايير الجودة الموصى بها لمنظومة RLS و CI/CD**
> الإصدار: 1.0 | التاريخ: 2026-06-27

---

## 1. RLS Gate — منع دمج جداول جديدة بدون سياسات

### الهدف
ضمان أن أي جدول جديد يُضاف إلى قاعدة البيانات مع RLS لديه جميع السياسات المطلوبة.

### آلية التنفيذ

```yaml
# في CI pipeline (GitHub Actions)
# يُضاف كخطوة بعد تطبيق seed files
- name: RLS Policy Coverage Check
  run: |
    psql -U postgres -d ethics_db -c "
      SELECT n.nspname || '.' || c.relname AS missing_insert
      FROM pg_class c
      JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE c.relrowsecurity = true
        AND c.relkind = 'r'
        AND n.nspname NOT IN ('test_rls3','test_rls4','test_rls5','test_rls6','test_rls8','test_rls9')
      EXCEPT
      SELECT schemaname || '.' || tablename
      FROM pg_policies
      WHERE cmd = 'INSERT'
    " 2>&1 | grep -q "rows" || (echo "FAIL: New table without INSERT policy detected" && exit 1)
```

### قواعد القبول
- ❌ يفشل الـ CI إذا أضيف جدول جديد مع RLS ولكن بدون سياسة INSERT
- ❌ يفشل الـ CI إذا أضيف جدول جديد مع `FOR ALL` policy (لجداول الإنتاج)
- ❌ يفشل الـ CI إذا أضيفت دالة `SECURITY DEFINER` بدون تعليق يوضح السبب

---

## 2. RLS Gate — تشغيل `rls-audit.sql` في Regression Suite

### الهدف
ضمان عدم كسر سياسات RLS الحالية عند إجراء أي تعديل.

### آلية التنفيذ

```bash
# في CI pipeline
$env:PGPASSWORD='postgres'
psql -U ethics_app -d ethics_db -f backend/scripts/rls-audit.sql 2>&1 | Select-String "FAIL"

# إذا ظهر أي FAIL غير متوقع → يرفض الـ CI
```

### التكامل مع RC1.2 Gates

| Gate | يتضمن تشغيل `rls-audit.sql`؟ |
|------|------------------------------|
| Gate 1 — Infrastructure Smoke | ✅ نعم (بعد التأكد من اتصال DB) |
| Gate 2 — Core Object Tests | ✅ نعم |
| Gate 3 — Committee & Review | نعم (ضمن الـ Regression) |
| Gate 4 — Full Workflows | اختياري |
| Gate 5 — Security & Auth | ✅ نعم (جزء أساسي) |
| Gate 6 — UAT Scenarios | لا حاجة |

---

## 3. RLS Gate — فحص `SECURITY DEFINER` الجديدة

### الهدف
منع إضافة دوال `SECURITY DEFINER` بدون توثيق.

### آلية التنفيذ

```bash
# البحث عن أي SECURITY DEFINER جديد بدون تعليق
grep -B5 "SECURITY DEFINER" backend/seed/*.sql | grep -B5 "SECURITY DEFINER" | grep -v "SECURITY DEFINER" | while read line; do
  if [[ "$line" != *"--"* ]]; then
    echo "FAIL: SECURITY DEFINER without comment in seed file"
    exit 1
  fi
done
```

---

## 4. Architecture Gate — قواعد Layer Violation

### الهدف
ضمان عدم كسر الـ Three-Layer Architecture.

| القاعدة | طريقة الكشف |
|---------|-------------|
| Services لا تستدعي DB مباشرة | `grep -r "\.query(" backend/src/services/*.ts` (مسموح فقط في repositories) |
| Repositories لا تحتوي Business Logic | مراجعة يدوية + فحص عدم وجود `if/else` معقدة |
| Routes لا تحتوي Business Logic | التأكد من أن routes تستدعي services فقط |

---

## 5. Release Checklist — الصيغة النهائية

### قبل كل إصدار (Release)

```markdown
## RC1.2 Release Checklist

### RLS
- [ ] `rls-audit.sql` — جميع الاختبارات PASS
- [ ] لا توجد جداول RLS جديدة بدون INSERT policy
- [ ] لا توجد دوال SECURITY DEFINER جديدة بدون توثيق
- [ ] جميع السياسات تستخدم `app.user_id` (وليس hardcoded IDs)

### Architecture
- [ ] TODO/FIXME في الملفات الحرجة = 0
- [ ] لا توجد استدعاءات DB خارج طبقة Repository
- [ ] الـ Error Handling موحد (يرمى `AppError` أو `HttpError`)

### Tests
- [ ] `npm test` — جميع الاختبارات PASS (باستثناء المعروف)
- [ ] `npx tsc --noEmit` — clean
- [ ] `npm run build` (frontend) — success
- [ ] الاختبارات الفاشلة المعروفة موثقة في `Defect-Registry.md`

### Documentation
- [ ] `RLS-Inventory.md` محدثة
- [ ] أي استثناء معماري موثق في ADR
```

---

## 6. توصيات إضافية

### للتحسين في RC2

1. **تفعيل `git hooks`**: منع commit إذا كان هناك `SELECT-string "TODO"` في ملفات الإنتاج
2. **RLS Coverage Dashboard**: script يطبع تقرير التغطية بعد كل deploy
3. **Pre-commit RLS check**: فحص RLS في كل commit يؤثر على seed files
