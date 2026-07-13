import { BaseResolver } from './base.resolver';
import { UserResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';

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
    return ['UsersRepository'];
  }

  constructor(private userRepo: { findById(id: number): Promise<UserResolveDTO | null> }) {
    super('User');
  }

  async resolve(entityId: number, variableCode: string, _context?: ResolveContext): Promise<unknown> {
    const fieldPath = this.getFieldPath(variableCode);
    if (!fieldPath) this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);

    const entity = await this.userRepo.findById(entityId);
    if (!entity) this.createRejection(entityId, variableCode, `User ${entityId} not found`);

    const value = this.resolveField(entity, fieldPath!);
    if (value === undefined) this.createRejection(entityId, variableCode, `Field "${fieldPath}" not resolved on User ${entityId}`);
    return value;
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<UserResolveDTO>>> {
    const results = new Map<number, Partial<UserResolveDTO>>();
    for (const id of [...new Set(entityIds)]) {
      const entity = await this.userRepo.findById(id);
      if (!entity) continue;
      const partial: Partial<UserResolveDTO> = {};
      for (const varCode of requestedVariables) {
        const fieldPath = this.getFieldPath(varCode);
        if (fieldPath) {
          const value = this.resolveField(entity, fieldPath);
          if (value !== undefined) (partial as any)[varCode] = value;
        }
      }
      results.set(id, partial);
    }
    return results;
  }

  private resolveField(obj: any, fieldPath: string): unknown {
    return fieldPath.includes('.') ? fieldPath.split('.').reduce((o, k) => o?.[k], obj) : obj[fieldPath];
  }
}
