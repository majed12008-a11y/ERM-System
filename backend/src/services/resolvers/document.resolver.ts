import { BaseResolver } from './base.resolver';
import { DocumentResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';

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
    return ['DocumentRepository'];
  }

  constructor(private documentRepo: { findById(id: number): Promise<DocumentResolveDTO | null> }) {
    super('Document');
  }

  async resolve(entityId: number, variableCode: string, _context?: ResolveContext): Promise<unknown> {
    const fieldPath = this.getFieldPath(variableCode);
    if (!fieldPath) this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    const entity = await this.documentRepo.findById(entityId);
    if (!entity) this.createRejection(entityId, variableCode, `Document ${entityId} not found`);
    const value = this.resolveField(entity, fieldPath!);
    if (value === undefined) this.createRejection(entityId, variableCode, `Field "${fieldPath}" not resolved on Document ${entityId}`);
    return value;
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<DocumentResolveDTO>>> {
    const results = new Map<number, Partial<DocumentResolveDTO>>();
    for (const id of [...new Set(entityIds)]) {
      const entity = await this.documentRepo.findById(id);
      if (!entity) continue;
      const partial: Partial<DocumentResolveDTO> = {};
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
