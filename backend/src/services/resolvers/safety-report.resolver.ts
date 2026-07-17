import { BaseResolver } from './base.resolver';
import { SafetyReportResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';
import { EntityDataRepository } from './entity-data.repository';

export class SafetyReportResolver extends BaseResolver<SafetyReportResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['application_id', 'application_id'],
    ['report_type', 'report_type'],
    ['severity', 'severity'],
    ['description', 'description'],
    ['reported_by', 'reported_by'],
    ['reported_at', 'reported_at'],
    ['status', 'status'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'application_id', fieldPath: 'application_id', description: 'Related application ID' },
      { variableCode: 'report_type', fieldPath: 'report_type', description: 'Safety report type' },
      { variableCode: 'severity', fieldPath: 'severity', description: 'Severity level' },
      { variableCode: 'description', fieldPath: 'description', description: 'Incident description' },
      { variableCode: 'reported_by', fieldPath: 'reported_by', description: 'Reporter user ID' },
      { variableCode: 'reported_at', fieldPath: 'reported_at', description: 'Report timestamp' },
      { variableCode: 'status', fieldPath: 'status', description: 'Report status' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['EntityDataRepository'];
  }

  constructor(private entityDataRepo: EntityDataRepository) {
    super('SafetyReport');
  }

  async resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown> {
    if (!this.variableMap.has(variableCode)) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }
    const results = await this.resolveBatch([entityId], [variableCode], context);
    const entity = results.get(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `SafetyReport ${entityId} not found`);
    }
    if (!(variableCode in entity!)) {
      this.createRejection(entityId, variableCode, `Variable "${variableCode}" not resolved on SafetyReport ${entityId}`);
    }
    return (entity as any)[variableCode];
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<SafetyReportResolveDTO>>> {
    const results = new Map<number, Partial<SafetyReportResolveDTO>>();
    const uniqueIds = [...new Set(entityIds)];
    if (uniqueIds.length === 0) return results;

    const rows = await this.entityDataRepo.findSafetyReportBatch(uniqueIds);

    for (const id of uniqueIds) {
      const row = rows.get(id);
      if (!row) continue;
      const partial: Partial<SafetyReportResolveDTO> = {};
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
