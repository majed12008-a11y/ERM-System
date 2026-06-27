import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { query } from '../../config/database';
import { successResponse, errorResponse } from '../../shared/utils';

const router = Router();

type EntityCfg = { schema: string; table: string; labelCol: string; orderCol: string };

const entityConfig: Record<string, EntityCfg> = {
  'academic-titles':      { schema: 'reference',    table: 'academic_titles',         labelCol: 'name_ar',      orderCol: 'display_order' },
  'institutions':         { schema: 'security',     table: 'institutions',            labelCol: 'name_ar',      orderCol: 'name_ar' },
  'institution-types':    { schema: 'security',     table: 'institution_types',       labelCol: 'name_ar',      orderCol: 'name_ar' },
  'departments':          { schema: 'security',     table: 'departments',             labelCol: 'name_ar',      orderCol: 'name_ar' },
  'research-categories':  { schema: 'core',         table: 'research_categories',     labelCol: 'name_ar',      orderCol: 'id' },
  'risk-classifications': { schema: 'core',         table: 'risk_classifications',    labelCol: 'name_ar',      orderCol: 'severity_level' },
  'vulnerable-populations':{schema: 'core',         table: 'vulnerable_populations',  labelCol: 'name_ar',      orderCol: 'id' },
  'document-types':       { schema: 'documents',    table: 'document_types',          labelCol: 'type_name_ar', orderCol: 'type_name_ar' },
  'committee-types':      { schema: 'committee',    table: 'committee_types',         labelCol: 'type_name',    orderCol: 'type_name' },
  'committee-roles':      { schema: 'committee',    table: 'committee_roles',         labelCol: 'role_name',    orderCol: 'role_name' },
  'notification-channels':{ schema: 'communication',table: 'notification_channels',   labelCol: 'channel_name', orderCol: 'channel_name' },
  'lookup-categories':    { schema: 'reference',    table: 'lookup_categories',       labelCol: 'category_name_ar', orderCol: 'category_name_ar' },
  'lookup-values':        { schema: 'reference',    table: 'lookup_values',           labelCol: 'value_name_ar', orderCol: 'display_order' },
  'professions':          { schema: 'reference',    table: 'professions_registry',    labelCol: 'name_ar',      orderCol: 'name_ar' },
  'institutions-registry':{ schema: 'reference',    table: 'institutions_registry',   labelCol: 'name_ar',      orderCol: 'name_ar' },
};

function getEntity(req: Request): string { return req.params.entity as string; }
function getId(req: Request): number { return parseInt(req.params.id as string); }

function getConfig(entity: string) {
  const cfg = entityConfig[entity];
  if (!cfg) return null;
  return { fullTable: `"${cfg.schema}"."${cfg.table}"`, ...cfg };
}

router.get('/:entity', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    const entity = getEntity(req);
    const cfg = getConfig(entity);
    if (!cfg) return res.status(400).json(errorResponse('Unknown entity: ' + entity));
    const result = await query(`SELECT * FROM ${cfg.fullTable} ORDER BY ${cfg.orderCol}`);
    res.json(successResponse(result.rows));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/:entity/:id', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    const cfg = getConfig(getEntity(req));
    if (!cfg) return res.status(400).json(errorResponse('Unknown entity'));
    const result = await query(`SELECT * FROM ${cfg.fullTable} WHERE id = $1`, [getId(req)]);
    if (result.rows.length === 0) return res.status(404).json(errorResponse('Not found'));
    res.json(successResponse(result.rows[0]));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:entity', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'), async (req: Request, res: Response) => {
  try {
    const cfg = getConfig(getEntity(req));
    if (!cfg) return res.status(400).json(errorResponse('Unknown entity'));
    const keys = Object.keys(req.body);
    const values = Object.values(req.body);
    const cols = keys.map(k => `"${k}"`).join(', ');
    const placeholders = keys.map((_, i) => `$${i + 1}`).join(', ');
    const result = await query(`INSERT INTO ${cfg.fullTable} (${cols}) VALUES (${placeholders}) RETURNING *`, values);
    res.status(201).json(successResponse(result.rows[0]));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/:entity/:id', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'), async (req: Request, res: Response) => {
  try {
    const cfg = getConfig(getEntity(req));
    if (!cfg) return res.status(400).json(errorResponse('Unknown entity'));
    const keys = Object.keys(req.body);
    const values: any[] = Object.values(req.body);
    const setClause = keys.map((k, i) => `"${k}" = $${i + 1}`).join(', ');
    values.push(getId(req));
    const result = await query(`UPDATE ${cfg.fullTable} SET ${setClause} WHERE id = $${keys.length + 1} RETURNING *`, values);
    if (result.rows.length === 0) return res.status(404).json(errorResponse('Not found'));
    res.json(successResponse(result.rows[0]));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/:entity/:id', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'), async (req: Request, res: Response) => {
  try {
    const cfg = getConfig(getEntity(req));
    if (!cfg) return res.status(400).json(errorResponse('Unknown entity'));
    const result = await query(`DELETE FROM ${cfg.fullTable} WHERE id = $1 RETURNING id`, [getId(req)]);
    if (result.rows.length === 0) return res.status(404).json(errorResponse('Not found'));
    res.json(successResponse({ deleted: true }));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
