import { PoolClient } from 'pg';
import { PaginationParams } from '../shared/pagination';

/**
 * READ repositories:
 * - MUST NOT accept PoolClient
 * - MUST NOT start or manage transactions
 * - MUST perform SELECT operations only
 */
export interface IReadRepository<T> {
  findById(id: number): Promise<T | null>;
}

/**
 * Paginated READ:
 * - MUST NOT accept PoolClient
 * - MUST use parsePagination() from shared/pagination
 * - MUST return { rows, total } for the caller to wrap in paginatedResult()
 */
export interface IPaginatedReadRepository<T> {
  findAll(
    params: PaginationParams,
    userId: number | null,
    userRoles: string[],
    ...args: any[]
  ): Promise<{ rows: T[]; total: number }>;
}

/**
 * WRITE repositories — create:
 * - MUST receive PoolClient as the LAST parameter
 * - MUST be called from within a withTransaction() block in the Service layer
 * - MUST NOT call withTransaction() internally — the caller owns the boundary
 * - MUST use client.query() internally via the inherited this.query(text, params, client) pattern
 */
export interface IWriteRepository<T, CreateDTO = any> {
  create(data: CreateDTO, client: PoolClient): Promise<T>;
}

/**
 * Update repository — update by id:
 * - MUST receive PoolClient as the LAST parameter
 * - MUST be called from within a withTransaction() block
 */
export interface IUpdateRepository<T, UpdateDTO = any> {
  update(id: number, data: UpdateDTO, client: PoolClient): Promise<T | null>;
}

/**
 * Soft delete repository:
 * - MUST NOT accept PoolClient (soft delete is a standalone UPDATE operation
 *   that uses RLS + session-level set_config for auth)
 */
export interface ISoftDeleteRepository {
  softDelete(id: number): Promise<boolean>;
}
