# Dashboard UX — NERMS

## Layout Structure

```
┌──────────────────────────────────────────────┐
│ PageHeader: Dashboard / لوحة القيادة         │
│ Role context: "مرحباً، د. أحمد"              │
├──────────────────────────────────────────────┤
│                                              │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐│
│  │KPI 1 │ │KPI 2 │ │KPI 3 │ │KPI 4 │ │KPI 5 ││
│  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘│
│                                              │
│  ┌─────────────────────┐ ┌─────────────────┐ │
│  │ Chart: Applications │ │ Recent Activity │ │
│  │ (bar chart)         │ │ (list)          │ │
│  │                     │ │                 │ │
│  └─────────────────────┘ └─────────────────┘ │
│                                              │
│  ┌─────────────────────┐ ┌─────────────────┐ │
│  │ Quick Actions       │ │ Pending Reviews │ │
│  │ (grid of action cards│ │ (minimal table) │ │
│  └─────────────────────┘ └─────────────────┘ │
│                                              │
└──────────────────────────────────────────────┘
```

---

## KPI Cards

### Design

- **Background**: Solid brand gradient (`#0a2540 → #0f3b6a`) for emphasis
- **Icon**: White Lucide icon (w-10 h-10, opacity 20–30%)
- **Label**: White, `text-sm font-medium`
- **Value**: White, `text-3xl font-bold` (or `text-lg` for smaller metrics)
- **Trend**: Optional delta with arrow (up green / down red)
- **Layout**: 5 columns on xl, 3 on lg, 2 on md, 1 on sm
- **Min width**: 180px each

### KPI Cards Content

| Card | Icon | Metric | Color |
|------|------|--------|-------|
| Active Applications | `FileText` | Count | Navy 900 |
| In Review | `ClipboardCheck` | Count | Teal 600 |
| Pending My Review | `Scale` | Count | Amber 600 |
| Approved This Month | `BadgeCheck` | Count | Green 600 |
| Open Tasks | `Bell` | Count | Red 600 |

---

## Charts

### Library

- **Recharts** (already installed)
- **Usage**: Bar chart for application trends, Line chart for time-series, Pie chart for status distribution

### Chart: Applications Trend

- **Type**: Bar chart (monthly)
- **Colors**: Navy 900 bar, Teal 600 for current month
- **Dimensions**: Full width, ~300px height
- **Options**: Last 6 months, responsive, no animation

### Chart: Status Distribution

- **Type**: Pie chart (donut variant)
- **Colors**: Success (green), Warning (amber), Danger (red), Info (blue)
- **Dimensions**: ~250px width
- **Options**: Stroke white, inner radius 60%, outer radius 80%

---

## Recent Activity

- **Type**: Scrollable list (max 10 items)
- **Format**: `[Icon] [Action] — [Entity] — [Time ago]`
- **Empty state**: "No recent activity" with `History` icon
- **Loading state**: 3 skeleton rows

---

## Quick Actions

- **Type**: 2x2 grid of action cards
- **Content**:
  - "New Application" → FileText + arrow
  - "Pending Reviews" → ClipboardCheck + arrow
  - "Submit Report" → BarChart3 + arrow
  - "Schedule Meeting" → CalendarDays + arrow
- **Design**: White card, brand icon, hover:shadow-md, cursor pointer

---

## Pending Reviews

- **Type**: Minimal table (3 columns: applicant, type, date)
- **Rows**: Max 5, most recent first
- **Empty state**: "All caught up!" with `CheckCircle2` icon
- **Loading state**: 3 skeleton rows

---

## Responsive Behavior

| Breakpoint | Layout |
|------------|--------|
| < md (768px) | Single column, KPI cards stack vertically |
| md ↔ lg | 2-column grid for KPIs, single column content |
| lg ↔ xl | 3-column KPIs, 2-column content |
| ≥ xl | Full 5-column KPIs, 2-column content |

---

## Dashboard Variants by Role

| Role | Content Additions |
|------|-------------------|
| **Admin** | System health, user count, pending registrations |
| **Chair** | Committee overview, meeting schedule |
| **Reviewer** | My reviews count, pending reviews, deadlines |
| **Applicant** | My applications, submission status |
| **Institution Admin** | Institution users, department stats |

---

## States

| State | Implementation |
|-------|----------------|
| **Loading** | Skeleton components: KPI card skeleton (gray bg pulse), chart skeleton, list skeleton |
| **Error** | Alert banner: "Failed to load dashboard data" with retry button |
| **Empty** | Not applicable (dashboard always shows metrics, even if 0) |
| **Partial data** | Show what's available, hide broken sections |
