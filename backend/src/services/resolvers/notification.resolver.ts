import { BaseResolver } from './base.resolver';
import { NotificationResolveDTO, ResolveContext, VariableMapping } from '../../shared/template-resolver.types';
import { EntityDataRepository } from './entity-data.repository';

export class NotificationResolver extends BaseResolver<NotificationResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['user_id', 'user_id'],
    ['notification_type', 'notification_type'],
    ['subject', 'subject'],
    ['message_body', 'message_body'],
    ['priority_level', 'priority_level'],
    ['created_at', 'created_at'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'user_id', fieldPath: 'user_id', description: 'Target user ID' },
      { variableCode: 'notification_type', fieldPath: 'notification_type', description: 'Type of notification' },
      { variableCode: 'subject', fieldPath: 'subject', description: 'Notification subject' },
      { variableCode: 'message_body', fieldPath: 'message_body', description: 'Notification body text' },
      { variableCode: 'priority_level', fieldPath: 'priority_level', description: 'Priority level' },
      { variableCode: 'created_at', fieldPath: 'created_at', description: 'Creation timestamp' },
    ];
  }

  get repositoryDependencies(): string[] {
    return ['EntityDataRepository'];
  }

  constructor(private entityDataRepo: EntityDataRepository) {
    super('Notification');
  }

  async resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown> {
    if (!this.variableMap.has(variableCode)) {
      this.createRejection(entityId, variableCode, `Unknown variable code "${variableCode}"`);
    }
    const results = await this.resolveBatch([entityId], [variableCode], context);
    const entity = results.get(entityId);
    if (!entity) {
      this.createRejection(entityId, variableCode, `Notification ${entityId} not found`);
    }
    if (!(variableCode in entity!)) {
      this.createRejection(entityId, variableCode, `Variable "${variableCode}" not resolved on Notification ${entityId}`);
    }
    return (entity as any)[variableCode];
  }

  async resolveBatch(entityIds: number[], requestedVariables: string[], _context?: ResolveContext): Promise<Map<number, Partial<NotificationResolveDTO>>> {
    const results = new Map<number, Partial<NotificationResolveDTO>>();
    const uniqueIds = [...new Set(entityIds)];
    if (uniqueIds.length === 0) return results;

    const rows = await this.entityDataRepo.findNotificationBatch(uniqueIds);

    for (const id of uniqueIds) {
      const row = rows.get(id);
      if (!row) continue;
      const partial: Partial<NotificationResolveDTO> = {};
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
