import { BaseResolver } from './base.resolver';
import { CommunicationResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';
import { EntityDataRepository } from './entity-data.repository';

export class CommunicationResolver extends BaseResolver<CommunicationResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['communication_type', 'communication_type'],
    ['subject', 'subject'],
    ['body', 'body'],
    ['sender_id', 'sender_id'],
    ['recipient_id', 'recipient_id'],
    ['sent_at', 'sent_at'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'communication_type', fieldPath: 'communication_type', description: 'Type of communication' },
      { variableCode: 'subject', fieldPath: 'subject', description: 'Communication subject' },
      { variableCode: 'body', fieldPath: 'body', description: 'Communication body' },
      { variableCode: 'sender_id', fieldPath: 'sender_id', description: 'Sender user ID' },
      { variableCode: 'recipient_id', fieldPath: 'recipient_id', description: 'Recipient user ID' },
      { variableCode: 'sent_at', fieldPath: 'sent_at', description: 'Send timestamp' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['EntityDataRepository'];
  }

  constructor(private entityDataRepo: EntityDataRepository) {
    super('Communication');
  }

  async resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown> {
    if (!this.variableMap.has(variableCode)) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }
    const results = await this.resolveBatch([entityId], [variableCode], context);
    const entity = results.get(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `Communication ${entityId} not found`);
    }
    if (!(variableCode in entity!)) {
      this.createRejection(entityId, variableCode, `Variable "${variableCode}" not resolved on Communication ${entityId}`);
    }
    return (entity as any)[variableCode];
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<CommunicationResolveDTO>>> {
    const results = new Map<number, Partial<CommunicationResolveDTO>>();
    const uniqueIds = [...new Set(entityIds)];
    if (uniqueIds.length === 0) return results;

    const rows = await this.entityDataRepo.findCommunicationBatch(uniqueIds);

    for (const id of uniqueIds) {
      const row = rows.get(id);
      if (!row) continue;
      const partial: Partial<CommunicationResolveDTO> = {};
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
