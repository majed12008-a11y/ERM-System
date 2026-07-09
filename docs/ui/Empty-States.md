# Empty States — NERMS

## Design Principles

1. **Every data display component must handle 3 states**: loading, empty, error
2. **Empty states provide**: clear message + actionable next step + relevant icon
3. **Error states provide**: what went wrong (user-friendly) + retry/back action
4. **Loading states use**: skeleton components matching content shape
5. **Illustrations**: Use Lucide icons (not custom illustrations)

---

## Empty State Component

```tsx
interface EmptyStateProps {
  icon: LucideIcon;
  title: string;
  description?: string;
  action?: {
    label: string;
    onClick: () => void;
  };
  variant?: 'empty' | 'error' | 'search';
}
```

### Variants

| Variant | Icon Color | Title Color | Use When |
|---------|------------|-------------|----------|
| `empty` | `text-slate-300` | `text-slate-600` | No data exists |
| `error` | `text-destructive` | `text-destructive` | Fetch failed |
| `search` | `text-slate-300` | `text-slate-600` | No search results |

---

## Page-Level Empty States

### Applications / الطلبات

| State | Icon | Title (Ar) | Title (En) | Action |
|-------|------|------------|------------|--------|
| Empty | `FileText` | لا توجد طلبات بعد | No applications yet | "تقديم طلب جديد" / "New Application" |
| Error | `AlertTriangle` | تعذر تحميل الطلبات | Failed to load applications | "إعادة المحاولة" / "Retry" |
| No Results | `SearchX` | لا توجد نتائج للبحث | No matching applications | "مسح البحث" / "Clear Search" |

### Projects / المشاريع

| State | Icon | Title (Ar) | Title (En) | Action |
|-------|------|------------|------------|--------|
| Empty | `FolderKanban` | لا توجد مشاريع بعد | No projects yet | — |
| Error | `AlertTriangle` | تعذر تحميل المشاريع | Failed to load projects | Retry |

### Committees / اللجان

| State | Icon | Title (Ar) | Title (En) | Action |
|-------|------|------------|------------|--------|
| Empty | `UsersRound` | لم يتم تعيين لجان بعد | No committees assigned | — |
| Error | `AlertTriangle` | تعذر تحميل اللجان | Failed to load committees | Retry |

### Documents / المستندات

| State | Icon | Title (Ar) | Title (En) | Action |
|-------|------|------------|------------|--------|
| Empty | `FolderOpen` | لا توجد مستندات | No documents uploaded | "رفع مستند" / "Upload" |
| Error | `AlertTriangle` | تعذر تحميل المستندات | Failed to load documents | Retry |
| No Results | `SearchX` | لا توجد مستندات مطابقة | No matching documents | Clear Search |

### Meetings / الاجتماعات

| State | Icon | Title (Ar) | Title (En) | Action |
|-------|------|------------|------------|--------|
| Empty | `CalendarDays` | لا توجد اجتماعات مجدولة | No meetings scheduled | — |
| Error | `AlertTriangle` | تعذر تحميل الاجتماعات | Failed to load meetings | Retry |

### Notifications / الإشعارات

| State | Icon | Title (Ar) | Title (En) | Action |
|-------|------|------------|------------|--------|
| Empty | `BellOff` | لا توجد إشعارات | No notifications | — |
| Error | `AlertTriangle` | تعذر تحميل الإشعارات | Failed to load notifications | Retry |

### Dashboard Sections

| Section | Icon | Title (Ar) | Title (En) |
|---------|------|------------|------------|
| Activity (empty) | `History` | لا توجد نشاطات حديثة | No recent activity |
| Pending Reviews (empty) | `CheckCircle2` | تمت المتابعة! | All caught up! |
| Pending Reviews (error) | `AlertTriangle` | تعذر تحميل المراجعات | Failed to load reviews |
| Charts (no data) | `BarChart3` | لا توجد بيانات كافية | Insufficient data for chart |

---

## Loading States (Skeleton)

### Table Skeleton

```tsx
<div className="space-y-3">
  <div className="h-8 bg-slate-200 rounded animate-pulse" />
  <div className="h-8 bg-slate-200 rounded animate-pulse w-5/6" />
  <div className="h-8 bg-slate-200 rounded animate-pulse w-4/6" />
  <div className="h-8 bg-slate-200 rounded animate-pulse w-3/6" />
  <div className="h-8 bg-slate-200 rounded animate-pulse w-5/6" />
</div>
```

### Card Skeleton

```tsx
<div className="rounded-xl border p-6 space-y-4">
  <div className="h-4 bg-slate-200 rounded w-1/3 animate-pulse" />
  <div className="h-8 bg-slate-200 rounded w-2/3 animate-pulse" />
  <div className="h-4 bg-slate-200 rounded w-1/2 animate-pulse" />
</div>
```

### KPI Card Skeleton

```tsx
<div className="rounded-xl bg-slate-100 p-6 space-y-4">
  <div className="h-12 w-12 bg-slate-200 rounded-full animate-pulse" />
  <div className="h-6 bg-slate-200 rounded w-1/2 animate-pulse" />
  <div className="h-4 bg-slate-200 rounded w-1/3 animate-pulse" />
</div>
```

---

## Implementation

- Create `@/components/composite/EmptyState.tsx`
- Use `<Skeleton>` from shadcn/ui for loading states
- Page components wrap content in `<ErrorBoundary>` (or use try/catch with state)
- Empty state receives `searchQuery?: string` for "no results" messaging
