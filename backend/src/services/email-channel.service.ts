import nodemailer from 'nodemailer';
import { logger } from '../config/logger';
import { env } from '../config/env';

export interface EmailResult {
  success: boolean;
  reference?: string;
  error?: string;
}

export class EmailChannelService {
  private transporter: nodemailer.Transporter | null = null;

  private getTransporter(): nodemailer.Transporter {
    if (!this.transporter) {
      this.transporter = nodemailer.createTransport({
        host: env.SMTP_HOST,
        port: env.SMTP_PORT,
        secure: env.SMTP_SECURE,
        auth: env.SMTP_USER
          ? { user: env.SMTP_USER, pass: env.SMTP_PASS }
          : undefined,
      });
    }
    return this.transporter;
  }

  async send(to: string, subject: string, body: string): Promise<EmailResult> {
    try {
      const info = await this.getTransporter().sendMail({
        from: env.SMTP_FROM,
        to,
        subject,
        html: body,
      });
      return { success: true, reference: info.messageId };
    } catch (err: any) {
      logger.error({ err, to }, 'Email send failed');
      return { success: false, error: err.message };
    }
  }
}
