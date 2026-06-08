export function successResponse<T>(data: T, message?: string) {
  return { success: true, data, message };
}

export function errorResponse(error: string) {
  return { success: false, error };
}

export function paginatedResponse<T>(data: T[], total: number, page: number, limit: number) {
  return {
    success: true,
    data,
    pagination: { page, limit, total, totalPages: Math.ceil(total / limit) },
  };
}
