# Components Review — NERMS

## Component Audit Status

All shadcn/ui components audited and categorized by review requirement.

### ✅ Clean (no changes needed)

| Component | File | Notes |
|-----------|------|-------|
| `Button` | `@/components/ui/button` | Variants map to brand colors via CSS vars |
| `Badge` | `@/components/ui/badge` | Uses CSS vars, status variants work |
| `Input` | `@/components/ui/input` | Works as-is |
| `Select` | `@/components/ui/select` | Works as-is |
| `Textarea` | `@/components/ui/textarea` | Works as-is |
| `Checkbox` | `@/components/ui/checkbox` | Works as-is |
| `RadioGroup` | `@/components/ui/radio-group` | Works as-is |
| `Switch` | `@/components/ui/switch` | Works as-is |
| `Label` | `@/components/ui/label` | Works as-is |
| `Separator` | `@/components/ui/separator` | Works as-is |
| `ScrollArea` | `@/components/ui/scroll-area` | Works as-is |
| `Tooltip` | `@/components/ui/tooltip` | Works as-is |
| `DropdownMenu` | `@/components/ui/dropdown-menu` | Works as-is |
| `AspectRatio` | `@/components/ui/aspect-ratio` | Works as-is |
| `Collapsible` | `@/components/ui/collapsible` | Works as-is |
| `Tabs` | `@/components/ui/tabs` | Works as-is |
| `Skeleton` | `@/components/ui/skeleton` | Works as-is |
| `Alert` | `@/components/ui/alert` | Works as-is |
| `Avatar` | `@/components/ui/avatar` | Works as-is |
| `Card` | `@/components/ui/card` | Works as-is |
| `Table` | `@/components/ui/table` | Works as-is |

### 🔄 Needs Updates

| Component | File | Changes Required |
|-----------|------|------------------|
| `Dialog` | `@/components/ui/dialog` | Verify brand overlay/ring color |
| `AlertDialog` | `@/components/ui/alert-dialog` | Same as Dialog |
| `Sheet` | `@/components/ui/sheet` | Verify brand accent line |
| `Pagination` | `@/components/ui/pagination` | May need active color |
| `DataTable` | `@/components/ui/data-table` | Custom wrapper — verify brand tokens |
| `HoverCard` | `@/components/ui/hover-card` | Verify brand shadow |

### ❌ Missing (needs creation)

| Component | Priority | Use Case |
|-----------|----------|----------|
| **StatusBadge** | High | Colored status indicator (success/warning/danger/info) |
| **KpiCard** | High | Dashboard metric card with icon |
| **EmptyState** | Medium | Per-page empty/error/loading states |
| **SidebarNav** | High | Navigation component (current inline in RootLayout) |
| **PageHeader** | Medium | Consistent page title + breadcrumb + actions |
| **ConfirmDialog** | Medium | Generic confirm/cancel dialog wrapper |
| **NotificationToast** | Medium | In-app notification display |
| **SearchInput** | Low | Debounced search with icon |
| **FilterBar** | Low | Generic filter controls for tables |
| **ActionMenu** | Low | Row-level actions (edit/delete/view) |

---

## Unified Theming Approach

Current `index.css`:

```css
@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}
```

Target: All shadcn CSS variables in `@layer base` using brand palette (see Color-System.md). No hardcoded colors in components.

### CSS Variable Audit

| Variable | Current Value | New Value | Status |
|----------|---------------|-----------|--------|
| `--background` | `0 0% 100%` | `0 0% 100%` | ✅ Keep |
| `--foreground` | `222.2 84% 4.9%` | `220 39% 11%` (gray-900) | 🔄 Update |
| `--card` | `0 0% 100%` | `0 0% 100%` | ✅ Keep |
| `--card-foreground` | `222.2 84% 4.9%` | `220 39% 11%` | 🔄 Update |
| `--popover` | `0 0% 100%` | `0 0% 100%` | ✅ Keep |
| `--popover-foreground` | `222.2 84% 4.9%` | `220 39% 11%` | 🔄 Update |
| `--primary` | `222.2 47.4% 11.2%` | `210 73% 15%` (navy-900) | 🔄 Update |
| `--primary-foreground` | `210 40% 98%` | `0 0% 100%` | ✅ Keep |
| `--secondary` | `210 40% 96.1%` | `140 68% 32%` (med green) | 🔄 Update |
| `--secondary-foreground` | `222.2 47.4% 11.2%` | `0 0% 100%` | 🔄 Update |
| `--muted` | `210 40% 96.1%` | `220 16% 95%` (gray-100) | 🔄 Update |
| `--muted-foreground` | `215.4 16.3% 46.9%` | `220 9% 46%` (gray-500) | 🔄 Update |
| `--accent` | `210 40% 96.1%` | `175 84% 32%` (teal-600) | 🔄 Update |
| `--accent-foreground` | `222.2 47.4% 11.2%` | `0 0% 100%` | 🔄 Update |
| `--destructive` | `0 100% 50%` | `0 72% 51%` (danger) | 🔄 Update |
| `--destructive-foreground` | `210 40% 98%` | `0 0% 100%` | ✅ Keep |
| `--border` | `214.3 31.8% 91.4%` | `220 18% 90%` (gray-200) | 🔄 Update |
| `--input` | `214.3 31.8% 91.4%` | `220 18% 90%` (gray-200) | 🔄 Update |
| `--ring` | `222.2 84% 4.9%` | `210 73% 15%` (navy-900) | 🔄 Update |
| `--radius` | `0.5rem` | `0.625rem` | 🔄 Update |

---

## Component Naming Convention

```
@/components/ui/<name>         → shadcn/ui primitive (Button, Input, Dialog)
@/components/layout/<name>     → Layout components (Sidebar, Header, PageShell)
@/components/composite/<name>  → Domain-agnostic composites (StatusBadge, KpiCard)
@/features/<module>/<name>     → Domain-specific (ApplicationsTable, CommitteeForm)
```
