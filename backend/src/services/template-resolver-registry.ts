import { IResolver, EntityRoot, ENTITY_ROOTS } from '../shared/template-resolver.types';
import { VALID_ENTITY_ROOTS } from '../shared/template-function-registry';

export class ResolverRegistry {
  private resolvers = new Map<string, IResolver<any>>();

  register<TDto extends Record<string, any>>(resolver: IResolver<TDto>): void {
    const entityType = resolver.entityType;

    if (!VALID_ENTITY_ROOTS.includes(entityType)) {
      throw new Error(`Cannot register resolver: "${entityType}" is not in the entity whitelist. Valid roots: ${VALID_ENTITY_ROOTS.join(', ')}`);
    }
    if (!(ENTITY_ROOTS as readonly string[]).includes(entityType as EntityRoot)) {
      throw new Error(`Cannot register resolver: "${entityType}" is not a known ENTITY_ROOTS constant`);
    }
    if (this.resolvers.has(entityType)) {
      throw new Error(`Resolver already registered for entity type "${entityType}"`);
    }

    this.resolvers.set(entityType, resolver);
  }

  get<TDto extends Record<string, any>>(entityType: string): IResolver<TDto> | undefined {
    const resolver = this.resolvers.get(entityType);
    return resolver as IResolver<TDto> | undefined;
  }

  getOrThrow<TDto extends Record<string, any>>(entityType: string): IResolver<TDto> {
    const resolver = this.get<TDto>(entityType);
    if (!resolver) {
      throw Object.assign(
        new Error(`No resolver registered for entity type "${entityType}". Available: ${this.getRegisteredTypes().join(', ') || 'none'}`),
        { status: 500 },
      );
    }
    return resolver;
  }

  has(entityType: string): boolean {
    return this.resolvers.has(entityType);
  }

  getRegisteredTypes(): string[] {
    return [...this.resolvers.keys()];
  }

  getRegisteredResolvers(): Map<string, IResolver<any>> {
    return new Map(this.resolvers);
  }

  isWhitelisted(entityType: string): boolean {
    return VALID_ENTITY_ROOTS.includes(entityType);
  }

  unregister(entityType: string): boolean {
    return this.resolvers.delete(entityType);
  }

  clear(): void {
    this.resolvers.clear();
  }

  get size(): number {
    return this.resolvers.size;
  }
}
