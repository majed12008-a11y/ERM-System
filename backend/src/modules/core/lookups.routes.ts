import { Router, Request, Response } from 'express';
import { query } from '../../config/database';
import { authenticate } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';

const router = Router();

router.get('/research-categories', authenticate, async (_req: Request, res: Response) => {
  try {
    const result = await query('SELECT id, code, name_ar, name_en, description FROM core.research_categories WHERE is_active = true ORDER BY id');
    res.json(successResponse(result.rows));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.get('/risk-classifications', authenticate, async (_req: Request, res: Response) => {
  try {
    const result = await query('SELECT id, code, name_ar, name_en, severity_level, description, is_active FROM core.risk_classifications ORDER BY severity_level');
    res.json(successResponse(result.rows));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.get('/vulnerable-populations', authenticate, async (_req: Request, res: Response) => {
  try {
    const result = await query('SELECT id, code, name_ar, name_en, safeguards_required FROM core.vulnerable_populations WHERE is_active = true ORDER BY id');
    res.json(successResponse(result.rows));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.get('/research-population-links', authenticate, async (req: Request, res: Response) => {
  try {
    const { project_id } = req.query;
    let where = '';
    const params: any[] = [];
    if (project_id) { where = 'WHERE rpl.project_id = $1'; params.push(project_id); }
    const result = await query(
      `SELECT rpl.*, vp.name_ar as population_name, vp.code as population_code,
              vp.safeguards_required, p.title_ar as project_title
       FROM core.research_population_links rpl
       JOIN core.vulnerable_populations vp ON rpl.population_id = vp.id
       JOIN core.projects p ON rpl.project_id = p.id
       ${where} ORDER BY rpl.id`,
      params
    );
    res.json(successResponse(result.rows));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

export default router;
