import { BaseResolver } from './base.resolver';
import { ConditionResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';

export class ConditionResolver extends BaseResolver<ConditionResolveDTO> {


  protected variableMap = new Map<string, string>([
    ['condition_text', 'condition_text'],
    ['severity', 'severity'],
    ['category', 'category'],
    ['status', 'status'],
    ['due_date', 'due_date'],
    ['resolved_by', 'resolved_by'],
    ['resolved_at', 'resolved_at'],
    ['application_id', 'application_id'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'condition_text', fieldPath: 'condition_text', description: 'Condition description text' },
      { variableCode: 'severity', fieldPath: 'severity', description: 'Condition severity level' },
      { variableCode: 'category', fieldPath: 'category', description: 'Condition category' },
      { variableCode: 'status', fieldPath: 'status', description: 'Current condition status' },
      { variableCode: 'due_date', fieldPath: 'due_date', description: 'Due date for compliance' },
      { variableCode: 'resolved_by', fieldPath: 'resolved_by', description: 'Who resolved the condition' },
      { variableCode: 'resolved_at', fieldPath: 'resolved_at', description: 'When the condition was resolved' },
      { variableCode: 'application_id', fieldPath: 'application_id', description: 'Parent application ID' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['ConditionRepository'];
  }

  constructor(private conditionRepo: {
    findById(id: number): Promise<ConditionResolveDTO | null>;
    findByApplication(applicationId: number): Promise<ConditionResolveDTO[]>;
  }) {
    super('Condition');
  }

  async resolve(entityId: number, variableCode: string, _context?: ResolveContext): Promise<unknown> {
    const fieldPath = this.getFieldPath(variableCode);
    if (!fieldPath) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }

    const entity = await this.conditionRepo.findById(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `Condition ${entityId} not found`);
    }

    const value = this.resolveFieldPath(entity, fieldPath!);
    if (value === undefined) {
      this.createRejection(entityId, variableCode, `Field "${fieldPath}" not resolved on Condition ${entityId}`);
    }
    return value;
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<ConditionResolveDTO>>> {
    const results = new Map<number, Partial<ConditionResolveDTO>>();
    const uniqueIds = [...new Set(entityIds)];

    for (const id of uniqueIds) {
      const entity = await this.conditionRepo.findById(id);
      if (!entity) continue;

      const partial: Partial<ConditionResolveDTO> = {};
      for (const varCode of requestedVariables) {
        const fieldPath = this.getFieldPath(varCode);
        if (fieldPath) {
          const value = this.resolveFieldPath(entity, fieldPath);
          if (value !== undefined) {
            (partial as any)[varCode] = value;
          }
        }
      }
      results.set(id, partial);
    }

    return results;
  }

  private resolveFieldPath(obj: any, fieldPath: string): unknown {
    if (fieldPath.includes('.')) {
      return fieldPath.split('.').reduce((o, key) => o?.[key], obj);
    }
    return obj[fieldPath];
  }
}
