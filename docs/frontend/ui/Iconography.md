# Iconography — NERMS

## Icon Library

| Library | Version | Status |
|---------|---------|--------|
| **Lucide React** | ^1.17.0 | ✅ Installed |

All system icons use Lucide React. No external icon packs. No custom SVG sprites (except the NERMS logo).

---

## Custom NERMS Icon

The system icon is the **NERMS Shield** logo (see `logo-icon.svg`). Used for:

- App favicon
- PWA icon
- Login page branding
- Sidebar header

---

## Module Icon Mapping

Each module in the sidebar and navigation has a designated Lucide icon:

| Module | Arabic | Lucide Icon | Import Name |
|--------|--------|-------------|-------------|
| **Dashboard** | لوحة القيادة | `LayoutDashboard` | `layout-dashboard` |
| **Applications** | الطلبات | `FileText` | `file-text` |
| **Projects** | المشاريع | `FolderKanban` | `folder-kanban` |
| **Committees** | اللجان | `UsersRound` | `users-round` |
| **Scientific Review** | المراجعة العلمية | `FlaskConical` | `flask-conical` |
| **Ethics Review** | المراجعة الأخلاقية | `Scale` | `scale` |
| **Risk Assessment** | تقييم المخاطر | `ShieldAlert` | `shield-alert` |
| **Consent** | الموافقة | `FileSignature` | `file-signature` |
| **Accreditation** | الاعتماد | `BadgeCheck` | `badge-check` |
| **Meetings** | الاجتماعات | `CalendarDays` | `calendar-days` |
| **My Reviews** | مراجعاتي | `ClipboardCheck` | `clipboard-check` |
| **Voting** | التصويت | `Vote` | `vote` |
| **Documents** | المستندات | `FolderOpen` | `folder-open` |
| **Reports** | التقارير | `BarChart3` | `bar-chart-3` |
| **Notifications** | الإشعارات | `Bell` | `bell` |
| **Settings** | الإعدادات | `Settings` | `settings` |
| **Audit** | التدقيق | `SearchCheck` | `search-check` |
| **Users** | المستخدمون | `Users` | `users` |
| **Roles** | الأدوار | `Shield` | `shield` |
| **Institutions** | المؤسسات | `Building2` | `building-2` |
| **Departments** | الأقسام | `Layers` | `layers` |
| **Templates** | القوالب | `Files` | `files` |
| **Safety** | السلامة | `HeartPulse` | `heart-pulse` |
| **Adverse Events** | الأحداث العكسية | `AlertTriangle` | `alert-triangle` |
| **Risk Incidents** | حوادث المخاطر | `Flame` | `flame` |
| **Corrective Actions** | الإجراءات التصحيحية | `CheckCircle2` | `check-circle-2` |
| **Messages** | الرسائل | `MessageSquare` | `message-square` |
| **Workflow** | سير العمل | `GitBranch` | `git-branch` |
| **Admin** | الإدارة | `Cog` | `cog` |
| **Profile** | الملف الشخصي | `UserCircle` | `user-circle` |
| **Logout** | تسجيل الخروج | `LogOut` | `log-out` |
| **Saved Searches** | عمليات البحث المحفوظة | `Search` | `search` |
| **Registry** | السجل الوطني | `BookOpen` | `book-open` |
| **Notification Channels** | قنوات الإشعارات | `BellRing` | `bell-ring` |
| **Backup** | النسخ الاحتياطي | `Database` | `database` |
| **Review Forms** | نماذج المراجعة | `ClipboardList` | `clipboard-list` |
| **E-Signatures** | التوقيعات الإلكترونية | `PenTool` | `pen-tool` |
| **Reference Data** | البيانات المرجعية | `BookMarked` | `book-marked` |
| **Accreditation Cycles** | دورات الاعتماد | `RefreshCw` | `refresh-cw` |

---

## Icon Usage Rules

| Rule | Details |
|------|---------|
| **Size** | Icons in navigation: `w-5 h-5` (20px). Icons in inputs/buttons: `w-4 h-4` (16px). |
| **Stroke width** | Default Lucide stroke (2px) — do not override. |
| **Color** | Inherit from parent text color unless specified otherwise. |
| **Position** | Icons before text in LTR, after text in RTL (mirrored). |
| **Decorative** | Decorative icons get `aria-hidden="true"`. |
| **Interactive** | Interactive icons (buttons) get accessible labels. |
| **No custom SVGs** | Only the NERMS logo and flag icon are custom SVGs. Everything else uses Lucide. |

---

## Icon Color by Context

| Context | Color | Example |
|---------|-------|---------|
| Navigation (inactive) | `text-slate-400` | Sidebar nav items |
| Navigation (active) | `text-white` | Active sidebar item |
| Action buttons | `text-primary-foreground` | Primary buttons |
| Status icons | Semantic (success/warning/danger) | Badge indicators |
| KPI cards | `text-white` with colored background | Dashboard stat icons |
