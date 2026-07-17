import { AuditableRepository } from './auditable.repository';

export class TemplateUsageStatsRepository extends AuditableRepository {
  async upsert(data: {
    template_id: number; date: string | Date;
    generation_count?: number; unique_users?: number;
    avg_duration_ms?: number; total_size_bytes?: number;
    by_format?: any; by_locale?: any;
  }): Promise<any> {
    const result = await this.query(
      `INSERT INTO templates.template_usage_statistics
        (template_id, date, generation_count, unique_users,
         avg_duration_ms, total_size_bytes, by_format, by_locale)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       ON CONFLICT (template_id, date) DO UPDATE SET
         generation_count = templates.template_usage_statistics.generation_count + EXCLUDED.generation_count,
         unique_users = GREATEST(templates.template_usage_statistics.unique_users, EXCLUDED.unique_users),
         avg_duration_ms = CASE
           WHEN EXCLUDED.avg_duration_ms IS NOT NULL THEN
             (COALESCE(templates.template_usage_statistics.avg_duration_ms, 0) + EXCLUDED.avg_duration_ms) / 2
           ELSE templates.template_usage_statistics.avg_duration_ms
         END,
         total_size_bytes = templates.template_usage_statistics.total_size_bytes + EXCLUDED.total_size_bytes,
         by_format = templates.template_usage_statistics.by_format || EXCLUDED.by_format,
         by_locale = templates.template_usage_statistics.by_locale || EXCLUDED.by_locale
       RETURNING *`,
      [
        data.template_id, data.date,
        data.generation_count || 0, data.unique_users || 0,
        data.avg_duration_ms || null, data.total_size_bytes || 0,
        JSON.stringify(data.by_format || {}),
        JSON.stringify(data.by_locale || {}),
      ]
    );
    return result.rows[0];
  }

  async findByTemplateId(
    templateId: number,
    dateFrom?: string | Date,
    dateTo?: string | Date,
  ): Promise<any[]> {
    let whereClause = 'WHERE template_id = $1';
    const values: any[] = [templateId];
    let idx = 2;

    if (dateFrom) {
      whereClause += ` AND date >= $${idx++}`;
      values.push(dateFrom);
    }
    if (dateTo) {
      whereClause += ` AND date <= $${idx++}`;
      values.push(dateTo);
    }

    const result = await this.query(
      `SELECT * FROM templates.template_usage_statistics ${whereClause} ORDER BY date DESC`,
      values
    );
    return result.rows;
  }

  async getAggregateStats(): Promise<{
    total_renders: number;
    avg_duration_ms: number | null;
    top_templates: any[];
  }> {
    const totalResult = await this.query(
      `SELECT COALESCE(SUM(generation_count), 0) as total_renders,
              AVG(avg_duration_ms) as avg_duration_ms
       FROM templates.template_usage_statistics`
    );

    const topResult = await this.query(
      `SELECT t.id, t.code, t.name_ar, t.name_en,
              COALESCE(SUM(us.generation_count), 0) as total_renders
       FROM templates.templates t
       LEFT JOIN templates.template_usage_statistics us ON us.template_id = t.id
       WHERE t.deleted_at IS NULL
       GROUP BY t.id, t.code, t.name_ar, t.name_en
       ORDER BY total_renders DESC
       LIMIT 10`
    );

    return {
      total_renders: parseInt(totalResult.rows[0].total_renders),
      avg_duration_ms: totalResult.rows[0].avg_duration_ms
        ? Math.round(parseFloat(totalResult.rows[0].avg_duration_ms))
        : null,
      top_templates: topResult.rows,
    };
  }
}
