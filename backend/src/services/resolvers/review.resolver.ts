import { BaseResolver } from './base.resolver';
import { ReviewResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';
import { EntityDataRepository } from './entity-data.repository';

export class ReviewResolver extends BaseResolver<ReviewResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['application_id', 'application_id'],
    ['reviewer_id', 'reviewer_id'],
    ['reviewer_name', 'reviewer_name'],
    ['decision', 'decision'],
    ['comments', 'comments'],
    ['submitted_at', 'submitted_at'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'application_id', fieldPath: 'application_id', description: 'Reviewed application ID' },
      { variableCode: 'reviewer_id', fieldPath: 'reviewer_id', description: 'Reviewer user ID' },
      { variableCode: 'reviewer_name', fieldPath: 'reviewer_name', description: 'Reviewer display name' },
      { variableCode: 'decision', fieldPath: 'decision', description: 'Review decision' },
      { variableCode: 'comments', fieldPath: 'comments', description: 'Review comments' },
      { variableCode: 'submitted_at', fieldPath: 'submitted_at', description: 'Submission timestamp' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['EntityDataRepository'];
  }

  constructor(private entityDataRepo: EntityDataRepository) {
    super('Review');
  }

  async resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown> {
    if (!this.variableMap.has(variableCode)) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }
    const results = await this.resolveBatch([entityId], [variableCode], context);
    const entity = results.get(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `Review ${entityId} not found`);
    }
    if (!(variableCode in entity!)) {
      this.createRejection(entityId, variableCode, `Variable "${variableCode}" not resolved on Review ${entityId}`);
    }
    return (entity as any)[variableCode];
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<ReviewResolveDTO>>> {
    const results = new Map<number, Partial<ReviewResolveDTO>>();
    const uniqueIds = [...new Set(entityIds)];
    if (uniqueIds.length === 0) return results;

    const rows = await this.entityDataRepo.findReviewBatch(uniqueIds);

    for (const id of uniqueIds) {
      const row = rows.get(id);
      if (!row) continue;
      const partial: Partial<ReviewResolveDTO> = {};
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
