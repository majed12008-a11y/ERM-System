/*
 * دوال التشفير وفك التشفير للبيانات الحساسة.
 * تستخدم AES-256-GCM مع مفتاح مشتق من JWT_SECRET.
 */
import * as crypto from 'crypto';
import { env } from '../config/env';
import { logger } from '../config/logger';

const ALGORITHM = 'aes-256-gcm';
const IV_LENGTH = 16;
const TAG_LENGTH = 16;

function getKey(): Buffer | null {
  if (!env.DB_ENCRYPTION_KEY) {
    logger.warn('[crypto] DB_ENCRYPTION_KEY is not set — encryption disabled');
    return null;
  }
  return crypto.createHash('sha256').update(env.DB_ENCRYPTION_KEY).digest();
}

export function encrypt(text: string): string {
  if (!text) return text;
  const key = getKey();
  if (!key) return text;
  const iv = crypto.randomBytes(IV_LENGTH);
  const cipher = crypto.createCipheriv(ALGORITHM, key, iv);
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  const tag = cipher.getAuthTag().toString('hex');
  return `${iv.toString('hex')}:${tag}:${encrypted}`;
}

export function decrypt(encoded: string): string {
  if (!encoded) return encoded;
  if (encoded.startsWith('$argon2id') || encoded.startsWith('$scrypt')) return encoded;
  const parts = encoded.split(':');
  if (parts.length !== 3) return encoded;
  const key = getKey();
  if (!key) return encoded;
  const iv = Buffer.from(parts[0], 'hex');
  const tag = Buffer.from(parts[1], 'hex');
  const encrypted = parts[2];
  const decipher = crypto.createDecipheriv(ALGORITHM, key, iv);
  decipher.setAuthTag(tag);
  let decrypted = decipher.update(encrypted, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
}

export function hashForSearch(text: string): string {
  if (!text) return text;
  const key = getKey();
  if (!key) return text;
  return crypto.createHmac('sha256', key).update(text).digest('hex');
}
