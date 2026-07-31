import { v7 as uuidv7 } from 'uuid';
import { TemplateEngineService, IEngineVersionRepository } from './template-engine.service';
import { SnapshotService } from './template-snapshot.service';
import { RenderDocumentRequest, RenderDocumentResult, MODULE_DOCUMENTS, ModuleDocumentConfig } from '../shared/template-integration.types';
import type { ResolveContext } from '../shared/template-resolver.types';

type SnapshotEntityType =
  | 'lifecycle_event'
  | 'approval_step'
  | 'rollback'
  | 'pdf_generation'
  | 'docx_generation';

export class TemplateIntegrationService {
  constructor(
    private engine: TemplateEngineService,
    private snapshotService: SnapshotService,
    private versionRepo: IEngineVersionRepository,
  ) {}

  async renderDocument(request: RenderDocumentRequest): Promise<RenderDocumentResult> {
    const correlationId = request.correlationId || uuidv7();
    const locale = request.locale || 'ar';

    const renderResult = await this.engine.render({
      templateCode: request.templateCode,
      version: request.version,
      variables: request.variables,
      locale,
      entityType: request.entityType,
      entityId: request.entityId,
      userContext: request.userContext || { locale },
    });

    const snapshot = await this.snapshotService.createSnapshot({
      templateVersionId: renderResult.versionId,
      contentHash: renderResult.contentHash,
      locale,
      renderedHtml: renderResult.html,
      renderedBy: request.renderedBy,
      correlationId,
      requestId: uuidv7(),
      metadata: {
        templateCode: request.templateCode,
        version: request.version,
        variableCount: renderResult.variableCount,
        resolutionTimeMs: renderResult.resolutionTimeMs,
        cacheHit: renderResult.cacheHit,
      },
      variables: request.variables,
    });

    return {
      html: renderResult.html,
      renderResult,
      snapshot,
      snapshotHash: snapshot.snapshotHash,
      correlationId,
    };
  }

  async renderModuleDocument(
    moduleKey: string,
    variables: Record<string, unknown>,
    renderedBy: number,
    options?: {
      locale?: string;
      entityType?: string;
      entityId?: number;
      userContext?: ResolveContext;
      correlationId?: string;
    },
  ): Promise<RenderDocumentResult> {
    const config = MODULE_DOCUMENTS[moduleKey];
    if (!config) {
      throw Object.assign(
        new Error(`Unknown module document key: "${moduleKey}"`),
        { status: 404 },
      );
    }

    return this.renderDocument({
      templateCode: config.templateCode,
      version: config.version,
      variables,
      renderedBy,
      locale: options?.locale,
      entityType: options?.entityType || config.entityType,
      entityId: options?.entityId,
      userContext: options?.userContext,
      correlationId: options?.correlationId,
    });
  }

  async renderApplicationDocument(
    documentType: string,
    variables: Record<string, unknown>,
    applicationId: number,
    userId: number,
    extraOptions?: {
      locale?: string;
      userContext?: ResolveContext;
    },
  ): Promise<RenderDocumentResult> {
    const moduleKey = `application.${documentType}`;
    const config = MODULE_DOCUMENTS[moduleKey];
    if (!config) {
      throw Object.assign(
        new Error(`Unknown application document type: "${documentType}"`),
        { status: 404 },
      );
    }

    return this.renderDocument({
      templateCode: config.templateCode,
      version: config.version,
      variables,
      renderedBy: userId,
      locale: extraOptions?.locale,
      entityType: 'Application',
      entityId: applicationId,
      userContext: extraOptions?.userContext || { userId, locale: extraOptions?.locale || 'ar' },
    });
  }

  async linkSnapshotToEntity(
    snapshotId: number,
    entityType: SnapshotEntityType,
    entityId: number,
  ): Promise<void> {
    await this.snapshotService.addReference(snapshotId, entityType, entityId);
  }
}

export { MODULE_DOCUMENTS };
export type { RenderDocumentRequest, RenderDocumentResult, ModuleDocumentConfig };
