import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';
import type { IEngineVersionRepository } from '../services/template-engine.service';
import type { IVersionRepository, VersionData } from '../services/template-version-lifecycle.service';
import type { ITimelineVersionRepository } from '../services/template-timeline.service';
import type { IRollbackVersionRepository } from '../services/template-rollback.service';

export class TemplateVersionRepository extends AuditableRepository
  implements IEngineVersionRepository, IVersionRepository, ITimelineVersionRepository, IRollbackVersionRepository {

  async findByCodeAndVersion(code: string, version: string): Promise<VersionData | null> {
    const result = await this.query(
      `SELECT tv.*
       FROM templates.template_versions tv
       JOIN templates.templates t ON t.id = tv.template_id
       WHERE t.code = $1 AND tv.version = $2 AND t.deleted_at IS NULL`,
      [code, version]
    );
    return result.rows[0] || null;
  }

  async findById(id: number): Promise<VersionData | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_versions WHERE id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findAll(): Promise<VersionData[]> {
    const result = await this.query(
      `SELECT tv.*
       FROM templates.template_versions tv
       JOIN templates.templates t ON t.id = tv.template_id
       WHERE t.deleted_at IS NULL
       ORDER BY t.code, tv.version DESC`
    );
    return result.rows;
  }

  async findByTemplateCode(code: string): Promise<VersionData[]> {
    const result = await this.query(
      `SELECT tv.*
       FROM templates.template_versions tv
       JOIN templates.templates t ON t.id = tv.template_id
       WHERE t.code = $1 AND t.deleted_at IS NULL
       ORDER BY tv.version DESC`,
      [code]
    );
    return result.rows;
  }

  async updateStatus(id: number, newStatus: string, userId: number, client?: PoolClient): Promise<VersionData> {
    if (newStatus === 'APPROVED') {
      const result = await this.query(
        `UPDATE templates.template_versions
         SET status = $1, approved_by = $2, approved_at = NOW()
         WHERE id = $3
         RETURNING *`,
        [newStatus, userId, id],
        client
      );
      return result.rows[0];
    }
    const result = await this.query(
      `UPDATE templates.template_versions
       SET status = $1
       WHERE id = $2
       RETURNING *`,
      [newStatus, id],
      client
    );
    return result.rows[0];
  }

  async findApproved(templateId: number, now: Date): Promise<VersionData | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_versions
       WHERE template_id = $1
         AND status = 'APPROVED'
         AND (effective_from IS NULL OR effective_from <= $2)
         AND (effective_until IS NULL OR effective_until > $2)
       LIMIT 1`,
      [templateId, now]
    );
    return result.rows[0] || null;
  }

  async deprecateCurrentApproved(templateId: number, now: Date, client?: PoolClient): Promise<VersionData | null> {
    const result = await this.query(
      `UPDATE templates.template_versions
       SET status = 'DEPRECATED', retired_at = $2
       WHERE template_id = $1 AND status = 'APPROVED'
       RETURNING *`,
      [templateId, now],
      client
    );
    return result.rows[0] || null;
  }

  async updateEffectiveDates(
    id: number,
    effectiveFrom: Date | null,
    effectiveUntil: Date | null,
    client?: PoolClient,
  ): Promise<VersionData> {
    const result = await this.query(
      `UPDATE templates.template_versions
       SET effective_from = $1, effective_until = $2
       WHERE id = $3
       RETURNING *`,
      [effectiveFrom, effectiveUntil, id],
      client
    );
    return result.rows[0];
  }

  async create(data: {
    template_id: number; version: string; content: any;
    content_hash: string; variable_definitions?: any;
    change_summary?: string; created_by: number;
  }): Promise<VersionData> {
    const result = await this.query(
      `INSERT INTO templates.template_versions
        (template_id, version, content, content_hash, variable_definitions,
         change_summary, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
       RETURNING *`,
      [
        data.template_id, data.version, JSON.stringify(data.content),
        data.content_hash, JSON.stringify(data.variable_definitions || []),
        data.change_summary || null, data.created_by,
      ]
    );
    return result.rows[0];
  }

  async findLatestByTemplateId(templateId: number): Promise<VersionData | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_versions
       WHERE template_id = $1
       ORDER BY created_at DESC
       LIMIT 1`,
      [templateId]
    );
    return result.rows[0] || null;
  }
}
