import { describe, it, expect } from 'vitest';
import { successResponse, errorResponse, paginatedResponse } from '../shared/utils';

describe('Response helpers', () => {
  it('successResponse returns correct shape', () => {
    const res = successResponse({ id: 1 }, 'Created');
    expect(res.success).toBe(true);
    expect(res.data).toEqual({ id: 1 });
    expect(res.message).toBe('Created');
  });

  it('errorResponse returns correct shape', () => {
    const res = errorResponse('Something went wrong');
    expect(res.success).toBe(false);
    expect(res.error).toBe('Something went wrong');
  });

  it('paginatedResponse includes pagination', () => {
    const res = paginatedResponse([1, 2], 100, 1, 20);
    expect(res.success).toBe(true);
    expect(res.pagination).toEqual({ page: 1, limit: 20, total: 100, totalPages: 5 });
    expect(res.data).toEqual([1, 2]);
  });
});
