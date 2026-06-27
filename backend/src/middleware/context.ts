/*
 * تخزين سياق الطلب الحالي (معرف المستخدم، معرف الطلب، عنوان IP)
 * باستخدام AsyncLocalStorage. يُستخدم لربط مستخدم RLS بكل استعلام
 * قاعدة بيانات. دالة getUserId() تعيد 0 للمستخدم غير مسجل الدخول.
 */
import { AsyncLocalStorage } from 'async_hooks';

export interface UserContext {
  userId: number;
  requestId: string;
  sourceIp?: string;
}

export const userContext = new AsyncLocalStorage<UserContext>();

export function getUserId(): number {
  return userContext.getStore()?.userId ?? 0;
}

export function getRequestId(): string {
  return userContext.getStore()?.requestId || '-';
}

export function getSourceIp(): string {
  return userContext.getStore()?.sourceIp || '0.0.0.0';
}

export function runWithUserId<T>(userId: number, fn: () => T): T {
  const existing = userContext.getStore();
  return userContext.run({ userId, requestId: existing?.requestId || '-' }, fn);
}
