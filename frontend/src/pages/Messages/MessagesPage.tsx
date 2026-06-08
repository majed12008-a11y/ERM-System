import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { toast } from 'sonner'
import api from '../../api/client'
import { useAuth } from '../../context/AuthContext'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import ConfirmDialog from '../../components/ConfirmDialog'
import { messageSchema } from '../../lib/schemas'
import { Mail, Send, Inbox, Trash2, MessageSquare, Plus, ArrowLeft, CheckCheck } from 'lucide-react'
import { useTranslation } from 'react-i18next'

type MessageFormData = { subject: string; message_body?: string }

export default function MessagesPage() {
  const { t } = useTranslation()
  const { user } = useAuth()
  const queryClient = useQueryClient()
  const [box, setBox] = useState<'inbox' | 'sent'>('inbox')
  const [selectedId, setSelectedId] = useState<number | null>(null)
  const [composing, setComposing] = useState(false)
  const [recipientSearch, setRecipientSearch] = useState('')
  const [selectedRecipients, setSelectedRecipients] = useState<any[]>([])
  const [attachmentFiles, setAttachmentFiles] = useState<File[]>([])

  const { register, handleSubmit, reset: resetForm, formState: { errors } } = useForm<MessageFormData>({
    resolver: zodResolver(messageSchema),
  })

  const { data: messages, isLoading } = useQuery({
    queryKey: ['messages', box],
    queryFn: () => api.get(`/communication/messages?box=${box}`).then(r => r.data.data),
  })

  const { data: unread } = useQuery({
    queryKey: ['messages-unread'],
    queryFn: () => api.get('/communication/messages/unread-count').then(r => r.data.data),
    refetchInterval: 15000,
  })

  const { data: messageDetail } = useQuery({
    queryKey: ['message', selectedId],
    queryFn: () => api.get(`/communication/messages/${selectedId}`).then(r => r.data.data),
    enabled: !!selectedId,
  })

  const { data: searchResults } = useQuery({
    queryKey: ['user-search', recipientSearch],
    queryFn: () => api.get('/communication/users/search', { params: { q: recipientSearch } }).then(r => r.data.data),
    enabled: recipientSearch.length >= 2,
  })

  const [deleteTarget, setDeleteTarget] = useState<number | null>(null)
  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/communication/messages/${id}`),
    onSuccess: () => { toast.success(t('messages.deleted')); queryClient.invalidateQueries({ queryKey: ['messages'] }); setSelectedId(null); setDeleteTarget(null) },
  })

  async function onSend(data: MessageFormData) {
    if (selectedRecipients.length === 0) { toast.error(t('messages.recipientRequired')); return }
    try {
      const fd = new FormData()
      fd.append('recipient_ids', JSON.stringify(selectedRecipients.map(r => r.id)))
      fd.append('subject', data.subject)
      if (data.message_body) fd.append('message_body', data.message_body)
      attachmentFiles.forEach(f => fd.append('attachments', f))
      await api.post('/communication/messages', fd, { headers: { 'Content-Type': 'multipart/form-data' } })
      toast.success(t('messages.sentSuccess'))
      setComposing(false)
      setSelectedRecipients([])
      setAttachmentFiles([])
      resetForm()
      queryClient.invalidateQueries({ queryKey: ['messages'] })
      setBox('sent')
    } catch (err: any) {
      toast.error(err.response?.data?.error || t('messages.sendFailed'))
    }
  }

  function toggleRecipient(u: any) {
    setSelectedRecipients(prev =>
      prev.find(r => r.id === u.id) ? prev.filter(r => r.id !== u.id) : [...prev, u]
    )
    setRecipientSearch('')
  }

  if (selectedId && messageDetail) {
    return (
      <div>
        <button onClick={() => setSelectedId(null)} className="flex items-center gap-1 text-sm text-slate-500 hover:text-slate-700 mb-4">
          <ArrowLeft className="w-4 h-4" /> {box === 'inbox' ? t('messages.backToInbox') : t('messages.backToSent')}
        </button>
        <Card>
          <CardContent className="p-6 space-y-4">
            <div className="flex items-center justify-between">
              <h2 className="text-lg font-bold">{messageDetail.subject}</h2>
              <Button size="sm" variant="outline" className="text-red-500" onClick={() => setDeleteTarget(selectedId)}>
                <Trash2 className="w-3 h-3 mr-1" /> {t('messages.delete')}
              </Button>
            </div>
            <div className="flex items-center gap-3 text-sm text-slate-500 border-b pb-3">
              <span>{t('messages.from')} <strong>{messageDetail.sender_name}</strong></span>
              <span>•</span>
              <span>{new Date(messageDetail.created_at).toLocaleString()}</span>
            </div>
            {messageDetail.message_body && (
              <p className="text-sm text-slate-700 whitespace-pre-wrap">{messageDetail.message_body}</p>
            )}
            {messageDetail.recipients && messageDetail.recipients.length > 0 && (
              <div className="text-xs text-slate-400 border-t pt-3">
                {t('messages.to')} {messageDetail.recipients.map((r: any) => r.recipient_name).join(', ')}
              </div>
            )}
            {messageDetail.attachments && messageDetail.attachments.length > 0 && (
              <div className="border-t pt-3 space-y-1">
                <p className="text-xs text-slate-500 font-medium">{t('messages.attachments', { count: messageDetail.attachments.length })}</p>
                {messageDetail.attachments.map((a: any) => (
                  <a key={a.id} href={`/api/v1/communication/messages/${selectedId}/attachments/${a.id}`} target="_blank"
                    className="flex items-center gap-2 text-sm text-blue-600 hover:text-blue-800 hover:underline">
                    <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" /></svg>
                    {a.file_name}
                    {a.file_size && <span className="text-xs text-slate-400">({(a.file_size / 1024).toFixed(0)} KB)</span>}
                  </a>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    )
  }

  if (composing) {
    return (
      <div>
        <button onClick={() => setComposing(false)} className="flex items-center gap-1 text-sm text-slate-500 hover:text-slate-700 mb-4">
          <ArrowLeft className="w-4 h-4" /> {t('messages.back')}
        </button>
        <Card>
          <CardHeader><CardTitle className="text-sm">{t('messages.newMessage')}</CardTitle></CardHeader>
          <form onSubmit={handleSubmit(onSend)} className="space-y-3">
            <CardContent className="space-y-3">
              <div>
                <label className="block text-xs text-slate-500 mb-1">{t('messages.toLabel')}</label>
                <div className="flex flex-wrap gap-1 mb-1">
                  {selectedRecipients.map(r => (
                    <span key={r.id} className="bg-blue-100 text-blue-700 text-xs px-2 py-0.5 rounded flex items-center gap-1">
                      {r.username}
                      <button onClick={() => toggleRecipient(r)} className="text-blue-400 hover:text-blue-700">×</button>
                    </span>
                  ))}
                </div>
                <Input placeholder={t('messages.searchUsers')} value={recipientSearch} onChange={e => setRecipientSearch(e.target.value)} className="text-sm" />
                {searchResults && searchResults.length > 0 && (
                  <div className="border rounded mt-1 max-h-32 overflow-y-auto">
                    {searchResults.filter((u: any) => u.id !== user?.id).map((u: any) => (
                      <button key={u.id} onClick={() => toggleRecipient(u)}
                        className={`w-full text-left px-3 py-1.5 text-sm hover:bg-slate-50 ${selectedRecipients.find(r => r.id === u.id) ? 'bg-blue-50' : ''}`}>
                        {u.username} ({u.email})
                      </button>
                    ))}
                  </div>
                )}
              </div>
              <div>
                <label className="block text-xs text-slate-500 mb-1">{t('messages.subject')}</label>
                <Input {...register('subject')} className="text-sm" />
                {errors.subject && <p className="text-red-500 text-xs">{errors.subject.message}</p>}
              </div>
              <div>
                <label className="block text-xs text-slate-500 mb-1">{t('messages.body')}</label>
                <textarea {...register('message_body')} className="w-full p-2 border rounded text-sm" rows={6} />
              </div>
              <div>
                <label className="block text-xs text-slate-500 mb-1">{t('messages.attachmentsLabel')}</label>
                <input type="file" multiple onChange={e => setAttachmentFiles(Array.from(e.target.files || []))} className="text-sm w-full" />
                {attachmentFiles.length > 0 && (
                  <div className="flex flex-wrap gap-1 mt-1">
                    {attachmentFiles.map((f, i) => (
                      <span key={i} className="bg-slate-100 text-xs px-2 py-0.5 rounded flex items-center gap-1">
                        {f.name}
                        <button onClick={() => setAttachmentFiles(prev => prev.filter((_, j) => j !== i))} className="text-red-400 hover:text-red-600">×</button>
                      </span>
                    ))}
                  </div>
                )}
              </div>
              <Button type="submit" disabled={selectedRecipients.length === 0}>
                <Send className="w-3 h-3 mr-1" /> {t('messages.send')}
              </Button>
            </CardContent>
          </form>
        </Card>
      </div>
    )
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <MessageSquare className="w-6 h-6 text-blue-600" />
          <h1 className="text-2xl font-bold">{t('messages.title')}</h1>
          {unread && unread.count > 0 && (
            <span className="bg-red-500 text-white text-xs px-2 py-0.5 rounded-full">{t('messages.unread', { count: unread.count })}</span>
          )}
        </div>
        <Button size="sm" onClick={() => setComposing(true)}><Plus className="w-3 h-3 mr-1" /> {t('messages.compose')}</Button>
      </div>

      <div className="flex gap-2 mb-4 border-b pb-2">
        <button onClick={() => { setBox('inbox'); setSelectedId(null) }}
          className={`px-4 py-2 text-sm rounded-t font-medium flex items-center gap-1 ${box === 'inbox' ? 'bg-white border border-b-0 border-slate-200 text-blue-600' : 'text-slate-500 hover:text-slate-700'}`}>
          <Inbox className="w-4 h-4" /> {t('messages.inbox')}
          {unread && unread.count > 0 && <span className="bg-red-500 text-white text-xs px-1.5 py-0.5 rounded-full ml-1">{unread.count}</span>}
        </button>
        <button onClick={() => { setBox('sent'); setSelectedId(null) }}
          className={`px-4 py-2 text-sm rounded-t font-medium flex items-center gap-1 ${box === 'sent' ? 'bg-white border border-b-0 border-slate-200 text-blue-600' : 'text-slate-500 hover:text-slate-700'}`}>
          <Send className="w-4 h-4" /> {t('messages.sent')}
        </button>
      </div>

      {isLoading ? (
        <p className="text-slate-400">{t('common.loading')}</p>
      ) : messages && messages.length > 0 ? (
        <div className="space-y-2">
          {messages.map((m: any) => (
            <div key={m.id} onClick={() => setSelectedId(m.id)}
              className={`bg-white rounded-lg shadow-sm p-4 cursor-pointer hover:shadow-md transition-shadow flex items-start justify-between ${!m.is_read && box === 'inbox' ? 'border-l-4 border-blue-500' : ''}`}>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2">
                  {!m.is_read && box === 'inbox' && <span className="w-2 h-2 bg-blue-500 rounded-full flex-shrink-0" />}
                  <p className={`text-sm truncate ${!m.is_read && box === 'inbox' ? 'font-semibold' : 'font-medium'}`}>{m.subject}</p>
                </div>
                <p className="text-xs text-slate-500 mt-1">
                  {box === 'inbox' ? m.sender_name : t('messages.toRecipients', { count: m.recipient_count || 0 })} • {new Date(m.created_at).toLocaleString()}
                </p>
                {m.message_body && <p className="text-xs text-slate-400 mt-0.5 truncate">{m.message_body}</p>}
              </div>
              <div className="flex items-center gap-2 ml-2 flex-shrink-0">
                {box === 'inbox' && m.is_read && <CheckCheck className="w-3.5 h-3.5 text-blue-500" />}
                <button onClick={(e) => { e.stopPropagation(); setDeleteTarget(m.id) }} className="text-slate-300 hover:text-red-500">
                  <Trash2 className="w-3.5 h-3.5" />
                </button>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <Card><CardContent className="p-12 text-center text-slate-400"><Mail className="w-12 h-12 mx-auto mb-3 opacity-30" /><p>{t('messages.empty')}</p></CardContent></Card>
      )}

      <ConfirmDialog
        open={deleteTarget !== null}
        onOpenChange={(o) => { if (!o) setDeleteTarget(null) }}
        title={t('messages.deleteTitle')}
        description={t('messages.deleteConfirm')}
        onConfirm={() => deleteTarget && deleteMutation.mutate(deleteTarget)}
        loading={deleteMutation.isPending}
      />
    </div>
  )
}