/*
 * مستودع قوالب الشهادات/المستندات: إنشاء وإدارة
 * قوالب المستندات (HTML/PDF) المستخدمة في إصدار
 * الشهادات والمستندات الرسمية.
 */
import { AuditableRepository } from './auditable.repository';

export class DocumentTemplateRepository extends AuditableRepository {
  async findAll(): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM documents.templates ORDER BY is_active DESC, template_name`
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM documents.templates WHERE id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async nextVersion(templateCode: string): Promise<number> {
    const result = await this.query(
      `SELECT COALESCE(MAX(version_no), 0) + 1 AS next FROM documents.templates WHERE template_code = $1`,
      [templateCode]
    );
    return result.rows[0]?.next ?? 1;
  }

  async create(data: any): Promise<any> {
    const version_no = data.version_no || await this.nextVersion(data.template_code);
    const result = await this.query(
      `INSERT INTO documents.templates
        (template_code, template_name, template_type, template_content, version_no, is_active)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [data.template_code, data.template_name, data.template_type,
       data.template_content, version_no, data.is_active ?? true]
    );
    return result.rows[0];
  }

  async update(id: number, data: any): Promise<any | null> {
    const result = await this.query(
      `UPDATE documents.templates SET
        template_name = COALESCE($1, template_name),
        template_type = COALESCE($2, template_type),
        template_content = COALESCE($3, template_content),
        is_active = COALESCE($4, is_active)
       WHERE id = $5 RETURNING *`,
      [data.template_name, data.template_type, data.template_content, data.is_active, id]
    );
    return result.rows[0] || null;
  }

  async retire(id: number): Promise<boolean> {
    const result = await this.query(
      `UPDATE documents.templates SET is_active = false WHERE id = $1`,
      [id]
    );
    return (result.rowCount ?? 0) > 0;
  }

  async nextVersionForLanguage(templateCode: string, language: string): Promise<number> {
    const result = await this.query(
      `SELECT COALESCE(MAX(version_no), 0) + 1 AS next
       FROM documents.templates
       WHERE template_code = $1 AND language = $2`,
      [templateCode, language]
    );
    return result.rows[0]?.next ?? 1;
  }

  async createNewVersion(sourceId: number, content: string, versionName?: string): Promise<any> {
    const source = await this.findById(sourceId);
    if (!source) return null;

    const version_no = await this.nextVersionForLanguage(source.template_code, source.language);
    const wasDefault = Boolean(source.is_default);

    return this.withTransaction(async (client) => {
      await client.query(
        `UPDATE documents.templates SET is_active = false WHERE template_code = $1 AND language = $2`,
        [source.template_code, source.language]
      );

      const result = await client.query(
        `INSERT INTO documents.templates
          (template_code, template_name, template_type, template_content, version_no,
           is_active, language, document_category, is_default)
         VALUES ($1, $2, $3, $4, $5, true, $6, $7, $8)
         RETURNING *`,
        [source.template_code, versionName || source.template_name, source.template_type,
         content, version_no, source.language, source.document_category, wasDefault]
      );
      return result.rows[0];
    });
  }

  async setDefault(id: number): Promise<any | null> {
    const target = await this.findById(id);
    if (!target) return null;

    return this.withTransaction(async (client) => {
      await client.query(
        `UPDATE documents.templates SET is_default = false WHERE template_code = $1 AND language = $2`,
        [target.template_code, target.language]
      );
      const result = await client.query(
        `UPDATE documents.templates SET is_default = true WHERE id = $1 RETURNING *`,
        [id]
      );
      return result.rows[0] || null;
    });
  }
}
