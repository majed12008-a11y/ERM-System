import { AuditableRepository } from './auditable.repository';

export class TemplateOutputRepository extends AuditableRepository {
  async create(data: {
    template_version_id: number; locale: string; output_format: string;
    entity_type: string; entity_id: number; storage_path: string;
    file_name: string; checksum_sha256: string; variables_hash: string;
    generated_by: number; file_size_bytes?: number;
    rendered_html_hash?: string; digital_signature_ref?: string;
    generation_duration_ms?: number; status?: string; error_message?: string;
  }): Promise<any> {
    const result = await this.query(
      `INSERT INTO templates.template_outputs
        (template_version_id, locale, output_format, entity_type, entity_id,
         storage_path, file_name, file_size_bytes, checksum_sha256,
         variables_hash, rendered_html_hash, digital_signature_ref,
         generated_by, generation_duration_ms, status, error_message)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
       RETURNING *`,
      [
        data.template_version_id, data.locale, data.output_format,
        data.entity_type, data.entity_id, data.storage_path,
        data.file_name, data.file_size_bytes || null,
        data.checksum_sha256, data.variables_hash,
        data.rendered_html_hash || null, data.digital_signature_ref || null,
        data.generated_by, data.generation_duration_ms || null,
        data.status || 'SUCCESS', data.error_message || null,
      ]
    );
    return result.rows[0];
  }

  async findByEntity(entityType: string, entityId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.template_outputs
       WHERE entity_type = $1 AND entity_id = $2
       ORDER BY generated_at DESC`,
      [entityType, entityId]
    );
    return result.rows;
  }

  async findByVersionId(templateVersionId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.template_outputs
       WHERE template_version_id = $1
       ORDER BY generated_at DESC`,
      [templateVersionId]
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_outputs WHERE id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async getStats(): Promise<{ by_status: any[]; total: number }> {
    const totalResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_outputs`
    );
    const total = parseInt(totalResult.rows[0].count);

    const byStatusResult = await this.query(
      `SELECT status, COUNT(*) as count
       FROM templates.template_outputs
       GROUP BY status
       ORDER BY status`
    );
    return { by_status: byStatusResult.rows, total };
  }
}
