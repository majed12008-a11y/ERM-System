import { BaseResolver } from './base.resolver';
import { ApplicationResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';

export class ApplicationResolver extends BaseResolver<ApplicationResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['application_number', 'application_number'],
    ['project_id', 'project_id'],
    ['project_title', 'project_title'],
    ['project_code', 'project_code'],
    ['application_type', 'application_type'],
    ['submitted_by', 'submitted_by'],
    ['submitted_by_username', 'submitted_by_username'],
    ['target_committee_id', 'target_committee_id'],
    ['current_status', 'current_status'],
    ['status_name_ar', 'status_name_ar'],
    ['created_at', 'created_at'],
    ['applicant_name', 'submitted_by_username'],
    ['protocol_number', 'application_number'],
    ['approval_date', 'created_at'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'application_number', fieldPath: 'application_number', description: 'Unique application number' },
      { variableCode: 'project_id', fieldPath: 'project_id', description: 'Related project ID' },
      { variableCode: 'project_title', fieldPath: 'project_title', description: 'Project title' },
      { variableCode: 'project_code', fieldPath: 'project_code', description: 'Project code' },
      { variableCode: 'application_type', fieldPath: 'application_type', description: 'Type of application' },
      { variableCode: 'submitted_by', fieldPath: 'submitted_by', description: 'Submitter user ID' },
      { variableCode: 'submitted_by_username', fieldPath: 'submitted_by_username', description: 'Submitter username' },
      { variableCode: 'target_committee_id', fieldPath: 'target_committee_id', description: 'Target committee ID' },
      { variableCode: 'current_status', fieldPath: 'current_status', description: 'Current workflow status' },
      { variableCode: 'status_name_ar', fieldPath: 'status_name_ar', description: 'Status name in Arabic' },
      { variableCode: 'created_at', fieldPath: 'created_at', description: 'Creation timestamp' },
      { variableCode: 'applicant_name', fieldPath: 'submitted_by_username', description: 'Alias for submitted_by_username' },
      { variableCode: 'protocol_number', fieldPath: 'application_number', description: 'Alias for application_number' },
      { variableCode: 'approval_date', fieldPath: 'created_at', description: 'Alias for created_at (set post-approval)' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['ApplicationRepository'];
  }

  constructor(private applicationRepo: { findById(id: number): Promise<ApplicationResolveDTO | null> }) {
    super('Application');
  }

  async resolve(entityId: number, variableCode: string, _context?: ResolveContext): Promise<unknown> {
    const fieldPath = this.getFieldPath(variableCode);
    if (!fieldPath) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }

    const entity = await this.applicationRepo.findById(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `Application ${entityId} not found`);
    }

    const value = this.resolveFieldPath(entity, fieldPath!);
    if (value === undefined) {
      this.createRejection(entityId, variableCode, `Field "${fieldPath}" not resolved on Application ${entityId}`);
    }
    return value;
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<ApplicationResolveDTO>>> {
    const results = new Map<number, Partial<ApplicationResolveDTO>>();

    const uniqueIds = [...new Set(entityIds)];
    for (const id of uniqueIds) {
      const entity = await this.applicationRepo.findById(id);
      if (!entity) continue;

      const partial: Partial<ApplicationResolveDTO> = {};
      for (const varCode of requestedVariables) {
        const fieldPath = this.getFieldPath(varCode);
        if (fieldPath) {
          const value = this.resolveFieldPath(entity, fieldPath);
          if (value !== undefined) {
            (partial as any)[varCode] = value;
          }
        }
      }
      results.set(id, partial);
    }

    return results;
  }

  private resolveFieldPath(obj: any, fieldPath: string): unknown {
    if (fieldPath.includes('.')) {
      return fieldPath.split('.').reduce((o, key) => o?.[key], obj);
    }
    return obj[fieldPath];
  }
}
