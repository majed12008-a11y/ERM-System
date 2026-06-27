/*
 * صفحة قنوات الإشعارات: إدارة إعدادات إرسال الإشعارات
 * عبر البريد الإلكتروني والرسائل النصية والإشعارات الفورية.
 */
import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { useForm } from 'react-hook-form'
import { z } from 'zod'
import { zodResolver } from '@hookform/resolvers/zod'
import { Plus, Pencil, Trash2, Mail, MessageSquare, Bell, Settings2 } from 'lucide-react'
import api from '../../api/client'

type Tab = 'email' | 'sms' | 'push' | 'system'

const tabs: { key: Tab; label: string; icon: React.ComponentType<{ className?: string }> }[] = [
  { key: 'email', label: 'Email', icon: Mail },
  { key: 'sms', label: 'SMS', icon: MessageSquare },
  { key: 'push', label: 'Push', icon: Bell },
  { key: 'system', label: 'System', icon: Settings2 },
]

export default function NotificationChannels() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [activeTab, setActiveTab] = useState<Tab>('email')

  return (
    <div>
      <h1 className="text-2xl font-bold mb-6">{t('nav.notificationChannels') || 'Notification Channels'}</h1>
      <div className="flex gap-1 border-b mb-6">
        {tabs.map(tab => (
          <button
            key={tab.key}
            onClick={() => setActiveTab(tab.key)}
            className={`flex items-center gap-2 px-4 py-2 text-sm font-medium border-b-2 transition-colors ${
              activeTab === tab.key
                ? 'border-blue-600 text-blue-600'
                : 'border-transparent text-slate-500 hover:text-slate-700'
            }`}
          >
            <tab.icon className="w-4 h-4" />
            {tab.label}
          </button>
        ))}
      </div>
      {activeTab === 'email' && <EmailConfigSection />}
      {activeTab === 'sms' && <SmsConfigSection />}
      {activeTab === 'push' && <PushConfigSection />}
      {activeTab === 'system' && <SystemConfigSection />}
    </div>
  )
}

