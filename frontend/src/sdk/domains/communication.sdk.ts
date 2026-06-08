import api from '../../api/client'
import type { SuccessResponse, Notification, Message, SendMessageRequest, User } from '../core/types'

export const notifications = {
  list() {
    return api.get<SuccessResponse<Notification[]>>('/communication/notifications')
  },

  markAsRead(id: number) {
    return api.patch<SuccessResponse<null>>(`/communication/notifications/${id}/read`)
  },

  markAllAsRead() {
    return api.patch<SuccessResponse<null>>('/communication/notifications/read-all')
  },

  delete(id: number) {
    return api.delete<SuccessResponse<null>>(`/communication/notifications/${id}`)
  },
}

export const messages = {
  list(params?: { folder?: 'inbox' | 'sent' }) {
    return api.get<SuccessResponse<Message[]>>('/communication/messages', { params })
  },

  getUnreadCount() {
    return api.get<SuccessResponse<{ count: number }>>('/communication/messages/unread-count')
  },

  getById(id: number) {
    return api.get<SuccessResponse<Message>>(`/communication/messages/${id}`)
  },

  send(data: SendMessageRequest) {
    return api.post<SuccessResponse<Message>>('/communication/messages', data)
  },

  delete(id: number) {
    return api.delete<SuccessResponse<null>>(`/communication/messages/${id}`)
  },

  downloadAttachment(messageId: number, attachmentId: number) {
    return api.get<Blob>(`/communication/messages/${messageId}/attachments/${attachmentId}`, {
      responseType: 'blob',
    })
  },

  searchUsers(query: string) {
    return api.get<SuccessResponse<Partial<User>[]>>('/communication/users/search', { params: { q: query } })
  },
}
