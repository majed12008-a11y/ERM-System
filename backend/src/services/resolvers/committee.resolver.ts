import { BaseResolver } from './base.resolver';
import { CommitteeResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';
import { EntityDataRepository } from './entity-data.repository';

export class CommitteeResolver extends BaseResolver<CommitteeResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['committee_code', 'committee_code'],
    ['committee_name_ar', 'committee_name_ar'],
    ['committee_name_en', 'committee_name_en'],
    ['committee_type', 'committee_type'],
    ['institution_id', 'institution_id'],
    ['is_active', 'is_active'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'committee_code', fieldPath: 'committee_code', description: 'Unique committee code' },
      { variableCode: 'committee_name_ar', fieldPath: 'committee_name_ar', description: 'Committee name in Arabic' },
      { variableCode: 'committee_name_en', fieldPath: 'committee_name_en', description: 'Committee name in English' },
      { variableCode: 'committee_type', fieldPath: 'committee_type', description: 'Committee type code' },
      { variableCode: 'institution_id', fieldPath: 'institution_id', description: 'Parent institution ID' },
      { variableCode: 'is_active', fieldPath: 'is_active', description: 'Whether the committee is active' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['EntityDataRepository'];
  }

  constructor(private entityDataRepo: EntityDataRepository) {
    super('Committee');
  }

  async resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown> {
    if (!this.resolveFieldName(variableCode, context?.locale ?? 'ar')) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }
    const results = await this.resolveBatch([entityId], [variableCode], context);
    const entity = results.get(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `Committee ${entityId} not found`);
    }
    if (!(variableCode in entity!)) {
      this.createRejection(entityId, variableCode, `Variable "${variableCode}" not resolved on Committee ${entityId}`);
    }
    return (entity as any)[variableCode];
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], context?: ResolveContext): Promise<Map<number, Partial<CommitteeResolveDTO>>> {
    const results = new Map<number, Partial<CommitteeResolveDTO>>();
    const uniqueIds = [...new Set(entityIds)];
    if (uniqueIds.length === 0) return results;

    const rows = await this.entityDataRepo.findCommitteeBatch(uniqueIds);
    const locale = context?.locale ?? 'ar';

    for (const id of uniqueIds) {
      const row = rows.get(id);
      if (!row) continue;
      const partial: Partial<CommitteeResolveDTO> = {};
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
