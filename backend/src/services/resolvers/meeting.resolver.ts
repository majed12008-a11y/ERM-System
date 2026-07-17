import { BaseResolver } from './base.resolver';
import { MeetingResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';
import { EntityDataRepository } from './entity-data.repository';

export class MeetingResolver extends BaseResolver<MeetingResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['committee_id', 'committee_id'],
    ['meeting_date', 'meeting_date'],
    ['meeting_type', 'meeting_type'],
    ['status', 'status'],
    ['location', 'location'],
    ['committee_name', 'committee_name_ar'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'committee_id', fieldPath: 'committee_id', description: 'Committee ID hosting the meeting' },
      { variableCode: 'meeting_date', fieldPath: 'meeting_date', description: 'Meeting date' },
      { variableCode: 'meeting_type', fieldPath: 'meeting_type', description: 'Meeting type (regular/emergency)' },
      { variableCode: 'status', fieldPath: 'status', description: 'Meeting status' },
      { variableCode: 'location', fieldPath: 'location', description: 'Meeting location' },
      { variableCode: 'committee_name', fieldPath: 'committee_name_ar', description: 'Hosting committee name' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['EntityDataRepository'];
  }

  constructor(private entityDataRepo: EntityDataRepository) {
    super('Meeting');
  }

  async resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown> {
    if (!this.resolveFieldName(variableCode, context?.locale ?? 'ar')) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }
    const results = await this.resolveBatch([entityId], [variableCode], context);
    const entity = results.get(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `Meeting ${entityId} not found`);
    }
    if (!(variableCode in entity!)) {
      this.createRejection(entityId, variableCode, `Variable "${variableCode}" not resolved on Meeting ${entityId}`);
    }
    return (entity as any)[variableCode];
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], context?: ResolveContext): Promise<Map<number, Partial<MeetingResolveDTO>>> {
    const results = new Map<number, Partial<MeetingResolveDTO>>();
    const uniqueIds = [...new Set(entityIds)];
    if (uniqueIds.length === 0) return results;

    const rows = await this.entityDataRepo.findMeetingBatch(uniqueIds);
    const locale = context?.locale ?? 'ar';

    for (const id of uniqueIds) {
      const row = rows.get(id);
      if (!row) continue;
      const partial: Partial<MeetingResolveDTO> = {};
      for (const varCode of requestedVariables) {
        const field = this.resolveFieldName(varCode, locale);
        if (field && row[field] !== undefined) {
          (partial as any)[varCode] = row[field];
        }
      }
      results.set(id, partial);
    }
    return results;
  }

  private resolveFieldName(varCode: string, locale: string): string | undefined {
    if (varCode === 'committee_name') {
      return locale === 'en' ? 'committee_name_en' : 'committee_name_ar';
    }
    return this.variableMap.get(varCode);
  }
}
