import { query } from '../config/database';

export interface RenderedContent {
  subject: string;
  body: string;
}

export class TemplateRendererService {
  async render(
    notificationType: string,
    channel: string,
    subject: string,
    messageBody: string,
  ): Promise<RenderedContent> {
    if (channel === 'IN_APP') {
      return { subject, body: messageBody };
    }

    const template = await this.findTemplate(notificationType, channel);
    if (template) {
      return {
        subject: template.subject_template || subject,
        body: template.body_template,
      };
    }

    if (channel === 'SMS') {
      return { subject, body: messageBody.substring(0, 160) };
    }

    return { subject, body: messageBody };
  }

  private async findTemplate(notificationType: string, channel: string): Promise<{ subject_template: string; body_template: string } | null> {
    const result = await query(
      `SELECT subject_template, body_template FROM communication.notification_templates
       WHERE template_code = $1 AND channel_type = $2 AND is_active = TRUE
       LIMIT 1`,
      [notificationType, channel]
    );
    return result.rows[0] || null;
  }
}
