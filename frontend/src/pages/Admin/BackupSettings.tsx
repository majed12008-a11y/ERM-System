/*
 * صفحة إعدادات النسخ الاحتياطي: إنشاء نسخ احتياطية،
 * جدولة النسخ التلقائي، وإدارة ملفات النسخ.
 */
import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import api from '../../api/client'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { Table, TableHeader, TableBody, TableRow, TableHead, TableCell } from '../../components/ui/table'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from '../../components/ui/dialog'
import { PageSkeleton } from '../../components/LoadingSkeleton'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { Database, Download, RotateCcw, Trash2, ShieldCheck, HardDrive } from 'lucide-react'

interface BackupFile {
  name: string
  size: number
  created_at: string
}

interface VerifyEntity {
  entity: string
  row_count: number
}

function formatSize(bytes: number): string {
  if (bytes >= 1073741824) return `${(bytes / 1073741824).toFixed(2)} GB`
  if (bytes >= 1048576) return `${(bytes / 1048576).toFixed(2)} MB`
  if (bytes >= 1024) return `${(bytes / 1024).toFixed(2)} KB`
  return `${bytes} B`
}

export default function BackupSettings() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [restoreTarget, setRestoreTarget] = useState<string | null>(null)
  const [deleteTarget, setDeleteTarget] = useState<string | null>(null)
  const [verifyResult, setVerifyResult] = useState<{ name: string; entities: VerifyEntity[] } | null>(null)

  const { data: backups = [], isLoading } = useQuery<BackupFile[]>({
    queryKey: ['admin-backups'],
    queryFn: async () => {
      const res = await api.get('/admin/backup')
      return res.data.data
    },
  })

  const createMutation = useMutation({
    mutationFn: async () => {
      const res = await api.post('/admin/backup')
      return res.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-backups'] })
      toast.success(t('backup.created'))
    },
    onError: (err: any) => {
      toast.error(t('backup.createFailed') + (err.response?.data?.error ? `: ${err.response.data.error}` : ''))
    },
  })

  const verifyMutation = useMutation({
    mutationFn: async (name: string) => {
      const res = await api.post(`/admin/backup/${encodeURIComponent(name)}/verify`)
      return res.data
    },
    onSuccess: (data: any) => {
      toast.success(t('backup.verified'))
      setVerifyResult({ name: data.data.backup, entities: data.data.entities })
    },
    onError: (err: any) => {
      toast.error(t('backup.verifyFailed') + (err.response?.data?.error ? `: ${err.response.data.error}` : ''))
    },
  })

  const restoreMutation = useMutation({
    mutationFn: async (name: string) => {
      const res = await api.post(`/admin/backup/${encodeURIComponent(name)}/restore`)
      return res.data
    },
    onSuccess: () => {
      setRestoreTarget(null)
      queryClient.invalidateQueries({ queryKey: ['admin-backups'] })
      toast.success(t('backup.restored'))
    },
    onError: (err: any) => {
      setRestoreTarget(null)
      toast.error(t('backup.restoreFailed') + (err.response?.data?.error ? `: ${err.response.data.error}` : ''))
    },
  })

  const deleteMutation = useMutation({
    mutationFn: async (name: string) => {
      await api.delete(`/admin/backup/${encodeURIComponent(name)}`)
    },
    onSuccess: () => {
      setDeleteTarget(null)
      queryClient.invalidateQueries({ queryKey: ['admin-backups'] })
      toast.success(t('backup.deleted'))
    },
    onError: (err: any) => {
      setDeleteTarget(null)
      toast.error(t('backup.deleteFailed') + (err.response?.data?.error ? `: ${err.response.data.error}` : ''))
    },
  })

  function handleDownload(name: string) {
    const token = sessionStorage.getItem('access_token')
    const url = `/api/v1/admin/backup/${encodeURIComponent(name)}/download`
    if (token) {
      const a = document.createElement('a')
      a.href = url
      window.open(url, '_blank')
    }
  }

  if (isLoading) return <PageSkeleton />

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <Database className="h-6 w-6" /> {t('backup.title')}
          </h1>
          <p className="text-muted-foreground">{t('backup.description')}</p>
        </div>
        <Button onClick={() => createMutation.mutate()} disabled={createMutation.isPending}>
          <HardDrive className="h-4 w-4 ml-2" />
          {createMutation.isPending ? t('backup.creating') : t('backup.createBackup')}
        </Button>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <ShieldCheck className="h-5 w-5" />
            {t('backup.title')}
          </CardTitle>
        </CardHeader>
        <CardContent>
          {backups.length === 0 ? (
            <p className="text-muted-foreground text-center py-8">{t('backup.noBackups')}</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>{t('backup.name')}</TableHead>
                  <TableHead>{t('backup.size')}</TableHead>
                  <TableHead>{t('backup.createdAt')}</TableHead>
                  <TableHead className="text-left">{t('backup.actions')}</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {backups.map((b) => (
                  <TableRow key={b.name}>
                    <TableCell className="font-mono text-sm">{b.name}</TableCell>
                    <TableCell>{formatSize(b.size)}</TableCell>
                    <TableCell>{new Date(b.created_at).toLocaleString()}</TableCell>
                    <TableCell>
                      <div className="flex gap-2">
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => verifyMutation.mutate(b.name)}
                          disabled={verifyMutation.isPending && verifyMutation.variables === b.name}
                        >
                          {t('backup.verify')}
                        </Button>
                        <Button variant="outline" size="sm" onClick={() => handleDownload(b.name)}>
                          <Download className="h-4 w-4" />
                        </Button>
                        <Button
                          variant="secondary"
                          size="sm"
                          onClick={() => setRestoreTarget(b.name)}
                        >
                          <RotateCcw className="h-4 w-4 ml-1" />
                          {t('backup.restore')}
                        </Button>
                        <Button
                          variant="destructive"
                          size="sm"
                          onClick={() => setDeleteTarget(b.name)}
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>

      {verifyResult && (
        <Card>
          <CardHeader>
            <CardTitle>{t('backup.verifyResult')}: {verifyResult.name}</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>{t('backup.entity')}</TableHead>
                  <TableHead>{t('backup.rowCount')}</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {verifyResult.entities.map((e) => (
                  <TableRow key={e.entity}>
                    <TableCell>{e.entity}</TableCell>
                    <TableCell>{e.row_count.toLocaleString()}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      )}

      <Dialog open={restoreTarget !== null} onOpenChange={(o) => !o && setRestoreTarget(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{t('backup.restoreConfirmTitle')}</DialogTitle>
            <DialogDescription>
              {t('backup.restoreConfirm')}
              {restoreTarget && <p className="mt-2 font-mono text-sm p-2 bg-muted rounded">{restoreTarget}</p>}
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setRestoreTarget(null)}>{t('common.cancel')}</Button>
            <Button
              variant="destructive"
              onClick={() => restoreTarget && restoreMutation.mutate(restoreTarget)}
              disabled={restoreMutation.isPending}
            >
              {restoreMutation.isPending ? t('backup.restoring') : t('backup.restore')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={deleteTarget !== null} onOpenChange={(o) => !o && setDeleteTarget(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{t('common.confirm')}</DialogTitle>
            <DialogDescription>
              {t('backup.deleteConfirm')}
              {deleteTarget && <p className="mt-2 font-mono text-sm p-2 bg-muted rounded">{deleteTarget}</p>}
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleteTarget(null)}>{t('common.cancel')}</Button>
            <Button
              variant="destructive"
              onClick={() => deleteTarget && deleteMutation.mutate(deleteTarget)}
              disabled={deleteMutation.isPending}
            >
              {t('backup.delete')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
