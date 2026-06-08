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
  DB_ENCRYPTION_KEY: z.string().optional(),
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
