import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { query } from '../../config/database';

const router = Router();

router.use(authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'));

router.get('/:group', async (req: Request, res: Response) => {
  try {
    const result = await query(
      'SELECT id, config_key, config_value, config_group, description, is_encrypted FROM system.system_config WHERE config_group = $1 AND is_active = true ORDER BY config_key',
      [req.params.group]
    );
    res.json(successResponse(result.rows));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/:group/:key', async (req: Request, res: Response) => {
  try {
    const { config_value } = req.body;
    if (config_value === undefined) return res.status(400).json(errorResponse('config_value is required'));
    const result = await query(
      `INSERT INTO system.system_config (config_key, config_value, config_group, description)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (config_key) DO UPDATE SET config_value = $2, config_group = $3, updated_at = now()
       RETURNING *`,
      [req.params.key, config_value, req.params.group, req.body.description || '']
    );
    res.json(successResponse(result.rows[0], 'Config updated'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
