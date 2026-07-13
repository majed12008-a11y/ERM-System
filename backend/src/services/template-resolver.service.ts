import {
  IResolver,
  ResolveRequest,
  ResolveResult,
  ResolveContext,
  BatchResolveInput,
  BatchResolveOutput,
  ResolverCache,
  CacheEntry,
} from '../shared/template-resolver.types';
import { FunctionRegistry, VALID_ENTITY_ROOTS } from '../shared/template-function-registry';
import { ResolverRegistry } from './template-resolver-registry';

export class TemplateResolverService {
  private cache: ResolverCache;

  constructor(
    private registry: ResolverRegistry,
    cache?: ResolverCache,
  ) {
    this.cache = cache ?? new DefaultResolverCache();
  }

  setCache(cache: ResolverCache): void {
    this.cache = cache;
  }

  clearCache(): void {
    this.cache.clear();
  }

  async resolveSingle(request: ResolveRequest, context?: ResolveContext): Promise<ResolveResult> {
    const start = Date.now();

    try {
      this.validateEntityType(request.entityType);

      const cached = this.cache.get(request.entityType, request.entityId, request.variableCode);
      if (cached !== undefined) {
        return {
          entityType: request.entityType,
          entityId: request.entityId,
          variableCode: request.variableCode,
          value: cached.value,
          resolved: true,
        };
      }

      const resolver = this.registry.getOrThrow(request.entityType);
      const value = await resolver.resolve(request.entityId, request.variableCode, context);

      this.cache.set(request.entityType, request.entityId, request.variableCode, value);

      return {
        entityType: request.entityType,
        entityId: request.entityId,
        variableCode: request.variableCode,
        value,
        resolved: true,
      };
    } catch (err: any) {
      return {
        entityType: request.entityType,
        entityId: request.entityId,
        variableCode: request.variableCode,
        value: null,
        resolved: false,
        error: err.message || 'Resolution failed',
      };
    }
  }

  async resolveBatch(input: BatchResolveInput): Promise<BatchResolveOutput> {
    const start = Date.now();
    const results: ResolveResult[] = [];
    let cachedCount = 0;

    const grouped = this.groupRequests(input.requests);

    for (const [entityType, entityRequests] of grouped) {
      try {
        this.validateEntityType(entityType);
      } catch {
        for (const req of entityRequests) {
          results.push({
            entityType: req.entityType,
            entityId: req.entityId,
            variableCode: req.variableCode,
            value: null,
            resolved: false,
            error: `Entity type "${entityType}" is not whitelisted`,
          });
        }
        continue;
      }

      const resolver = this.registry.get(entityType);
      if (!resolver) {
        for (const req of entityRequests) {
          results.push({
            entityType: req.entityType,
            entityId: req.entityId,
            variableCode: req.variableCode,
            value: null,
            resolved: false,
            error: `No resolver registered for entity type "${entityType}"`,
          });
        }
        continue;
      }

      const { uncached, cachedHits } = this.splitCached(entityRequests);
      cachedCount += cachedHits.length;

      for (const hit of cachedHits) {
        results.push({
          entityType: hit.entityType,
          entityId: hit.entityId,
          variableCode: hit.variableCode,
          value: hit.value,
          resolved: true,
        });
      }

      if (uncached.length === 0) continue;

      const deduplicated = this.deduplicateRequests(uncached);
      const allRequestedVariables = [...new Set(uncached.map(r => r.variableCode))];

      const entityIds = [...new Set(deduplicated.map(r => r.entityId))];
      const batchResults = await resolver.resolveBatch(entityIds, allRequestedVariables, input.context);

      for (const req of uncached) {
        const entityData = batchResults.get(req.entityId);
        if (entityData && req.variableCode in entityData) {
          const value = (entityData as any)[req.variableCode];
          this.cache.set(req.entityType, req.entityId, req.variableCode, value);
          results.push({
            entityType: req.entityType,
            entityId: req.entityId,
            variableCode: req.variableCode,
            value,
            resolved: true,
          });
        } else {
          results.push({
            entityType: req.entityType,
            entityId: req.entityId,
            variableCode: req.variableCode,
            value: null,
            resolved: false,
            error: entityData === undefined
              ? `Entity ${req.entityType}#${req.entityId} not found`
              : `Variable "${req.variableCode}" not available on ${req.entityType}#${req.entityId}`,
          });
        }
      }
    }

    const resolvedCount = results.filter(r => r.resolved).length;
    const failedCount = results.filter(r => !r.resolved).length;

    return {
      results,
      cachedCount,
      resolvedCount,
      failedCount,
      durationMs: Date.now() - start,
    };
  }

