import { QueryResult, PoolClient } from 'pg';
import { query as dbQuery, withTransaction } from '../config/database';
import { getUserId } from '../middleware/context';

export abstract class AuditableRepository {
  protected getCurrentUserId(): number {
    return getUserId();
  }

  protected createMeta() {
    return {
      created_by: this.getCurrentUserId(),
      created_at: new Date(),
    };
  }

  protected updateMeta() {
    return {
      updated_by: this.getCurrentUserId(),
      updated_at: new Date(),
    };
  }

  protected deleteMeta() {
    return {
      deleted_by: this.getCurrentUserId(),
      deleted_at: new Date(),
    };
  }

  protected async query(text: string, params?: any[], client?: PoolClient): Promise<QueryResult> {
    if (client) {
      return client.query(text, params);
    }
    return dbQuery(text, params);
  }

  protected withTransaction<T>(fn: (client: PoolClient) => Promise<T>): Promise<T> {
    return withTransaction(fn);
  }
}
