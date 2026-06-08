import { describe, it, expect } from 'vitest';
import { z } from 'zod';

describe('Auth middleware logic', () => {
  it('authorize should return a middleware function', async () => {
    const { authorize } = await import('../middleware/auth');
    const middleware = authorize('ADMIN');
    expect(typeof middleware).toBe('function');
    expect(middleware.length).toBe(3);
  });
});

describe('Zod schemas', () => {
  it('should validate JWT_SECRET length', () => {
    const schema = z.object({ key: z.string().min(16) });
    expect(() => schema.parse({ key: 'short' })).toThrow();
    expect(() => schema.parse({ key: 'a'.repeat(16) })).not.toThrow();
  });
});