  async resolveFromVariableDefinitions(
    entityType: string,
    entityId: number,
    variableDefinitions: Array<{ code: string; resolver_path?: string; source_type: string; default_value?: any }>,
    context?: ResolveContext,
  ): Promise<Map<string, unknown>> {
    const results = new Map<string, unknown>();

    const entityRequests: ResolveRequest[] = [];
    const manualDefaults: Map<string, any> = new Map();
    const entityDefaults: Map<string, any> = new Map();

    for (const def of variableDefinitions) {
      if (def.source_type === 'entity' || def.source_type === 'computed') {
        entityRequests.push({
          entityType,
          entityId,
          variableCode: def.code,
        });
        if (def.default_value !== undefined) {
          entityDefaults.set(def.code, def.default_value);
        }
      } else {
        manualDefaults.set(def.code, def.default_value);
      }
    }

    if (entityRequests.length > 0) {
      const batchResult = await this.resolveBatch({ requests: entityRequests, context });
      for (const r of batchResult.results) {
        if (r.resolved) {
          results.set(r.variableCode, r.value);
        } else if (entityDefaults.has(r.variableCode)) {
          results.set(r.variableCode, entityDefaults.get(r.variableCode));
        } else if (manualDefaults.has(r.variableCode)) {
          results.set(r.variableCode, manualDefaults.get(r.variableCode));
        }
      }
    }

    for (const [code, value] of manualDefaults) {
      if (!results.has(code)) {
        results.set(code, value);
      }
    }

    return results;
  }

  // ─── Private Helpers ──────────────────────────────────────────────

  private validateEntityType(entityType: string): void {
    if (!VALID_ENTITY_ROOTS.includes(entityType)) {
      throw new Error(`Entity type "${entityType}" is not whitelisted. Valid roots: ${VALID_ENTITY_ROOTS.join(', ')}`);
    }
  }

  private groupRequests(requests: ResolveRequest[]): Map<string, ResolveRequest[]> {
    const grouped = new Map<string, ResolveRequest[]>();
    for (const req of requests) {
      const existing = grouped.get(req.entityType);
      if (existing) {
        existing.push(req);
      } else {
        grouped.set(req.entityType, [req]);
      }
    }
    return grouped;
  }

  private deduplicateRequests(requests: ResolveRequest[]): ResolveRequest[] {
    const seen = new Set<string>();
    return requests.filter(req => {
      const key = `${req.entityType}:${req.entityId}:${req.variableCode}`;
      if (seen.has(key)) return false;
      seen.add(key);
      return true;
    });
  }

  private splitCached(requests: ResolveRequest[]): {
    uncached: ResolveRequest[];
    cachedHits: Array<ResolveRequest & { value: unknown }>;
  } {
    const uncached: ResolveRequest[] = [];
    const cachedHits: Array<ResolveRequest & { value: unknown }> = [];

    for (const req of requests) {
      const entry = this.cache.get(req.entityType, req.entityId, req.variableCode);
      if (entry !== undefined) {
        cachedHits.push({ ...req, value: entry.value });
      } else {
        uncached.push(req);
      }
    }

    return { uncached, cachedHits };
  }
}

class DefaultResolverCache implements ResolverCache {
  private store = new Map<string, CacheEntry>();

  get(entityType: string, entityId: number, variableCode: string): CacheEntry | undefined {
    const key = `${entityType}:${entityId}:${variableCode}`;
    return this.store.get(key);
  }

  set(entityType: string, entityId: number, variableCode: string, value: unknown): void {
    const key = `${entityType}:${entityId}:${variableCode}`;
    this.store.set(key, { value, resolvedAt: new Date() });
  }

  clear(): void {
    this.store.clear();
  }
}
