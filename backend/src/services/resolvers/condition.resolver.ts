import { BaseResolver } from './base.resolver';
import { ConditionResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';
import { EntityDataRepository } from './entity-data.repository';

export class ConditionResolver extends BaseResolver<ConditionResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['application_id', 'application_id'],
    ['condition_text', 'condition_text'],
    ['severity', 'severity'],
    ['category', 'category'],
    ['status', 'status'],
    ['due_date', 'due_date'],
    ['resolved_by', 'resolved_by'],
    ['resolved_at', 'resolved_at'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'application_id', fieldPath: 'application_id', description: 'Parent application ID' },
      { variableCode: 'condition_text', fieldPath: 'condition_text', description: 'Condition description text' },
      { variableCode: 'severity', fieldPath: 'severity', description: 'Condition severity level' },
      { variableCode: 'category', fieldPath: 'category', description: 'Condition category' },
      { variableCode: 'status', fieldPath: 'status', description: 'Current condition status' },
      { variableCode: 'due_date', fieldPath: 'due_date', description: 'Due date for compliance' },
      { variableCode: 'resolved_by', fieldPath: 'resolved_by', description: 'Who resolved the condition' },
      { variableCode: 'resolved_at', fieldPath: 'resolved_at', description: 'When the condition was resolved' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['EntityDataRepository'];
  }

  constructor(private entityDataRepo: EntityDataRepository) {
    super('Condition');
  }

  async resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown> {
    if (!this.variableMap.has(variableCode)) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }
    const results = await this.resolveBatch([entityId], [variableCode], context);
    const entity = results.get(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `Condition ${entityId} not found`);
    }
    if (!(variableCode in entity!)) {
      this.createRejection(entityId, variableCode, `Variable "${variableCode}" not resolved on Condition ${entityId}`);
    }
    return (entity as any)[variableCode];
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<ConditionResolveDTO>>> {
    const results = new Map<number, Partial<ConditionResolveDTO>>();
    const uniqueIds = [...new Set(entityIds)];
    if (uniqueIds.length === 0) return results;

    const rows = await this.entityDataRepo.findConditionBatch(uniqueIds);

    for (const id of uniqueIds) {
      const row = rows.get(id);
      if (!row) continue;
      const partial: Partial<ConditionResolveDTO> = {};
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
