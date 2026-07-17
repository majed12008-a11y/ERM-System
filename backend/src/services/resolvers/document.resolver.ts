import { BaseResolver } from './base.resolver';
import { DocumentResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';
import { EntityDataRepository } from './entity-data.repository';

export class DocumentResolver extends BaseResolver<DocumentResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['file_name', 'file_name'],
    ['file_type', 'file_type'],
    ['file_size_bytes', 'file_size_bytes'],
    ['entity_type', 'entity_type'],
    ['entity_id', 'entity_id'],
    ['uploaded_by', 'uploaded_by'],
    ['uploaded_by_username', 'uploaded_by_username'],
    ['created_at', 'created_at'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'file_name', fieldPath: 'file_name', description: 'Original file name' },
      { variableCode: 'file_type', fieldPath: 'file_type', description: 'File MIME type' },
      { variableCode: 'file_size_bytes', fieldPath: 'file_size_bytes', description: 'File size in bytes' },
      { variableCode: 'entity_type', fieldPath: 'entity_type', description: 'Related entity type' },
      { variableCode: 'entity_id', fieldPath: 'entity_id', description: 'Related entity ID' },
      { variableCode: 'uploaded_by', fieldPath: 'uploaded_by', description: 'Uploader user ID' },
      { variableCode: 'uploaded_by_username', fieldPath: 'uploaded_by_username', description: 'Uploader username' },
      { variableCode: 'created_at', fieldPath: 'created_at', description: 'Upload timestamp' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['EntityDataRepository'];
  }

  constructor(private entityDataRepo: EntityDataRepository) {
    super('Document');
  }

  async resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown> {
    if (!this.variableMap.has(variableCode)) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }
    const results = await this.resolveBatch([entityId], [variableCode], context);
    const entity = results.get(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `Document ${entityId} not found`);
    }
    if (!(variableCode in entity!)) {
      this.createRejection(entityId, variableCode, `Variable "${variableCode}" not resolved on Document ${entityId}`);
    }
    return (entity as any)[variableCode];
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<DocumentResolveDTO>>> {
    const results = new Map<number, Partial<DocumentResolveDTO>>();
    const uniqueIds = [...new Set(entityIds)];
    if (uniqueIds.length === 0) return results;

    const rows = await this.entityDataRepo.findDocumentBatch(uniqueIds);

    for (const id of uniqueIds) {
      const row = rows.get(id);
      if (!row) continue;
      const partial: Partial<DocumentResolveDTO> = {};
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
