import { AsyncLocalStorage } from 'async_hooks';

export interface UserContext {
  userId: number;
  requestId: string;
}

export const userContext = new AsyncLocalStorage<UserContext>();

export function getUserId(): number {
  return userContext.getStore()?.userId ?? 0;
}

export function getRequestId(): string {
  return userContext.getStore()?.requestId || '-';
}

export function runWithUserId<T>(userId: number, fn: () => T): T {
  const existing = userContext.getStore();
  return userContext.run({ userId, requestId: existing?.requestId || '-' }, fn);
}
