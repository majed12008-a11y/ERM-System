# Template Repository Implementations Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create all 11 template repository files in `backend/src/repositories/` implementing the data access layer for the template engine schema.

**Architecture:** Each repository extends `AuditableRepository` and uses `this.query()` for DB access. All queries target the `templates` schema. The critical `TemplateVersionRepository` implements 4 interfaces from 4 different services. No business logic in repositories — pure CRUD + specialized queries.

**Tech Stack:** TypeScript, PostgreSQL (pg Pool/PoolClient), existing `AuditableRepository` base class.

## Global Constraints

- Node.js 22+, PostgreSQL 18+, CommonJS modules
- All repositories extend `AuditableRepository` from `./auditable.repository`
- Use `this.query()` for all DB access (never import `query` directly)
- Use `this.createMeta()`, `this.updateMeta()`, `this.deleteMeta()` for audit fields
- Use `PaginationParams` and `paginatedResult` from `../shared/pagination`
- Use `PoolClient` from 'pg' for client parameter in transactional methods
- Template schema tables use `bigint` for IDs (use `number` in TypeScript)
- All soft-delete tables have `deleted_at` and `deleted_by` columns
- `template_version_audit` has `created_at` (not `timestamp`)
- `template_versions` has no `updated_at`/`updated_by` columns
- `content` columns are JSONB — pass as-is to PostgreSQL
- Follow exact patterns from `document.repository.ts`
- No business logic in repositories

## File Structure

| File | Purpose |
|------|---------|
| `backend/src/repositories/template.repository.ts` | CRUD for `templates.templates` |
| `backend/src/repositories/template-version.repository.ts` | CRUD + lifecycle queries for `templates.template_versions` (implements 4 interfaces) |
| `backend/src/repositories/template-category.repository.ts` | CRUD for `templates.categories` |
| `backend/src/repositories/template-variable.repository.ts` | CRUD for `templates.template_variables` |
| `backend/src/repositories/template-partial.repository.ts` | CRUD for `templates.template_partials` |
| `backend/src/repositories/template-audit.repository.ts` | Audit log for `templates.template_version_audit` (implements `IAuditRepository`) |
| `backend/src/repositories/template-output.repository.ts` | Generated outputs for `templates.template_outputs` |
| `backend/src/repositories/template-render-history.repository.ts` | Render history for `templates.template_render_history` |
| `backend/src/repositories/template-usage-stats.repository.ts` | Usage stats for `templates.template_usage_statistics` |
| `backend/src/repositories/template-event-mapping.repository.ts` | Event-template mappings for `templates.event_template_mapping` |
| `backend/src/repositories/template-localization.repository.ts` | Localizations for `templates.template_localizations` |

---

### Task 1: Template Category Repository

**Files:**
- Create: `backend/src/repositories/template-category.repository.ts`

**Interfaces:**
- Produces: `TemplateCategoryRepository` class with `findAll`, `findById`, `findByCode`, `create`, `update`, `softDelete`

- [ ] **Step 1: Create the repository file**

