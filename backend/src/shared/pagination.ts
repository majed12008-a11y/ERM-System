/*
 * دوال مساعدة للترقيم (Pagination).
 * تحول معاملات الصفحات والحدود إلى OFFSET/LIMIT
 * لإستخدامها في استعلامات قاعدة البيانات.
 */
export interface PaginationParams {
  page: number;
  limit: number;
}

export interface PaginatedResult<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

export function parsePagination(query: Record<string, any>): PaginationParams {
  const page = Math.max(1, parseInt(query.page as string) || 1);
  const limit = Math.min(100, Math.max(1, parseInt(query.limit as string) || parseInt(query.pageSize as string) || 20));
  return { page, limit };
}

export function paginatedResult<T>(data: T[], total: number, params: PaginationParams): PaginatedResult<T> {
  return {
    data,
    pagination: {
      page: params.page,
      limit: params.limit,
      total,
      totalPages: Math.ceil(total / params.limit),
    },
  };
}