function EmailConfigSection() {
  const { t } = useTranslation()
  const qc = useQueryClient()
  const [showForm, setShowForm] = useState(false)
  const [editId, setEditId] = useState<number | null>(null)
  const [testing, setTesting] = useState(false)

  const schema = z.object({
    config_name: z.string().min(1),
    smtp_host: z.string().min(1),
    smtp_port: z.coerce.number().int().min(1).default(587),
    smtp_username: z.string().optional().default(''),
    smtp_password: z.string().optional().default(''),
    use_tls: z.boolean().optional().default(true),
    from_address: z.string().min(1),
    from_name: z.string().optional().default(''),
    is_active: z.boolean().optional().default(true),
  })

  type FormData = z.input<typeof schema>
  const { register, handleSubmit, reset, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: { config_name: '', smtp_host: '', smtp_port: 587, smtp_username: '', smtp_password: '', use_tls: true, from_address: '', from_name: '', is_active: true },
  })

  const { data: configs, isLoading } = useQuery({
    queryKey: ['email-config'],
    queryFn: () => api.get('/admin/email-config').then(r => r.data.data || []),
  })

  const createMut = useMutation({
    mutationFn: (body: any) => api.post('/admin/email-config', body),
    onSuccess: () => { toast.success('Email config created'); qc.invalidateQueries({ queryKey: ['email-config'] }); setShowForm(false); reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || 'Failed to create'),
  })

  const updateMut = useMutation({
    mutationFn: ({ id, data }: { id: number; data: any }) => api.put(`/admin/email-config/${id}`, data),
    onSuccess: () => { toast.success('Email config updated'); qc.invalidateQueries({ queryKey: ['email-config'] }); setEditId(null) },
    onError: (err: any) => toast.error(err.response?.data?.error || 'Failed to update'),
  })

  const deleteMut = useMutation({
    mutationFn: (id: number) => api.delete(`/admin/email-config/${id}`),
    onSuccess: () => { toast.success('Email config deleted'); qc.invalidateQueries({ queryKey: ['email-config'] }) },
    onError: (err: any) => toast.error(err.response?.data?.error || 'Failed to delete'),
  })

  const testMut = useMutation({
    mutationFn: () => api.post('/admin/email-config/test'),
    onSuccess: () => toast.success('Test email sent'),
    onError: (err: any) => toast.error(err.response?.data?.error || 'Test failed'),
  })

  function openEdit(c: any) {
    reset({ ...c, smtp_port: c.smtp_port || 587 })
    setEditId(c.id)
    setShowForm(true)
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-lg font-semibold">Email Configuration</h2>
        {!showForm && <button onClick={() => { setEditId(null); reset(); setShowForm(true) }} className="flex items-center gap-1 bg-blue-600 text-white px-3 py-1.5 rounded text-sm hover:bg-blue-700"><Plus className="w-4 h-4" /> Add Config</button>}
      </div>
      {showForm && (
        <form onSubmit={handleSubmit(d => editId ? updateMut.mutate({ id: editId, data: d }) : createMut.mutate(d))} className="bg-white p-4 rounded-lg border mb-4 space-y-3 max-w-lg">
          <div className="grid grid-cols-2 gap-3">
            <div><input placeholder="Config Name" {...register('config_name')} className="w-full p-2 border rounded text-sm" />{errors.config_name && <p className="text-red-500 text-xs">{errors.config_name.message}</p>}</div>
            <div><input placeholder="SMTP Host" {...register('smtp_host')} className="w-full p-2 border rounded text-sm" />{errors.smtp_host && <p className="text-red-500 text-xs">{errors.smtp_host.message}</p>}</div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div><input type="number" placeholder="Port" {...register('smtp_port')} className="w-full p-2 border rounded text-sm" /></div>
            <div><input placeholder="Username" {...register('smtp_username')} className="w-full p-2 border rounded text-sm" /></div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div><input type="password" placeholder="Password" {...register('smtp_password')} className="w-full p-2 border rounded text-sm" /></div>
            <div><input placeholder="From Address" {...register('from_address')} className="w-full p-2 border rounded text-sm" />{errors.from_address && <p className="text-red-500 text-xs">{errors.from_address.message}</p>}</div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div><input placeholder="From Name" {...register('from_name')} className="w-full p-2 border rounded text-sm" /></div>
            <div className="flex items-center gap-4">
              <label className="flex items-center gap-1 text-sm"><input type="checkbox" {...register('use_tls')} /> TLS</label>
              <label className="flex items-center gap-1 text-sm"><input type="checkbox" {...register('is_active')} /> Active</label>
            </div>
          </div>
          <div className="flex gap-2">
            <button type="submit" className="bg-blue-600 text-white px-4 py-1.5 rounded text-sm">{editId ? 'Update' : 'Create'}</button>
            <button type="button" onClick={() => { setShowForm(false); setEditId(null) }} className="bg-slate-200 px-4 py-1.5 rounded text-sm">Cancel</button>
          </div>
        </form>
      )}
      <button onClick={() => testMut.mutate()} disabled={testMut.isPending} className="text-sm text-blue-600 hover:underline mb-3 block">
        {testMut.isPending ? 'Sending...' : 'Send Test Email'}
      </button>
      <div className="space-y-2">
        {configs?.map((c: any) => (
          <div key={c.id} className="flex items-center justify-between bg-white p-3 rounded border text-sm">
            <div className="flex-1">
              <span className="font-medium">{c.config_name}</span>
              <span className="text-slate-400 mx-2">|</span>
              <span>{c.smtp_host}:{c.smtp_port}</span>
              <span className="text-slate-400 mx-2">|</span>
              <span>{c.from_address}</span>
              {c.is_active && <span className="ml-2 text-xs bg-green-100 text-green-700 px-1.5 py-0.5 rounded">Active</span>}
            </div>
            <div className="flex items-center gap-1">
              <button onClick={() => openEdit(c)} className="p-1 text-slate-400 hover:text-blue-600"><Pencil className="w-4 h-4" /></button>
              <button onClick={() => { if (confirm('Delete this config?')) deleteMut.mutate(c.id) }} className="p-1 text-slate-400 hover:text-red-600"><Trash2 className="w-4 h-4" /></button>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}

function SmsConfigSection() {
  const { t } = useTranslation()
  const qc = useQueryClient()
  const [showForm, setShowForm] = useState(false)
  const [editId, setEditId] = useState<number | null>(null)

  const schema = z.object({
    config_name: z.string().min(1),
    provider: z.string().min(1),
    api_key: z.string().optional().default(''),
    api_secret: z.string().optional().default(''),
    sender_name: z.string().optional().default(''),
    is_active: z.boolean().optional().default(true),
  })

  type FormData = z.input<typeof schema>
  const { register, handleSubmit, reset, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: { config_name: '', provider: '', api_key: '', api_secret: '', sender_name: '', is_active: true },
  })

  const { data: configs, isLoading } = useQuery({
    queryKey: ['sms-config'],
    queryFn: () => api.get('/admin/sms-config').then(r => r.data.data || []),
  })

  const createMut = useMutation({
    mutationFn: (body: any) => api.post('/admin/sms-config', body),
    onSuccess: () => { toast.success('SMS config created'); qc.invalidateQueries({ queryKey: ['sms-config'] }); setShowForm(false); reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || 'Failed to create'),
  })

  const updateMut = useMutation({
    mutationFn: ({ id, data }: { id: number; data: any }) => api.put(`/admin/sms-config/${id}`, data),
    onSuccess: () => { toast.success('SMS config updated'); qc.invalidateQueries({ queryKey: ['sms-config'] }); setEditId(null) },
    onError: (err: any) => toast.error(err.response?.data?.error || 'Failed to update'),
  })

  const deleteMut = useMutation({
    mutationFn: (id: number) => api.delete(`/admin/sms-config/${id}`),
    onSuccess: () => { toast.success('SMS config deleted'); qc.invalidateQueries({ queryKey: ['sms-config'] }) },
    onError: (err: any) => toast.error(err.response?.data?.error || 'Failed to delete'),
  })

  function openEdit(c: any) {
    reset(c)
    setEditId(c.id)
    setShowForm(true)
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-lg font-semibold">SMS Configuration</h2>
        {!showForm && <button onClick={() => { setEditId(null); reset(); setShowForm(true) }} className="flex items-center gap-1 bg-blue-600 text-white px-3 py-1.5 rounded text-sm hover:bg-blue-700"><Plus className="w-4 h-4" /> Add Config</button>}
      </div>
      {showForm && (
        <form onSubmit={handleSubmit(d => editId ? updateMut.mutate({ id: editId, data: d }) : createMut.mutate(d))} className="bg-white p-4 rounded-lg border mb-4 space-y-3 max-w-lg">
          <div className="grid grid-cols-2 gap-3">
            <div><input placeholder="Config Name" {...register('config_name')} className="w-full p-2 border rounded text-sm" />{errors.config_name && <p className="text-red-500 text-xs">{errors.config_name.message}</p>}</div>
            <div><input placeholder="Provider (e.g. twilio)" {...register('provider')} className="w-full p-2 border rounded text-sm" />{errors.provider && <p className="text-red-500 text-xs">{errors.provider.message}</p>}</div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div><input placeholder="API Key" {...register('api_key')} className="w-full p-2 border rounded text-sm" /></div>
            <div><input type="password" placeholder="API Secret" {...register('api_secret')} className="w-full p-2 border rounded text-sm" /></div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div><input placeholder="Sender Name" {...register('sender_name')} className="w-full p-2 border rounded text-sm" /></div>
            <div className="flex items-center"><label className="flex items-center gap-1 text-sm"><input type="checkbox" {...register('is_active')} /> Active</label></div>
          </div>
          <div className="flex gap-2">
            <button type="submit" className="bg-blue-600 text-white px-4 py-1.5 rounded text-sm">{editId ? 'Update' : 'Create'}</button>
            <button type="button" onClick={() => { setShowForm(false); setEditId(null) }} className="bg-slate-200 px-4 py-1.5 rounded text-sm">Cancel</button>
          </div>
        </form>
      )}
      <div className="space-y-2">
        {configs?.map((c: any) => (
          <div key={c.id} className="flex items-center justify-between bg-white p-3 rounded border text-sm">
            <div className="flex-1">
              <span className="font-medium">{c.config_name}</span>
              <span className="text-slate-400 mx-2">|</span>
              <span>{c.provider}</span>
              <span className="text-slate-400 mx-2">|</span>
              <span>{c.sender_name}</span>
              {c.is_active && <span className="ml-2 text-xs bg-green-100 text-green-700 px-1.5 py-0.5 rounded">Active</span>}
            </div>
            <div className="flex items-center gap-1">
              <button onClick={() => openEdit(c)} className="p-1 text-slate-400 hover:text-blue-600"><Pencil className="w-4 h-4" /></button>
              <button onClick={() => { if (confirm('Delete?')) deleteMut.mutate(c.id) }} className="p-1 text-slate-400 hover:text-red-600"><Trash2 className="w-4 h-4" /></button>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}

function PushConfigSection() {
  const { t } = useTranslation()
  const qc = useQueryClient()
  const [showForm, setShowForm] = useState(false)
  const [editId, setEditId] = useState<number | null>(null)

  const schema = z.object({
    config_name: z.string().min(1),
    provider: z.string().min(1),
    server_key: z.string().optional().default(''),
    app_id: z.string().optional().default(''),
    is_active: z.boolean().optional().default(true),
  })

  type FormData = z.input<typeof schema>
  const { register, handleSubmit, reset, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: { config_name: '', provider: 'FCM', server_key: '', app_id: '', is_active: true },
  })

  const { data: configs, isLoading } = useQuery({
    queryKey: ['push-config'],
    queryFn: () => api.get('/admin/push-config').then(r => r.data.data || []),
  })

  const createMut = useMutation({
    mutationFn: (body: any) => api.post('/admin/push-config', body),
    onSuccess: () => { toast.success('Push config created'); qc.invalidateQueries({ queryKey: ['push-config'] }); setShowForm(false); reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || 'Failed to create'),
  })

  const updateMut = useMutation({
    mutationFn: ({ id, data }: { id: number; data: any }) => api.put(`/admin/push-config/${id}`, data),
    onSuccess: () => { toast.success('Push config updated'); qc.invalidateQueries({ queryKey: ['push-config'] }); setEditId(null) },
    onError: (err: any) => toast.error(err.response?.data?.error || 'Failed to update'),
  })

  const deleteMut = useMutation({
    mutationFn: (id: number) => api.delete(`/admin/push-config/${id}`),
    onSuccess: () => { toast.success('Push config deleted'); qc.invalidateQueries({ queryKey: ['push-config'] }) },
    onError: (err: any) => toast.error(err.response?.data?.error || 'Failed to delete'),
  })

  function openEdit(c: any) {
    reset(c)
    setEditId(c.id)
    setShowForm(true)
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-lg font-semibold">Push Notification Configuration</h2>
        {!showForm && <button onClick={() => { setEditId(null); reset(); setShowForm(true) }} className="flex items-center gap-1 bg-blue-600 text-white px-3 py-1.5 rounded text-sm hover:bg-blue-700"><Plus className="w-4 h-4" /> Add Config</button>}
      </div>
      {showForm && (
        <form onSubmit={handleSubmit(d => editId ? updateMut.mutate({ id: editId, data: d }) : createMut.mutate(d))} className="bg-white p-4 rounded-lg border mb-4 space-y-3 max-w-lg">
          <div className="grid grid-cols-2 gap-3">
            <div><input placeholder="Config Name" {...register('config_name')} className="w-full p-2 border rounded text-sm" />{errors.config_name && <p className="text-red-500 text-xs">{errors.config_name.message}</p>}</div>
            <div>
              <select {...register('provider')} className="w-full p-2 border rounded text-sm">
                <option value="FCM">FCM (Firebase)</option>
                <option value="APNs">APNs (Apple)</option>
              </select>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div><input placeholder="Server Key" {...register('server_key')} className="w-full p-2 border rounded text-sm" /></div>
            <div><input placeholder="App ID" {...register('app_id')} className="w-full p-2 border rounded text-sm" /></div>
          </div>
          <div className="flex items-center gap-4">
            <label className="flex items-center gap-1 text-sm"><input type="checkbox" {...register('is_active')} /> Active</label>
          </div>
          <div className="flex gap-2">
            <button type="submit" className="bg-blue-600 text-white px-4 py-1.5 rounded text-sm">{editId ? 'Update' : 'Create'}</button>
            <button type="button" onClick={() => { setShowForm(false); setEditId(null) }} className="bg-slate-200 px-4 py-1.5 rounded text-sm">Cancel</button>
          </div>
        </form>
      )}
      <div className="space-y-2">
        {configs?.map((c: any) => (
          <div key={c.id} className="flex items-center justify-between bg-white p-3 rounded border text-sm">
            <div className="flex-1">
              <span className="font-medium">{c.config_name}</span>
              <span className="text-slate-400 mx-2">|</span>
              <span>{c.provider}</span>
              <span className="text-slate-400 mx-2">|</span>
              <span className="text-xs text-slate-400">App: {c.app_id || '\u2014'}</span>
              {c.is_active && <span className="ml-2 text-xs bg-green-100 text-green-700 px-1.5 py-0.5 rounded">Active</span>}
            </div>
            <div className="flex items-center gap-1">
              <button onClick={() => openEdit(c)} className="p-1 text-slate-400 hover:text-blue-600"><Pencil className="w-4 h-4" /></button>
              <button onClick={() => { if (confirm('Delete?')) deleteMut.mutate(c.id) }} className="p-1 text-slate-400 hover:text-red-600"><Trash2 className="w-4 h-4" /></button>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}

function SystemConfigSection() {
  const { t } = useTranslation()
  const qc = useQueryClient()
  const [editing, setEditing] = useState<Record<string, string>>({})

  const { data: configs, isLoading } = useQuery({
    queryKey: ['system-config'],
    queryFn: () => api.get('/admin/system-config/NOTIFICATION').then(r => r.data.data || []),
  })

  const updateMut = useMutation({
    mutationFn: ({ key, value }: { key: string; value: string }) =>
      api.put(`/admin/system-config/NOTIFICATION/${key}`, { config_value: value }),
    onSuccess: () => { toast.success('Config updated'); qc.invalidateQueries({ queryKey: ['system-config'] }) },
    onError: (err: any) => toast.error(err.response?.data?.error || 'Failed to update'),
  })

  function save(key: string) {
    const value = editing[key]
    if (value !== undefined) updateMut.mutate({ key, value })
    setEditing(prev => { const n = { ...prev }; delete n[key]; return n })
  }

  return (
    <div>
      <h2 className="text-lg font-semibold mb-4">System Notification Settings</h2>
      <p className="text-sm text-slate-500 mb-4">General notification system settings managed as key-value pairs.</p>
      <div className="space-y-2">
        {(configs || []).length === 0 && !isLoading && (
          <p className="text-sm text-slate-400">No notification settings yet. Add them via the API or database.</p>
        )}
        {configs?.map((c: any) => (
          <div key={c.id} className="flex items-center gap-3 bg-white p-3 rounded border text-sm">
            <span className="w-48 font-medium text-slate-600">{c.config_key}</span>
            {editing[c.config_key] !== undefined ? (
              <>
                <input
                  value={editing[c.config_key]}
                  onChange={e => setEditing(prev => ({ ...prev, [c.config_key]: e.target.value }))}
                  className="flex-1 p-1.5 border rounded text-sm"
                />
                <button onClick={() => save(c.config_key)} className="text-blue-600 hover:underline">Save</button>
                <button onClick={() => setEditing(prev => { const n = { ...prev }; delete n[c.config_key]; return n })} className="text-slate-400 hover:underline">Cancel</button>
              </>
            ) : (
              <>
                <span className="flex-1 font-mono text-xs">{c.config_value}</span>
                <button onClick={() => setEditing(prev => ({ ...prev, [c.config_key]: c.config_value }))} className="p-1 text-slate-400 hover:text-blue-600"><Pencil className="w-4 h-4" /></button>
              </>
            )}
          </div>
        ))}
      </div>
    </div>
  )
}
