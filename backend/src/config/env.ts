/*
 * التحقق من صحة متغيرات البيئة المطلوبة (PORT, DB_HOST, DB_PORT,
 * DB_NAME, DB_USER, DB_PASSWORD, JWT_SECRET) باستخدام Zod.
 * يتحقق من وجود جميع المتغيرات قبل بدء تشغيل الخادم.
 */
import { z } from 'zod';
import crypto from 'crypto';

const envSchema = z.object({
  PORT: z.coerce.number().default(3000),
  DB_HOST: z.string().default('localhost'),
  DB_PORT: z.coerce.number().default(5432),
  DB_NAME: z.string().default('ethics_db'),
  DB_USER: z.string().default('ethics_app'),
  DB_PASSWORD: z.string(),
  JWT_SECRET: z.string().min(32, 'JWT_SECRET must be at least 32 characters'),
  LOG_LEVEL: z.enum(['fatal', 'error', 'warn', 'info', 'debug', 'trace']).default('info'),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  CORS_ORIGIN: z.string().default('http://localhost:5173'),
  FRONTEND_URL: z.string().url().default('http://localhost:5173'),
  BACKUP_DIR: z.string().default('backups'),
  PG_BIN_PATH: z.string().default(''),
  DATABASE_URL: z.string().default(''),
  DB_ENCRYPTION_KEY: process.env.NODE_ENV === 'production'
    ? z.string().min(32, 'DB_ENCRYPTION_KEY is required in production and must be at least 32 characters')
    : z.string().optional(),
});

let env: z.infer<typeof envSchema>;

export function validateEnv() {
  const parsed = envSchema.safeParse(process.env);
  if (!parsed.success) {
    console.error('Invalid environment variables:', parsed.error.flatten());
    if (process.env.NODE_ENV === 'production') process.exit(1);
    env = envSchema.parse({ JWT_SECRET: crypto.randomBytes(32).toString('hex'), DB_PASSWORD: 'APP_PASSWORD' });
    return;
  }
  env = parsed.data;
}

validateEnv();

export { env };
