import { BaseResolver } from './base.resolver';
import { ReportResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';
import { EntityDataRepository } from './entity-data.repository';

export class ReportResolver extends BaseResolver<ReportResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['report_type', 'report_type'],
    ['entity_type', 'entity_type'],
    ['entity_id', 'entity_id'],
    ['generated_by', 'generated_by'],
    ['generated_at', 'generated_at'],
    ['status', 'status'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'report_type', fieldPath: 'report_type', description: 'Type of report' },
      { variableCode: 'entity_type', fieldPath: 'entity_type', description: 'Related entity type' },
      { variableCode: 'entity_id', fieldPath: 'entity_id', description: 'Related entity ID' },
      { variableCode: 'generated_by', fieldPath: 'generated_by', description: 'Generator user ID' },
      { variableCode: 'generated_at', fieldPath: 'generated_at', description: 'Generation timestamp' },
      { variableCode: 'status', fieldPath: 'status', description: 'Report status' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['EntityDataRepository'];
  }

  constructor(private entityDataRepo: EntityDataRepository) {
    super('Report');
  }

  async resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown> {
    if (!this.variableMap.has(variableCode)) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }
    const results = await this.resolveBatch([entityId], [variableCode], context);
    const entity = results.get(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `Report ${entityId} not found`);
    }
    if (!(variableCode in entity!)) {
      this.createRejection(entityId, variableCode, `Variable "${variableCode}" not resolved on Report ${entityId}`);
    }
    return (entity as any)[variableCode];
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<ReportResolveDTO>>> {
    const results = new Map<number, Partial<ReportResolveDTO>>();
    const uniqueIds = [...new Set(entityIds)];
    if (uniqueIds.length === 0) return results;

    const rows = await this.entityDataRepo.findReportBatch(uniqueIds);

    for (const id of uniqueIds) {
      const row = rows.get(id);
      if (!row) continue;
      const partial: Partial<ReportResolveDTO> = {};
      for (const varCode of requestedVariables) {
        const field = this.variableMap.get(varCode);
        if (field && row[field] !== undefined) {
          (partial as any)[varCode] = row[field];
        }
      }
      results.set(id, partial);
    }
    return results;
  }
}
