import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['src/**/*.test.ts'],
    setupFiles: ['./src/test/setup.ts'],
    // DB-bound tests share one Postgres pool across parallel workers; the
    // default 5s is too tight when queries queue on pool connections.
    testTimeout: 30000,
  },
});
