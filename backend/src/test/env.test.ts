import { describe, it, expect } from 'vitest';
import { env } from '../config/env';

describe('Environment', () => {
  it('should have valid JWT_SECRET', () => {
    expect(env.JWT_SECRET.length).toBeGreaterThanOrEqual(16);
  });

  it('should have a valid PORT', () => {
    expect(env.PORT).toBeGreaterThan(0);
  });

  it('should have a valid NODE_ENV', () => {
    expect(['development', 'production', 'test']).toContain(env.NODE_ENV);
  });
});
