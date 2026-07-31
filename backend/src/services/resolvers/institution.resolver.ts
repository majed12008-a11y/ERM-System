import { BaseResolver } from './base.resolver';
import { InstitutionResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';
import { EntityDataRepository } from './entity-data.repository';

export class InstitutionResolver extends BaseResolver<InstitutionResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['name_ar', 'name_ar'],
    ['name_en', 'name_en'],
    ['code', 'code'],
    ['city', 'city'],
    ['country', 'country'],
    ['is_active', 'is_active'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'name_ar', fieldPath: 'name_ar', description: 'Institution name in Arabic' },
      { variableCode: 'name_en', fieldPath: 'name_en', description: 'Institution name in English' },
      { variableCode: 'code', fieldPath: 'code', description: 'Institution code' },
      { variableCode: 'city', fieldPath: 'city', description: 'City' },
      { variableCode: 'country', fieldPath: 'country', description: 'Country' },
      { variableCode: 'is_active', fieldPath: 'is_active', description: 'Active status' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['EntityDataRepository'];
  }

  constructor(private entityDataRepo: EntityDataRepository) {
    super('Institution');
  }

  async resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown> {
    if (!this.resolveFieldName(variableCode, context?.locale ?? 'ar')) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }
    const results = await this.resolveBatch([entityId], [variableCode], context);
    const entity = results.get(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `Institution ${entityId} not found`);
    }
    if (!(variableCode in entity!)) {
      this.createRejection(entityId, variableCode, `Variable "${variableCode}" not resolved on Institution ${entityId}`);
    }
    return (entity as any)[variableCode];
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], context?: ResolveContext): Promise<Map<number, Partial<InstitutionResolveDTO>>> {
    const results = new Map<number, Partial<InstitutionResolveDTO>>();
    const uniqueIds = [...new Set(entityIds)];
    if (uniqueIds.length === 0) return results;

    const rows = await this.entityDataRepo.findInstitutionBatch(uniqueIds);
    const locale = context?.locale ?? 'ar';

    for (const id of uniqueIds) {
      const row = rows.get(id);
      if (!row) continue;
      const partial: Partial<InstitutionResolveDTO> = {};
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
    if (varCode === 'name') {
      return locale === 'en' ? 'name_en' : 'name_ar';
    }
    return this.variableMap.get(varCode);
  }
}
