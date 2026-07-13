import { BaseResolver } from './base.resolver';
import { CommitteeResolveDTO, MeetingResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';

export class CommitteeResolver extends BaseResolver<CommitteeResolveDTO> {


  protected variableMap = new Map<string, string>([
    ['committee_code', 'committee_code'],
    ['committee_name_ar', 'committee_name_ar'],
    ['committee_name_en', 'committee_name_en'],
    ['committee_type', 'committee_type'],
    ['institution_id', 'institution_id'],
    ['is_active', 'is_active'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'committee_code', fieldPath: 'committee_code', description: 'Unique committee code' },
      { variableCode: 'committee_name_ar', fieldPath: 'committee_name_ar', description: 'Committee name in Arabic' },
      { variableCode: 'committee_name_en', fieldPath: 'committee_name_en', description: 'Committee name in English' },
      { variableCode: 'committee_type', fieldPath: 'committee_type', description: 'Committee type' },
      { variableCode: 'institution_id', fieldPath: 'institution_id', description: 'Parent institution ID' },
      { variableCode: 'is_active', fieldPath: 'is_active', description: 'Whether the committee is active' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['CommitteeRepository'];
  }

  constructor(private committeeRepo: { findById(id: number): Promise<CommitteeResolveDTO | null> }) {
    super('Committee');
  }

  async resolve(entityId: number, variableCode: string, _context?: ResolveContext): Promise<unknown> {
    const fieldPath = this.getFieldPath(variableCode);
    if (!fieldPath) this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);

    const entity = await this.committeeRepo.findById(entityId);
    if (!entity) this.createRejection(entityId, variableCode, `Committee ${entityId} not found`);

    const value = this.resolveField(entity, fieldPath!);
    if (value === undefined) this.createRejection(entityId, variableCode, `Field "${fieldPath}" not resolved on Committee ${entityId}`);
    return value;
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<CommitteeResolveDTO>>> {
    const results = new Map<number, Partial<CommitteeResolveDTO>>();
    for (const id of [...new Set(entityIds)]) {
      const entity = await this.committeeRepo.findById(id);
      if (!entity) continue;
      const partial: Partial<CommitteeResolveDTO> = {};
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

export class MeetingResolver extends BaseResolver<MeetingResolveDTO> {


  protected variableMap = new Map<string, string>([
    ['committee_id', 'committee_id'],
    ['meeting_date', 'meeting_date'],
    ['meeting_type', 'meeting_type'],
    ['status', 'status'],
    ['location', 'location'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'committee_id', fieldPath: 'committee_id', description: 'Committee ID hosting the meeting' },
      { variableCode: 'meeting_date', fieldPath: 'meeting_date', description: 'Meeting date' },
      { variableCode: 'meeting_type', fieldPath: 'meeting_type', description: 'Meeting type (regular/emergency)' },
      { variableCode: 'status', fieldPath: 'status', description: 'Meeting status' },
      { variableCode: 'location', fieldPath: 'location', description: 'Meeting location' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['CommitteeRepository'];
  }

  constructor(private meetingRepo: { findById(id: number): Promise<MeetingResolveDTO | null> }) {
    super('Meeting');
  }

  async resolve(entityId: number, variableCode: string, _context?: ResolveContext): Promise<unknown> {
    const fieldPath = this.getFieldPath(variableCode);
    if (!fieldPath) this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    const entity = await this.meetingRepo.findById(entityId);
    if (!entity) this.createRejection(entityId, variableCode, `Meeting ${entityId} not found`);
    const value = this.resolveField(entity, fieldPath!);
    if (value === undefined) this.createRejection(entityId, variableCode, `Field "${fieldPath}" not resolved`);
    return value;
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<MeetingResolveDTO>>> {
    const results = new Map<number, Partial<MeetingResolveDTO>>();
    for (const id of [...new Set(entityIds)]) {
      const entity = await this.meetingRepo.findById(id);
      if (!entity) continue;
      const partial: Partial<MeetingResolveDTO> = {};
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
