/*
 * إرسال رسائل البريد الإلكتروني: تأكيد الحساب،
 * إعادة تعيين كلمة المرور، الإشعارات. يستخدم Nodemailer
 * مع إعدادات SMTP قابلة للتكوين من قاعدة البيانات.
 */
import nodemailer from 'nodemailer';
import { logger } from '../config/logger';
import { EmailConfigRepository } from '../repositories/email-config.repository';
import { query } from '../config/database';
import { env } from '../config/env';

const repo = new EmailConfigRepository();
let cachedTransport: nodemailer.Transporter | null = null;
let cachedConfigId: number | undefined;

async function getTransport(): Promise<nodemailer.Transporter | null> {
  const config = await repo.findActive();
  if (!config) return null;

  if (cachedTransport && cachedConfigId === config.id) {
    return cachedTransport;
  }

  try {
    const transport = nodemailer.createTransport({
      host: config.smtp_host,
      port: config.smtp_port,
      secure: config.use_tls && config.smtp_port === 465,
      auth: config.smtp_username
        ? { user: config.smtp_username, pass: config.smtp_password }
        : undefined,
    });
    cachedTransport = transport;
    cachedConfigId = config.id;
    return transport;
  } catch (err) {
    logger.error(err, 'Failed to create email transport');
    return null;
  }
}

export function clearTransportCache(): void {
  cachedTransport = null;
  cachedConfigId = undefined;
}

export async function sendEmail(options: {
  to: string;
  subject: string;
  text?: string;
  html?: string;
}): Promise<boolean> {
  const config = await repo.findActive();
  if (!config) {
    logger.warn('No active email config found — email not sent');
    return false;
  }

  const transport = await getTransport();
  if (!transport) {
    logger.warn('Email transport not available');
    return false;
  }

  try {
    await transport.sendMail({
      from: `"${config.from_name}" <${config.from_address}>`,
      to: options.to,
      subject: options.subject,
      text: options.text,
      html: options.html,
    });
    logger.info({ to: options.to, subject: options.subject }, 'Email sent');
    return true;
  } catch (err) {
    logger.error(err, 'Failed to send email');
    return false;
  }
}

export async function sendVerificationEmail(email: string, token: string): Promise<boolean> {
  const verifyUrl = `${env.FRONTEND_URL}/verify-email?token=${token}`;
  return sendEmail({
    to: email,
    subject: 'Verify your email address',
    text: `Please verify your email by clicking: ${verifyUrl}`,
    html: `<p>Please verify your email by clicking: <a href="${verifyUrl}">${verifyUrl}</a></p>`,
  });
}

export async function sendPasswordResetEmail(email: string, token: string): Promise<boolean> {
  const resetUrl = `${env.FRONTEND_URL}/reset-password?token=${token}`;
  return sendEmail({
    to: email,
    subject: 'Password reset request',
    text: `Reset your password here: ${resetUrl}`,
    html: `<p>Reset your password here: <a href="${resetUrl}">${resetUrl}</a></p>`,
  });
}
