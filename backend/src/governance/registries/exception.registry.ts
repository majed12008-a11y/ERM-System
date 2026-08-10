/*
 * سجل الاستثناءات (R9) — الانحرافات المأذونة بسلطتها
 * ونطاقها وانتهائها. انحراف غير مسجّل هو مخالفة بغض
 * النظر عن النية. السابقة المعروفة: التحايل عبر
 * SECURITY DEFINER لـ I11 (33-fix-register-rls.sql)
 * غير مسجّل حاليًا — التسجيل مؤجَّل مع مراجعة ADR له،
 * وليس من عمل هذه المرحلة.
 */
import { ConstitutionalRegistry } from './registry';

export type ExceptionStatus = 'Unrecorded' | 'Recorded' | 'Expired';

export interface ExceptionRecord {
  readonly id: string;
  readonly targetElement: string;
  readonly authority: string;
  readonly scope: string;
  readonly expiry: string;
  readonly status: ExceptionStatus;
  readonly note?: string;
}

/** السابقة المعروفة الوحيدة: تحايل I11 غير المسجّل. */
export const KNOWN_PRECEDENTS: ReadonlyArray<ExceptionRecord> = [
  {
    id: 'PRECEDENT-I11-SECURITY-DEFINER',
    targetElement: 'I11',
    authority: 'Unrecorded — pending ADR review (deferred, not Phase 1 work)',
    scope: 'SECURITY DEFINER registration function (backend/seed/33-fix-register-rls.sql) bypasses RLS for registration only',
    expiry: 'Not defined',
    status: 'Unrecorded',
    note: 'PostgreSQL 18.3 Windows bug workaround: FOR INSERT ... WITH CHECK policies fail silently; SECURITY DEFINER function is the accepted workaround. Recording is deferred with its ADR review.',
  },
];

/** لا استثناءات مسجّلة في مرحلة الأولى. */
export const EXCEPTIONS: ReadonlyArray<ExceptionRecord> = [];

export const EXCEPTION_REGISTRY = new ConstitutionalRegistry<ExceptionRecord>(
  'R9',
  'Exception Registry',
  'D6',
  [
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Exception Registry)' },
    { document: 'constitutional-enforcement-domains.csv', section: 'D6' },
    { document: 'backend/seed/33-fix-register-rls.sql' },
  ],
  KNOWN_PRECEDENTS,
);
