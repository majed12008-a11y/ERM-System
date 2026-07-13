import { IResolver, ResolveContext, CacheEntry, ENTITY_ROOTS, EntityRoot } from '../../shared/template-resolver.types';
import { VALID_ENTITY_ROOTS } from '../../shared/template-function-registry';

export abstract class BaseResolver<TDto extends Record<string, any>> implements IResolver<TDto> {
  readonly entityType: string;
  protected variableMap = new Map<string, string>();

  constructor(entityType: string) {
    this.entityType = entityType;
    this.ensureEntityRootWhitelisted();
  }

  private ensureEntityRootWhitelisted(): void {
    if (!VALID_ENTITY_ROOTS.includes(this.entityType)) {
      throw new Error(`Entity root "${this.entityType}" is not in the whitelist. Valid roots: ${VALID_ENTITY_ROOTS.join(', ')}`);
    }
    if (!(ENTITY_ROOTS as readonly string[]).includes(this.entityType)) {
      throw new Error(`Entity root "${this.entityType}" is not a known ENTITY_ROOTS constant.`);
    }
  }

  protected getFieldPath(variableCode: string): string | undefined {
    return this.variableMap.get(variableCode);
  }

  abstract resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown>;

  abstract resolveBatch(entityIds: number[], requestedVariables: string[], context?: ResolveContext): Promise<Map<number, Partial<TDto>>>;

  protected buildCacheKey(entityId: number, variableCode: string): string {
    return `${this.entityType}:${entityId}:${variableCode}`;
  }

  protected buildEntityCacheKey(entityId: number): string {
    return `${this.entityType}:${entityId}`;
  }

  protected createRejection(entityId: number, variableCode: string, reason: string): never {
    throw Object.assign(new Error(`Resolver[${this.entityType}] reject: ${reason}`), { status: 400 });
  }
}
