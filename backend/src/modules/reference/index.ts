/*
 * وحدة البيانات المرجعية: استعلامات للمؤسسات،
 * التصنيفات، والبيانات الأساسية للنظام.
 */
import { Router, Request, Response } from 'express';
import { query } from '../../config/database';
import { authenticate } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';

const router = Router();

router.get('/institutions-registry', async (req: Request, res: Response) => {
  try {
    const result = await query(
      `SELECT i.id, i.code as national_id, i.name_ar, i.name_en, it.name_ar as type,
              i.phone, i.email, i.address, i.is_active as is_accredited
       FROM security.institutions i
       JOIN security.institution_types it ON i.institution_type_id = it.id
       WHERE i.is_active = true
       ORDER BY i.name_ar`
    );
    res.json(successResponse(result.rows));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.get('/professions', authenticate, async (_req: Request, res: Response) => {
  try {
    const result = await query(
      'SELECT id, code, name_ar, name_en, category FROM reference.professions_registry WHERE is_active = true ORDER BY name_ar'
    );
    res.json(successResponse(result.rows));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.get('/licenses', authenticate, async (req: Request, res: Response) => {
  try {
    const result = await query(
      `SELECT lr.*, pr.name_ar as profession_name,
              CONCAT(u.first_name_ar, ' ', u.last_name_ar) as user_name
        FROM reference.licenses_registry lr
        JOIN reference.professions_registry pr ON lr.profession_id = pr.id
        JOIN security.users u ON lr.user_id = u.id
        ORDER BY lr.created_at DESC`
    );
    res.json(successResponse(result.rows));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

export default router;
