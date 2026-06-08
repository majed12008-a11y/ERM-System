import { useState, useMemo, memo } from 'react'
import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow
} from './ui/table'
import { Input } from './ui/input'
import { Search, ChevronLeft, ChevronRight, ArrowUpDown, ArrowUp, ArrowDown, Inbox } from 'lucide-react'

interface Column<T> {
  key: string
  label: string
  render?: (item: T) => React.ReactNode
  filterable?: boolean
  sortable?: boolean
}

interface DataTableProps<T> {
  columns: Column<T>[]
  data: T[]
  onRowClick?: (item: T) => void
  searchable?: boolean
  pageSize?: number
  emptyMessage?: string
  loading?: boolean
}

function DataTableInner<T extends Record<string, any>>({
  columns, data, onRowClick, searchable, pageSize = 20, emptyMessage, loading
}: DataTableProps<T>) {
  const [search, setSearch] = useState('')
  const [filters, setFilters] = useState<Record<string, string>>({})
  const [page, setPage] = useState(0)
  const [sortKey, setSortKey] = useState<string | null>(null)
  const [sortDir, setSortDir] = useState<'asc' | 'desc'>('asc')

  const filterOptions = useMemo(() => {
    const opts: Record<string, string[]> = {}
    columns.filter(c => c.filterable).forEach(col => {
      const values = new Set(data.map(item => String(item[col.key] ?? '')).filter(Boolean))
      opts[col.key] = Array.from(values).sort()
    })
    return opts
  }, [columns, data])

  const filtered = useMemo(() => {
    let result = data
    if (search) {
      const q = search.toLowerCase()
      result = result.filter(item =>
        columns.some(col => {
          const val = col.render ? stripTags(col.render(item)) : String(item[col.key] ?? '')
          return val.toLowerCase().includes(q)
        })
      )
    }
    Object.entries(filters).forEach(([key, value]) => {
      if (value) {
        result = result.filter(item => String(item[key] ?? '') === value)
      }
    })
    if (sortKey) {
      result = [...result].sort((a, b) => {
        const av = String(a[sortKey] ?? '')
        const bv = String(b[sortKey] ?? '')
        return sortDir === 'asc' ? av.localeCompare(bv) : bv.localeCompare(av)
      })
    }
    return result
  }, [data, search, filters, columns, sortKey, sortDir])

  const totalPages = Math.ceil(filtered.length / pageSize)
  const paged = filtered.slice(page * pageSize, (page + 1) * pageSize)

  function stripTags(node: React.ReactNode): string {
    if (typeof node === 'string') return node
    if (typeof node === 'number') return String(node)
    return ''
  }

  function handleSort(key: string) {
    if (sortKey === key) {
      setSortDir(d => d === 'asc' ? 'desc' : 'asc')
    } else {
      setSortKey(key)
      setSortDir('asc')
    }
    setPage(0)
  }

  if (loading) {
    return (
      <div className="rounded-lg border">
        <Table>
          <TableHeader>
            <TableRow>
              {columns.map(col => (
                <TableHead key={col.key}>{col.label}</TableHead>
              ))}
            </TableRow>
          </TableHeader>
          <TableBody>
            {Array.from({ length: 5 }).map((_, i) => (
              <TableRow key={i}>
                {columns.map(col => (
                  <TableCell key={col.key}>
                    <div className="h-4 bg-slate-200 rounded animate-pulse w-3/4" />
                  </TableCell>
                ))}
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    )
  }

  return (
    <div>
      {(searchable || Object.keys(filterOptions).length > 0) && (
        <div className="flex flex-wrap items-center gap-2 mb-3">
          {searchable && (
            <div className="relative flex-1 max-w-xs">
              <Search className="absolute left-2.5 top-2.5 w-4 h-4 text-slate-400" />
              <Input
                placeholder="Search..."
                value={search}
                onChange={e => { setSearch(e.target.value); setPage(0) }}
                className="pl-8 h-9 text-sm"
              />
            </div>
          )}
          {Object.entries(filterOptions).map(([key, options]) => (
            <select
              key={key}
              value={filters[key] || ''}
              onChange={e => { setFilters({ ...filters, [key]: e.target.value }); setPage(0) }}
              className="p-1.5 border rounded text-sm bg-white"
            >
              <option value="">All {key}</option>
              {options.map(opt => (
                <option key={opt} value={opt}>{opt}</option>
              ))}
            </select>
          ))}
        </div>
      )}

      <div className="rounded-lg border overflow-x-auto">
        <Table>
          <TableHeader>
            <TableRow>
              {columns.map((col) => (
                <TableHead key={col.key}
                  className={col.sortable ? 'cursor-pointer select-none' : ''}
                  onClick={() => col.sortable && handleSort(col.key)}
                >
                  <div className="flex items-center gap-1">
                    {col.label}
                    {col.sortable && (
                      sortKey === col.key
                        ? (sortDir === 'asc' ? <ArrowUp className="w-3 h-3" /> : <ArrowDown className="w-3 h-3" />)
                        : <ArrowUpDown className="w-3 h-3 text-slate-300" />
                    )}
                  </div>
                </TableHead>
              ))}
            </TableRow>
          </TableHeader>
          <TableBody>
            {paged.length === 0 ? (
              <TableRow>
                <TableCell colSpan={columns.length} className="text-center py-12">
                  <div className="flex flex-col items-center gap-2 text-muted-foreground">
                    <Inbox className="w-8 h-8" />
                    <p className="text-sm font-medium">{emptyMessage || 'No records found'}</p>
                  </div>
                </TableCell>
              </TableRow>
            ) : (
              paged.map((item, i) => (
                <TableRow key={item.id || i}
                  className={onRowClick ? 'cursor-pointer hover:bg-slate-50' : ''}
                  onClick={() => onRowClick?.(item)}>
                  {columns.map((col) => (
                    <TableCell key={col.key}>
                      {col.render ? col.render(item) : item[col.key]}
                    </TableCell>
                  ))}
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      {totalPages > 1 && (
        <div className="flex items-center justify-between mt-2 text-sm text-slate-500">
          <span>{filtered.length} records</span>
          <div className="flex items-center gap-2">
            <button
              onClick={() => setPage(Math.max(0, page - 1))}
              disabled={page === 0}
              className="p-1 rounded hover:bg-slate-100 disabled:opacity-30"
            >
              <ChevronLeft className="w-4 h-4" />
            </button>
            <span>Page {page + 1} of {totalPages}</span>
            <button
              onClick={() => setPage(Math.min(totalPages - 1, page + 1))}
              disabled={page >= totalPages - 1}
              className="p-1 rounded hover:bg-slate-100 disabled:opacity-30"
            >
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}
    </div>
  )
}

const DataTable = memo(DataTableInner) as typeof DataTableInner & { displayName?: string }
export default DataTable
