import { BaseResolver } from './base.resolver';
import { UserResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';
import { EntityDataRepository } from './entity-data.repository';

export class UserResolver extends BaseResolver<UserResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['username', 'username'],
    ['email', 'email'],
    ['first_name_ar', 'first_name_ar'],
    ['last_name_ar', 'last_name_ar'],
    ['first_name_en', 'first_name_en'],
    ['last_name_en', 'last_name_en'],
    ['institution_id', 'institution_id'],
    ['institution_name_ar', 'institution_name_ar'],
    ['status', 'status'],
    ['roles', 'roles'],
    ['display_name', 'first_name_ar'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'username', fieldPath: 'username', description: 'User login name' },
      { variableCode: 'email', fieldPath: 'email', description: 'Email address' },
      { variableCode: 'first_name_ar', fieldPath: 'first_name_ar', description: 'First name in Arabic' },
      { variableCode: 'last_name_ar', fieldPath: 'last_name_ar', description: 'Last name in Arabic' },
      { variableCode: 'first_name_en', fieldPath: 'first_name_en', description: 'First name in English' },
      { variableCode: 'last_name_en', fieldPath: 'last_name_en', description: 'Last name in English' },
      { variableCode: 'institution_id', fieldPath: 'institution_id', description: 'Institution ID' },
      { variableCode: 'institution_name_ar', fieldPath: 'institution_name_ar', description: 'Institution name in Arabic' },
      { variableCode: 'status', fieldPath: 'status', description: 'User account status' },
      { variableCode: 'roles', fieldPath: 'roles', description: 'User roles' },
      { variableCode: 'display_name', fieldPath: 'first_name_ar', description: 'Alias for first_name_ar' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['EntityDataRepository'];
  }

  constructor(private entityDataRepo: EntityDataRepository) {
    super('User');
  }

  async resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown> {
    if (!this.variableMap.has(variableCode)) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }
    const results = await this.resolveBatch([entityId], [variableCode], context);
    const entity = results.get(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `User ${entityId} not found`);
    }
    if (!(variableCode in entity!)) {
      this.createRejection(entityId, variableCode, `Variable "${variableCode}" not resolved on User ${entityId}`);
    }
    return (entity as any)[variableCode];
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<UserResolveDTO>>> {
    const results = new Map<number, Partial<UserResolveDTO>>();
    const uniqueIds = [...new Set(entityIds)];
    if (uniqueIds.length === 0) return results;

    const rows = await this.entityDataRepo.findUserBatch(uniqueIds);

    for (const id of uniqueIds) {
      const row = rows.get(id);
      if (!row) continue;
      const partial: Partial<UserResolveDTO> = {};
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