```typescript
import { AuditableRepository } from './auditable.repository';

export class TemplateCategoryRepository extends AuditableRepository {
  async findAll(): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.categories WHERE deleted_at IS NULL ORDER BY sort_order, name_ar`
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM templates.categories WHERE id = $1 AND deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findByCode(code: string): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM templates.categories WHERE code = $1 AND deleted_at IS NULL`,
      [code]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    code: string; name_ar: string; name_en: string;
    description?: string; parent_category_id?: number;
    required_variables?: any; default_output_format?: string;
    approval_required?: boolean; sort_order?: number;
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO templates.categories
        (code, name_ar, name_en, description, parent_category_id,
         required_variables, default_output_format, approval_required,
         sort_order, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
       RETURNING *`,
      [
        data.code, data.name_ar, data.name_en,
        data.description || null, data.parent_category_id || null,
        JSON.stringify(data.required_variables || []),
        data.default_output_format || 'PDF',
        data.approval_required !== false,
        data.sort_order || 0,
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<{
    name_ar: string; name_en: string; description: string;
    parent_category_id: number; required_variables: any;
    default_output_format: string; approval_required: boolean;
    sort_order: number; is_active: boolean;
  }>): Promise<any | null> {
    const meta = this.updateMeta();
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.name_ar !== undefined) { sets.push(`name_ar = $${idx++}`); values.push(data.name_ar); }
    if (data.name_en !== undefined) { sets.push(`name_en = $${idx++}`); values.push(data.name_en); }
    if (data.description !== undefined) { sets.push(`description = $${idx++}`); values.push(data.description); }
    if (data.parent_category_id !== undefined) { sets.push(`parent_category_id = $${idx++}`); values.push(data.parent_category_id); }
    if (data.required_variables !== undefined) { sets.push(`required_variables = $${idx++}`); values.push(JSON.stringify(data.required_variables)); }
    if (data.default_output_format !== undefined) { sets.push(`default_output_format = $${idx++}`); values.push(data.default_output_format); }
    if (data.approval_required !== undefined) { sets.push(`approval_required = $${idx++}`); values.push(data.approval_required); }
    if (data.sort_order !== undefined) { sets.push(`sort_order = $${idx++}`); values.push(data.sort_order); }
    if (data.is_active !== undefined) { sets.push(`is_active = $${idx++}`); values.push(data.is_active); }

    if (sets.length === 0) return this.findById(id);

    sets.push(`updated_by = $${idx++}`);
    values.push(meta.updated_by);
    sets.push(`updated_at = $${idx++}`);
    values.push(meta.updated_at);
    values.push(id);

    const result = await this.query(
      `UPDATE templates.categories SET ${sets.join(', ')} WHERE id = $${idx} AND deleted_at IS NULL RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE templates.categories SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL RETURNING id`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return result.rows.length > 0;
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add backend/src/repositories/template-category.repository.ts
git commit -m "feat: add template category repository"
```

---

### Task 2: Template Repository

**Files:**
- Create: `backend/src/repositories/template.repository.ts`

**Interfaces:**
- Produces: `TemplateRepository` class with `findAll`, `findById`, `findByCode`, `create`, `update`, `softDelete`, `incrementUsageCount`, `getStats`

- [ ] **Step 1: Create the repository file**

```typescript
import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';

export class TemplateRepository extends AuditableRepository {
  async findAll(params: PaginationParams, search?: string): Promise<{ rows: any[]; total: number }> {
    let whereClause = 'WHERE t.deleted_at IS NULL';
    const values: any[] = [];
    let idx = 1;

    if (search) {
      whereClause += ` AND (t.code ILIKE $${idx} OR t.name_ar ILIKE $${idx} OR t.name_en ILIKE $${idx})`;
      values.push(`%${search}%`);
      idx++;
    }

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.templates t ${whereClause}`,
      values
    );
    const total = parseInt(countResult.rows[0].count);

    values.push(params.limit);
    values.push((params.page - 1) * params.limit);

    const result = await this.query(
      `SELECT t.*, c.name_ar as category_name_ar, c.name_en as category_name_en
       FROM templates.templates t
       LEFT JOIN templates.categories c ON t.category_id = c.id
       ${whereClause}
       ORDER BY t.created_at DESC
       LIMIT $${idx++} OFFSET $${idx++}`,
      values
    );
    return { rows: result.rows, total };
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT t.*, c.name_ar as category_name_ar, c.name_en as category_name_en
       FROM templates.templates t
       LEFT JOIN templates.categories c ON t.category_id = c.id
       WHERE t.id = $1 AND t.deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findByCode(code: string): Promise<any | null> {
    const result = await this.query(
      `SELECT t.*, c.name_ar as category_name_ar, c.name_en as category_name_en
       FROM templates.templates t
       LEFT JOIN templates.categories c ON t.category_id = c.id
       WHERE t.code = $1 AND t.deleted_at IS NULL`,
      [code]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    category_id: number; code: string; name_ar: string; name_en: string;
    description?: string; engine?: string; default_locale?: string;
    tags?: string[]; variable_sources?: any;
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO templates.templates
        (category_id, code, name_ar, name_en, description, engine,
         default_locale, tags, variable_sources, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
       RETURNING *`,
      [
        data.category_id, data.code, data.name_ar, data.name_en,
        data.description || null, data.engine || 'handlebars',
        data.default_locale || 'ar',
        data.tags || [], JSON.stringify(data.variable_sources || []),
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<{
    name_ar: string; name_en: string; description: string;
    tags: string[]; variable_sources: any; is_active: boolean;
  }>): Promise<any | null> {
    const meta = this.updateMeta();
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.name_ar !== undefined) { sets.push(`name_ar = $${idx++}`); values.push(data.name_ar); }
    if (data.name_en !== undefined) { sets.push(`name_en = $${idx++}`); values.push(data.name_en); }
    if (data.description !== undefined) { sets.push(`description = $${idx++}`); values.push(data.description); }
    if (data.tags !== undefined) { sets.push(`tags = $${idx++}`); values.push(data.tags); }
    if (data.variable_sources !== undefined) { sets.push(`variable_sources = $${idx++}`); values.push(JSON.stringify(data.variable_sources)); }
    if (data.is_active !== undefined) { sets.push(`is_active = $${idx++}`); values.push(data.is_active); }

    if (sets.length === 0) return this.findById(id);

    sets.push(`updated_by = $${idx++}`);
    values.push(meta.updated_by);
    sets.push(`updated_at = $${idx++}`);
    values.push(meta.updated_at);
    values.push(id);

    const result = await this.query(
      `UPDATE templates.templates SET ${sets.join(', ')} WHERE id = $${idx} AND deleted_at IS NULL RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE templates.templates SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL RETURNING id`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return result.rows.length > 0;
  }

  async incrementUsageCount(id: number): Promise<void> {
    await this.query(
      `UPDATE templates.templates SET usage_count = usage_count + 1 WHERE id = $1`,
      [id]
    );
  }

  async getStats(): Promise<{ by_category: any[]; total: number }> {
    const totalResult = await this.query(
      `SELECT COUNT(*) FROM templates.templates WHERE deleted_at IS NULL`
    );
    const total = parseInt(totalResult.rows[0].count);

    const byCategoryResult = await this.query(
      `SELECT c.id, c.name_ar, c.name_en, COUNT(t.id) as template_count
       FROM templates.categories c
       LEFT JOIN templates.templates t ON t.category_id = c.id AND t.deleted_at IS NULL
       WHERE c.deleted_at IS NULL
       GROUP BY c.id, c.name_ar, c.name_en
       ORDER BY c.sort_order, c.name_ar`
    );
    return { by_category: byCategoryResult.rows, total };
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add backend/src/repositories/template.repository.ts
git commit -m "feat: add template repository"
```

---

### Task 3: Template Version Repository (CRITICAL — 4 interfaces)

**Files:**
- Create: `backend/src/repositories/template-version.repository.ts`

**Interfaces:** This class implements ALL FOUR:
- `IEngineVersionRepository` from `../../services/template-engine.service`
- `IVersionRepository` from `../../services/template-version-lifecycle.service`
- `ITimelineVersionRepository` from `../../services/template-timeline.service`
- `IRollbackVersionRepository` from `../../services/template-rollback.service`

**Produces:** `TemplateVersionRepository` with methods: `findByCodeAndVersion`, `findById`, `findByTemplateCode`, `updateStatus`, `findApproved`, `deprecateCurrentApproved`, `updateEffectiveDates`, `create`, `findLatestByTemplateId`

- [ ] **Step 1: Create the repository file**

```typescript
import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';
import type { IEngineVersionRepository } from '../services/template-engine.service';
import type { IVersionRepository, VersionData } from '../services/template-version-lifecycle.service';
import type { ITimelineVersionRepository } from '../services/template-timeline.service';
import type { IRollbackVersionRepository } from '../services/template-rollback.service';

export class TemplateVersionRepository extends AuditableRepository
  implements IEngineVersionRepository, IVersionRepository, ITimelineVersionRepository, IRollbackVersionRepository {

  async findByCodeAndVersion(code: string, version: string): Promise<VersionData | null> {
    const result = await this.query(
      `SELECT tv.*
       FROM templates.template_versions tv
       JOIN templates.templates t ON t.id = tv.template_id
       WHERE t.code = $1 AND tv.version = $2 AND t.deleted_at IS NULL`,
      [code, version]
    );
    return result.rows[0] || null;
  }

  async findById(id: number): Promise<VersionData | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_versions WHERE id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findByTemplateCode(code: string): Promise<VersionData[]> {
    const result = await this.query(
      `SELECT tv.*
       FROM templates.template_versions tv
       JOIN templates.templates t ON t.id = tv.template_id
       WHERE t.code = $1 AND t.deleted_at IS NULL
       ORDER BY tv.version DESC`,
      [code]
    );
    return result.rows;
  }

  async updateStatus(id: number, newStatus: string, userId: number, client?: PoolClient): Promise<VersionData> {
    if (newStatus === 'APPROVED') {
      const result = await this.query(
        `UPDATE templates.template_versions
         SET status = $1, approved_by = $2, approved_at = NOW()
         WHERE id = $3
         RETURNING *`,
        [newStatus, userId, id],
        client
      );
      return result.rows[0];
    }
    const result = await this.query(
      `UPDATE templates.template_versions
       SET status = $1
       WHERE id = $2
       RETURNING *`,
      [newStatus, id],
      client
    );
    return result.rows[0];
  }

  async findApproved(templateId: number, now: Date): Promise<VersionData | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_versions
       WHERE template_id = $1
         AND status = 'APPROVED'
         AND (effective_from IS NULL OR effective_from <= $2)
         AND (effective_until IS NULL OR effective_until > $2)
       LIMIT 1`,
      [templateId, now]
    );
    return result.rows[0] || null;
  }

  async deprecateCurrentApproved(templateId: number, now: Date, client?: PoolClient): Promise<VersionData | null> {
    const result = await this.query(
      `UPDATE templates.template_versions
       SET status = 'DEPRECATED', retired_at = $2
       WHERE template_id = $1 AND status = 'APPROVED'
       RETURNING *`,
      [templateId, now, client ? undefined : undefined].slice(0, 2),
      client
    );
    return result.rows[0] || null;
  }

  async updateEffectiveDates(
    id: number,
    effectiveFrom: Date | null,
    effectiveUntil: Date | null,
    client?: PoolClient,
  ): Promise<VersionData> {
    const result = await this.query(
      `UPDATE templates.template_versions
       SET effective_from = $1, effective_until = $2
       WHERE id = $3
       RETURNING *`,
      [effectiveFrom, effectiveUntil, id],
      client
    );
    return result.rows[0];
  }

  async create(data: {
    template_id: number; version: string; content: any;
    content_hash: string; variable_definitions?: any;
    change_summary?: string; created_by: number;
  }): Promise<VersionData> {
    const result = await this.query(
      `INSERT INTO templates.template_versions
        (template_id, version, content, content_hash, variable_definitions,
         change_summary, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
       RETURNING *`,
      [
        data.template_id, data.version, JSON.stringify(data.content),
        data.content_hash, JSON.stringify(data.variable_definitions || []),
        data.change_summary || null, data.created_by,
      ]
    );
    return result.rows[0];
  }

  async findLatestByTemplateId(templateId: number): Promise<VersionData | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_versions
       WHERE template_id = $1
       ORDER BY created_at DESC
       LIMIT 1`,
      [templateId]
    );
    return result.rows[0] || null;
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add backend/src/repositories/template-version.repository.ts
git commit -m "feat: add template version repository (implements 4 interfaces)"
```

---

### Task 4: Template Variable Repository

**Files:**
- Create: `backend/src/repositories/template-variable.repository.ts`

**Interfaces:**
- Produces: `TemplateVariableRepository` with `findAll`, `findById`, `findByCode`, `create`, `update`, `softDelete`, `findByTemplateVersionId`

- [ ] **Step 1: Create the repository file**

```typescript
import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';

export class TemplateVariableRepository extends AuditableRepository {
  async findAll(params: PaginationParams, search?: string): Promise<{ rows: any[]; total: number }> {
    let whereClause = 'WHERE deleted_at IS NULL';
    const values: any[] = [];
    let idx = 1;

    if (search) {
      whereClause += ` AND (code ILIKE $${idx} OR name_ar ILIKE $${idx} OR name_en ILIKE $${idx})`;
      values.push(`%${search}%`);
      idx++;
    }

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_variables ${whereClause}`,
      values
    );
    const total = parseInt(countResult.rows[0].count);

    values.push(params.limit);
    values.push((params.page - 1) * params.limit);

    const result = await this.query(
      `SELECT * FROM templates.template_variables ${whereClause} ORDER BY code LIMIT $${idx++} OFFSET $${idx++}`,
      values
    );
    return { rows: result.rows, total };
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_variables WHERE id = $1 AND deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findByCode(code: string): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_variables WHERE code = $1 AND deleted_at IS NULL`,
      [code]
    );
    return result.rows[0] || null;
  }

  async findByTemplateVersionId(templateVersionId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.template_variables
       WHERE deleted_at IS NULL
       AND code IN (
         SELECT jsonb_array_elements_text(
           CASE WHEN jsonb_typeof(variable_definitions) = 'array'
             THEN variable_definitions
             ELSE '[]'::jsonb
           END
         )::jsonb->>'code'
         FROM templates.template_versions
         WHERE id = $1
       )
       ORDER BY code`,
      [templateVersionId]
    );
    return result.rows;
  }

  async create(data: {
    code: string; name_ar: string; name_en: string; type: string;
    source_type: string; enum_values?: any; resolver_path?: string;
    resolver_function?: string; resolver_function_args?: any;
    entity_whitelist_root?: string; default_value?: any;
    description_ar?: string; description_en?: string;
    required?: boolean; validation_rules?: any;
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO templates.template_variables
        (code, name_ar, name_en, type, source_type, enum_values,
         resolver_path, resolver_function, resolver_function_args,
         entity_whitelist_root, default_value, description_ar,
         description_en, required, validation_rules, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
       RETURNING *`,
      [
        data.code, data.name_ar, data.name_en, data.type, data.source_type,
        data.enum_values ? JSON.stringify(data.enum_values) : null,
        data.resolver_path || null, data.resolver_function || null,
        data.resolver_function_args ? JSON.stringify(data.resolver_function_args) : null,
        data.entity_whitelist_root || null,
        data.default_value !== undefined ? JSON.stringify(data.default_value) : null,
        data.description_ar || null, data.description_en || null,
        data.required || false,
        data.validation_rules ? JSON.stringify(data.validation_rules) : null,
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<{
    name_ar: string; name_en: string; type: string; source_type: string;
    enum_values: any; resolver_path: string; resolver_function: string;
    resolver_function_args: any; entity_whitelist_root: string;
    default_value: any; description_ar: string; description_en: string;
    required: boolean; validation_rules: any; is_active: boolean;
  }>): Promise<any | null> {
    const meta = this.updateMeta();
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.name_ar !== undefined) { sets.push(`name_ar = $${idx++}`); values.push(data.name_ar); }
    if (data.name_en !== undefined) { sets.push(`name_en = $${idx++}`); values.push(data.name_en); }
    if (data.type !== undefined) { sets.push(`type = $${idx++}`); values.push(data.type); }
    if (data.source_type !== undefined) { sets.push(`source_type = $${idx++}`); values.push(data.source_type); }
    if (data.enum_values !== undefined) { sets.push(`enum_values = $${idx++}`); values.push(JSON.stringify(data.enum_values)); }
    if (data.resolver_path !== undefined) { sets.push(`resolver_path = $${idx++}`); values.push(data.resolver_path); }
    if (data.resolver_function !== undefined) { sets.push(`resolver_function = $${idx++}`); values.push(data.resolver_function); }
    if (data.resolver_function_args !== undefined) { sets.push(`resolver_function_args = $${idx++}`); values.push(JSON.stringify(data.resolver_function_args)); }
    if (data.entity_whitelist_root !== undefined) { sets.push(`entity_whitelist_root = $${idx++}`); values.push(data.entity_whitelist_root); }
    if (data.default_value !== undefined) { sets.push(`default_value = $${idx++}`); values.push(JSON.stringify(data.default_value)); }
    if (data.description_ar !== undefined) { sets.push(`description_ar = $${idx++}`); values.push(data.description_ar); }
    if (data.description_en !== undefined) { sets.push(`description_en = $${idx++}`); values.push(data.description_en); }
    if (data.required !== undefined) { sets.push(`required = $${idx++}`); values.push(data.required); }
    if (data.validation_rules !== undefined) { sets.push(`validation_rules = $${idx++}`); values.push(JSON.stringify(data.validation_rules)); }
    if (data.is_active !== undefined) { sets.push(`is_active = $${idx++}`); values.push(data.is_active); }

    if (sets.length === 0) return this.findById(id);

    sets.push(`updated_by = $${idx++}`);
    values.push(meta.updated_by);
    sets.push(`updated_at = $${idx++}`);
    values.push(meta.updated_at);
    values.push(id);

    const result = await this.query(
      `UPDATE templates.template_variables SET ${sets.join(', ')} WHERE id = $${idx} AND deleted_at IS NULL RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE templates.template_variables SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL RETURNING id`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return result.rows.length > 0;
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add backend/src/repositories/template-variable.repository.ts
git commit -m "feat: add template variable repository"
```

---

### Task 5: Template Partial Repository

**Files:**
- Create: `backend/src/repositories/template-partial.repository.ts`

**Interfaces:**
- Produces: `TemplatePartialRepository` with `findAll`, `findById`, `findByCode`, `create`, `update`, `softDelete`

- [ ] **Step 1: Create the repository file**

```typescript
import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';

export class TemplatePartialRepository extends AuditableRepository {
  async findAll(params: PaginationParams, search?: string): Promise<{ rows: any[]; total: number }> {
    let whereClause = 'WHERE p.deleted_at IS NULL';
    const values: any[] = [];
    let idx = 1;

    if (search) {
      whereClause += ` AND (p.code ILIKE $${idx} OR p.name_ar ILIKE $${idx} OR p.name_en ILIKE $${idx})`;
      values.push(`%${search}%`);
      idx++;
    }

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_partials p ${whereClause}`,
      values
    );
    const total = parseInt(countResult.rows[0].count);

    values.push(params.limit);
    values.push((params.page - 1) * params.limit);

    const result = await this.query(
      `SELECT p.*, t.code as template_code
       FROM templates.template_partials p
       LEFT JOIN templates.templates t ON p.template_id = t.id
       ${whereClause}
       ORDER BY p.code
       LIMIT $${idx++} OFFSET $${idx++}`,
      values
    );
    return { rows: result.rows, total };
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT p.*, t.code as template_code
       FROM templates.template_partials p
       LEFT JOIN templates.templates t ON p.template_id = t.id
       WHERE p.id = $1 AND p.deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findByCode(code: string): Promise<any | null> {
    const result = await this.query(
      `SELECT p.*, t.code as template_code
       FROM templates.template_partials p
       LEFT JOIN templates.templates t ON p.template_id = t.id
       WHERE p.code = $1 AND p.deleted_at IS NULL`,
      [code]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    template_id?: number; code: string; name_ar: string; name_en: string;
    engine?: string; content: string; content_hash: string;
    version?: string; depends_on?: string[];
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO templates.template_partials
        (template_id, code, name_ar, name_en, engine, content,
         content_hash, version, depends_on, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
       RETURNING *`,
      [
        data.template_id || null, data.code, data.name_ar, data.name_en,
        data.engine || 'handlebars', data.content, data.content_hash,
        data.version || '1.0.0', data.depends_on || [],
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<{
    name_ar: string; name_en: string; engine: string;
    content: string; content_hash: string; version: string;
    depends_on: string[]; is_active: boolean;
  }>): Promise<any | null> {
    const meta = this.updateMeta();
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.name_ar !== undefined) { sets.push(`name_ar = $${idx++}`); values.push(data.name_ar); }
    if (data.name_en !== undefined) { sets.push(`name_en = $${idx++}`); values.push(data.name_en); }
    if (data.engine !== undefined) { sets.push(`engine = $${idx++}`); values.push(data.engine); }
    if (data.content !== undefined) { sets.push(`content = $${idx++}`); values.push(data.content); }
    if (data.content_hash !== undefined) { sets.push(`content_hash = $${idx++}`); values.push(data.content_hash); }
    if (data.version !== undefined) { sets.push(`version = $${idx++}`); values.push(data.version); }
    if (data.depends_on !== undefined) { sets.push(`depends_on = $${idx++}`); values.push(data.depends_on); }
    if (data.is_active !== undefined) { sets.push(`is_active = $${idx++}`); values.push(data.is_active); }

    if (sets.length === 0) return this.findById(id);

    sets.push(`updated_by = $${idx++}`);
    values.push(meta.updated_by);
    sets.push(`updated_at = $${idx++}`);
    values.push(meta.updated_at);
    values.push(id);

    const result = await this.query(
      `UPDATE templates.template_partials SET ${sets.join(', ')} WHERE id = $${idx} AND deleted_at IS NULL RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE templates.template_partials SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL RETURNING id`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return result.rows.length > 0;
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add backend/src/repositories/template-partial.repository.ts
git commit -m "feat: add template partial repository"
```

---

### Task 6: Template Audit Repository

**Files:**
- Create: `backend/src/repositories/template-audit.repository.ts`

**Interfaces:**
- Implements `IAuditRepository` from `template-version-lifecycle.service`
- Produces: `TemplateAuditRepository` with `log`, `findByVersionId`, `findAll`

- [ ] **Step 1: Create the repository file**

```typescript
import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';
import type { IAuditRepository } from '../services/template-version-lifecycle.service';

export class TemplateAuditRepository extends AuditableRepository implements IAuditRepository {
  async log(entry: {
    template_version_id: number;
    action: string;
    actor_id: number;
    previous_status: string | null;
    new_status: string | null;
    comment?: string;
  }, client?: PoolClient): Promise<any> {
    const result = await this.query(
      `INSERT INTO templates.template_version_audit
        (template_version_id, action, actor_id, previous_status, new_status, comment, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, NOW())
       RETURNING *`,
      [
        entry.template_version_id, entry.action, entry.actor_id,
        entry.previous_status, entry.new_status,
        entry.comment || null,
      ],
      client
    );
    return result.rows[0];
  }

  async findByVersionId(versionId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.template_version_audit
       WHERE template_version_id = $1
       ORDER BY created_at ASC`,
      [versionId]
    );
    return result.rows;
  }

  async findAll(params: PaginationParams, filters?: {
    action?: string;
    template_version_id?: number;
  }): Promise<{ rows: any[]; total: number }> {
    let whereClause = 'WHERE 1=1';
    const values: any[] = [];
    let idx = 1;

    if (filters?.action) {
      whereClause += ` AND action = $${idx++}`;
      values.push(filters.action);
    }
    if (filters?.template_version_id) {
      whereClause += ` AND template_version_id = $${idx++}`;
      values.push(filters.template_version_id);
    }

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_version_audit ${whereClause}`,
      values
    );
    const total = parseInt(countResult.rows[0].count);

    values.push(params.limit);
    values.push((params.page - 1) * params.limit);

    const result = await this.query(
      `SELECT * FROM templates.template_version_audit ${whereClause}
       ORDER BY created_at DESC
       LIMIT $${idx++} OFFSET $${idx++}`,
      values
    );
    return { rows: result.rows, total };
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add backend/src/repositories/template-audit.repository.ts
git commit -m "feat: add template audit repository (implements IAuditRepository)"
```

---

### Task 7: Template Output Repository

**Files:**
- Create: `backend/src/repositories/template-output.repository.ts`

**Interfaces:**
- Produces: `TemplateOutputRepository` with `create`, `findByEntity`, `findByVersionId`, `findById`, `getStats`

- [ ] **Step 1: Create the repository file**

```typescript
import { AuditableRepository } from './auditable.repository';

export class TemplateOutputRepository extends AuditableRepository {
  async create(data: {
    template_version_id: number; locale: string; output_format: string;
    entity_type: string; entity_id: number; storage_path: string;
    file_name: string; checksum_sha256: string; variables_hash: string;
    generated_by: number; file_size_bytes?: number;
    rendered_html_hash?: string; digital_signature_ref?: string;
    generation_duration_ms?: number; status?: string; error_message?: string;
  }): Promise<any> {
    const result = await this.query(
      `INSERT INTO templates.template_outputs
        (template_version_id, locale, output_format, entity_type, entity_id,
         storage_path, file_name, file_size_bytes, checksum_sha256,
         variables_hash, rendered_html_hash, digital_signature_ref,
         generated_by, generation_duration_ms, status, error_message)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
       RETURNING *`,
      [
        data.template_version_id, data.locale, data.output_format,
        data.entity_type, data.entity_id, data.storage_path,
        data.file_name, data.file_size_bytes || null,
        data.checksum_sha256, data.variables_hash,
        data.rendered_html_hash || null, data.digital_signature_ref || null,
        data.generated_by, data.generation_duration_ms || null,
        data.status || 'SUCCESS', data.error_message || null,
      ]
    );
    return result.rows[0];
  }

  async findByEntity(entityType: string, entityId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.template_outputs
       WHERE entity_type = $1 AND entity_id = $2
       ORDER BY generated_at DESC`,
      [entityType, entityId]
    );
    return result.rows;
  }

  async findByVersionId(templateVersionId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.template_outputs
       WHERE template_version_id = $1
       ORDER BY generated_at DESC`,
      [templateVersionId]
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_outputs WHERE id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async getStats(): Promise<{ by_status: any[]; total: number }> {
    const totalResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_outputs`
    );
    const total = parseInt(totalResult.rows[0].count);

    const byStatusResult = await this.query(
      `SELECT status, COUNT(*) as count
       FROM templates.template_outputs
       GROUP BY status
       ORDER BY status`
    );
    return { by_status: byStatusResult.rows, total };
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add backend/src/repositories/template-output.repository.ts
git commit -m "feat: add template output repository"
```

---

### Task 8: Template Render History Repository

**Files:**
- Create: `backend/src/repositories/template-render-history.repository.ts`

**Interfaces:**
- Produces: `TemplateRenderHistoryRepository` with `create`, `findByEntity`, `findByTemplateCode`, `findAll`

- [ ] **Step 1: Create the repository file**

```typescript
import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';

export class TemplateRenderHistoryRepository extends AuditableRepository {
  async create(data: {
    template_version_id: number; template_code: string; version: string;
    locale: string; output_format: string; entity_type: string;
    entity_id: number; generated_by: number; variables_hash: string;
    output_id: number; storage_path: string; checksum_sha256: string;
    rendered_html_hash?: string; duration_ms?: number; status: string;
  }): Promise<any> {
    const result = await this.query(
      `INSERT INTO templates.template_render_history
        (template_version_id, template_code, version, locale, output_format,
         entity_type, entity_id, generated_by, variables_hash, rendered_html_hash,
         output_id, storage_path, checksum_sha256, duration_ms, status)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
       RETURNING *`,
      [
        data.template_version_id, data.template_code, data.version,
        data.locale, data.output_format, data.entity_type,
        data.entity_id, data.generated_by, data.variables_hash,
        data.rendered_html_hash || null, data.output_id,
        data.storage_path, data.checksum_sha256,
        data.duration_ms || null, data.status,
      ]
    );
    return result.rows[0];
  }

  async findByEntity(entityType: string, entityId: number, params?: PaginationParams): Promise<{ rows: any[]; total: number }> {
    const limit = params?.limit || 20;
    const offset = params ? (params.page - 1) * params.limit : 0;

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_render_history
       WHERE entity_type = $1 AND entity_id = $2`,
      [entityType, entityId]
    );
    const total = parseInt(countResult.rows[0].count);

    const result = await this.query(
      `SELECT * FROM templates.template_render_history
       WHERE entity_type = $1 AND entity_id = $2
       ORDER BY generated_at DESC
       LIMIT $3 OFFSET $4`,
      [entityType, entityId, limit, offset]
    );
    return { rows: result.rows, total };
  }

  async findByTemplateCode(templateCode: string, params?: PaginationParams): Promise<{ rows: any[]; total: number }> {
    const limit = params?.limit || 20;
    const offset = params ? (params.page - 1) * params.limit : 0;

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_render_history
       WHERE template_code = $1`,
      [templateCode]
    );
    const total = parseInt(countResult.rows[0].count);

    const result = await this.query(
      `SELECT * FROM templates.template_render_history
       WHERE template_code = $1
       ORDER BY generated_at DESC
       LIMIT $2 OFFSET $3`,
      [templateCode, limit, offset]
    );
    return { rows: result.rows, total };
  }

  async findAll(params: PaginationParams, filters?: {
    status?: string; entity_type?: string;
    template_code?: string; generated_by?: number;
  }): Promise<{ rows: any[]; total: number }> {
    let whereClause = 'WHERE 1=1';
    const values: any[] = [];
    let idx = 1;

    if (filters?.status) {
      whereClause += ` AND status = $${idx++}`;
      values.push(filters.status);
    }
    if (filters?.entity_type) {
      whereClause += ` AND entity_type = $${idx++}`;
      values.push(filters.entity_type);
    }
    if (filters?.template_code) {
      whereClause += ` AND template_code = $${idx++}`;
      values.push(filters.template_code);
    }
    if (filters?.generated_by) {
      whereClause += ` AND generated_by = $${idx++}`;
      values.push(filters.generated_by);
    }

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_render_history ${whereClause}`,
      values
    );
    const total = parseInt(countResult.rows[0].count);

    values.push(params.limit);
    values.push((params.page - 1) * params.limit);

    const result = await this.query(
      `SELECT * FROM templates.template_render_history ${whereClause}
       ORDER BY generated_at DESC
       LIMIT $${idx++} OFFSET $${idx++}`,
      values
    );
    return { rows: result.rows, total };
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add backend/src/repositories/template-render-history.repository.ts
git commit -m "feat: add template render history repository"
```

---

### Task 9: Template Usage Stats Repository

**Files:**
- Create: `backend/src/repositories/template-usage-stats.repository.ts`

**Interfaces:**
- Produces: `TemplateUsageStatsRepository` with `upsert`, `findByTemplateId`, `getAggregateStats`

- [ ] **Step 1: Create the repository file**

```typescript
import { AuditableRepository } from './auditable.repository';

export class TemplateUsageStatsRepository extends AuditableRepository {
  async upsert(data: {
    template_id: number; date: string | Date;
    generation_count?: number; unique_users?: number;
    avg_duration_ms?: number; total_size_bytes?: number;
    by_format?: any; by_locale?: any;
  }): Promise<any> {
    const result = await this.query(
      `INSERT INTO templates.template_usage_statistics
        (template_id, date, generation_count, unique_users,
         avg_duration_ms, total_size_bytes, by_format, by_locale)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       ON CONFLICT (template_id, date) DO UPDATE SET
         generation_count = template_usage_statistics.generation_count + EXCLUDED.generation_count,
         unique_users = GREATEST(template_usage_statistics.unique_users, EXCLUDED.unique_users),
         avg_duration_ms = CASE
           WHEN EXCLUDED.avg_duration_ms IS NOT NULL THEN
             (COALESCE(template_usage_statistics.avg_duration_ms, 0) + EXCLUDED.avg_duration_ms) / 2
           ELSE template_usage_statistics.avg_duration_ms
         END,
         total_size_bytes = template_usage_statistics.total_size_bytes + EXCLUDED.total_size_bytes,
         by_format = template_usage_statistics.by_format || EXCLUDED.by_format,
         by_locale = template_usage_statistics.by_locale || EXCLUDED.by_locale
       RETURNING *`,
      [
        data.template_id, data.date,
        data.generation_count || 0, data.unique_users || 0,
        data.avg_duration_ms || null, data.total_size_bytes || 0,
        JSON.stringify(data.by_format || {}),
        JSON.stringify(data.by_locale || {}),
      ]
    );
    return result.rows[0];
  }

  async findByTemplateId(
    templateId: number,
    dateFrom?: string | Date,
    dateTo?: string | Date,
  ): Promise<any[]> {
    let whereClause = 'WHERE template_id = $1';
    const values: any[] = [templateId];
    let idx = 2;

    if (dateFrom) {
      whereClause += ` AND date >= $${idx++}`;
      values.push(dateFrom);
    }
    if (dateTo) {
      whereClause += ` AND date <= $${idx++}`;
      values.push(dateTo);
    }

    const result = await this.query(
      `SELECT * FROM templates.template_usage_statistics ${whereClause} ORDER BY date DESC`,
      values
    );
    return result.rows;
  }

  async getAggregateStats(): Promise<{
    total_renders: number;
    avg_duration_ms: number | null;
    top_templates: any[];
  }> {
    const totalResult = await this.query(
      `SELECT COALESCE(SUM(generation_count), 0) as total_renders,
              AVG(avg_duration_ms) as avg_duration_ms
       FROM templates.template_usage_statistics`
    );

    const topResult = await this.query(
      `SELECT t.id, t.code, t.name_ar, t.name_en,
              COALESCE(SUM(us.generation_count), 0) as total_renders
       FROM templates.templates t
       LEFT JOIN templates.template_usage_statistics us ON us.template_id = t.id
       WHERE t.deleted_at IS NULL
       GROUP BY t.id, t.code, t.name_ar, t.name_en
       ORDER BY total_renders DESC
       LIMIT 10`
    );

    return {
      total_renders: parseInt(totalResult.rows[0].total_renders),
      avg_duration_ms: totalResult.rows[0].avg_duration_ms
        ? Math.round(parseFloat(totalResult.rows[0].avg_duration_ms))
        : null,
      top_templates: topResult.rows,
    };
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add backend/src/repositories/template-usage-stats.repository.ts
git commit -m "feat: add template usage stats repository"
```

---

### Task 10: Template Event Mapping Repository

**Files:**
- Create: `backend/src/repositories/template-event-mapping.repository.ts`

**Interfaces:**
- Produces: `TemplateEventMappingRepository` with `findAll`, `findByEventType`, `create`, `update`, `delete`

- [ ] **Step 1: Create the repository file**

```typescript
import { AuditableRepository } from './auditable.repository';

export class TemplateEventMappingRepository extends AuditableRepository {
  async findAll(): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.event_template_mapping ORDER BY event_type, template_code`
    );
    return result.rows;
  }

  async findByEventType(eventType: string): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.event_template_mapping
       WHERE event_type = $1 AND is_active = true
       ORDER BY template_code`,
      [eventType]
    );
    return result.rows;
  }

  async create(data: {
    event_type: string; template_code: string;
    locale?: string; output_format?: string; is_active?: boolean;
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO templates.event_template_mapping
        (event_type, template_code, locale, output_format, is_active,
         created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [
        data.event_type, data.template_code,
        data.locale || 'ar', data.output_format || 'PDF',
        data.is_active !== false,
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<{
    locale: string; output_format: string; is_active: boolean;
  }>): Promise<any | null> {
    const meta = this.updateMeta();
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.locale !== undefined) { sets.push(`locale = $${idx++}`); values.push(data.locale); }
    if (data.output_format !== undefined) { sets.push(`output_format = $${idx++}`); values.push(data.output_format); }
    if (data.is_active !== undefined) { sets.push(`is_active = $${idx++}`); values.push(data.is_active); }

    if (sets.length === 0) {
      const result = await this.query(
        `SELECT * FROM templates.event_template_mapping WHERE id = $1`,
        [id]
      );
      return result.rows[0] || null;
    }

    sets.push(`updated_by = $${idx++}`);
    values.push(meta.updated_by);
    sets.push(`updated_at = $${idx++}`);
    values.push(meta.updated_at);
    values.push(id);

    const result = await this.query(
      `UPDATE templates.event_template_mapping SET ${sets.join(', ')} WHERE id = $${idx} RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async delete(id: number): Promise<boolean> {
    const result = await this.query(
      `DELETE FROM templates.event_template_mapping WHERE id = $1`,
      [id]
    );
    return (result.rowCount ?? 0) > 0;
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add backend/src/repositories/template-event-mapping.repository.ts
git commit -m "feat: add template event mapping repository"
```

---

### Task 11: Template Localization Repository

**Files:**
- Create: `backend/src/repositories/template-localization.repository.ts`

**Interfaces:**
- Produces: `TemplateLocalizationRepository` with `findByVersionId`, `findByVersionIdAndLocale`, `create`, `update`

- [ ] **Step 1: Create the repository file**

```typescript
import { AuditableRepository } from './auditable.repository';

export class TemplateLocalizationRepository extends AuditableRepository {
  async findByVersionId(templateVersionId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.template_localizations
       WHERE template_version_id = $1
       ORDER BY locale ASC`,
      [templateVersionId]
    );
    return result.rows;
  }

  async findByVersionIdAndLocale(templateVersionId: number, locale: string): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_localizations
       WHERE template_version_id = $1 AND locale = $2`,
      [templateVersionId, locale]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    template_version_id: number; locale: string; content: any;
    content_hash: string; is_verified?: boolean;
    verified_by?: number; verified_at?: Date;
  }): Promise<any> {
    const result = await this.query(
      `INSERT INTO templates.template_localizations
        (template_version_id, locale, content, content_hash,
         is_verified, verified_by, verified_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [
        data.template_version_id, data.locale,
        JSON.stringify(data.content), data.content_hash,
        data.is_verified || false, data.verified_by || null,
        data.verified_at || null,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<{
    content: any; content_hash: string;
    is_verified: boolean; verified_by: number; verified_at: Date;
  }>): Promise<any | null> {
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.content !== undefined) { sets.push(`content = $${idx++}`); values.push(JSON.stringify(data.content)); }
    if (data.content_hash !== undefined) { sets.push(`content_hash = $${idx++}`); values.push(data.content_hash); }
    if (data.is_verified !== undefined) { sets.push(`is_verified = $${idx++}`); values.push(data.is_verified); }
    if (data.verified_by !== undefined) { sets.push(`verified_by = $${idx++}`); values.push(data.verified_by); }
    if (data.verified_at !== undefined) { sets.push(`verified_at = $${idx++}`); values.push(data.verified_at); }

    if (sets.length === 0) {
      const result = await this.query(
        `SELECT * FROM templates.template_localizations WHERE id = $1`,
        [id]
      );
      return result.rows[0] || null;
    }

    values.push(id);
    const result = await this.query(
      `UPDATE templates.template_localizations SET ${sets.join(', ')} WHERE id = $${idx} RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add backend/src/repositories/template-localization.repository.ts
git commit -m "feat: add template localization repository"
```

---

### Task 12: Fix TemplateVersionRepository deprecateCurrentApproved bug

**Files:**
- Modify: `backend/src/repositories/template-version.repository.ts`

**Interfaces:**
- Fixes the `deprecateCurrentApproved` method that has a spurious `.slice(0, 2)` on the params array

- [ ] **Step 1: Fix the method**

Replace the broken `deprecateCurrentApproved` method. The original has a `.slice(0, 2)` that incorrectly removes the `now` parameter. The fix:

```typescript
  async deprecateCurrentApproved(templateId: number, now: Date, client?: PoolClient): Promise<VersionData | null> {
    const result = await this.query(
      `UPDATE templates.template_versions
       SET status = 'DEPRECATED', retired_at = $2
       WHERE template_id = $1 AND status = 'APPROVED'
       RETURNING *`,
      [templateId, now],
      client
    );
    return result.rows[0] || null;
  }
```

- [ ] **Step 2: Run lint**

```bash
cd backend && npm run lint
```

- [ ] **Step 3: Commit**

```bash
git add backend/src/repositories/template-version.repository.ts
git commit -m "fix: correct deprecateCurrentApproved param passing"
```

---

### Task 13: Verify all repositories compile

- [ ] **Step 1: Run typecheck**

```bash
cd backend && npm run lint
```

Expected: 0 errors (tsc --noEmit passes)

- [ ] **Step 2: Fix any type errors found**

- [ ] **Step 3: Commit any fixes**

```bash
git add -A
git commit -m "fix: resolve typecheck errors in template repositories"
```

---

## Self-Review Checklist

1. **Spec coverage:** All 11 repositories from the spec are created. TemplateVersionRepository implements all 4 interfaces. TemplateAuditRepository implements `IAuditRepository`. ✓
2. **Placeholder scan:** No TBD/TODO placeholders in any file. ✓
3. **Type consistency:** All methods match their interface signatures. `VersionData` is used consistently across all 4 interface implementations. ✓
4. **Pattern consistency:** All repositories follow `document.repository.ts` patterns — extend `AuditableRepository`, use `this.query()`, parameterized queries, audit meta helpers. ✓
5. **DB schema alignment:** All table names, column names, and types match `55-template-schema.sql`. ✓
