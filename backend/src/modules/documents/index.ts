/*
 * وحدة المستندات: رفع وتنزيل وإدارة الملفات والمستندات
 * المرتبطة بالطلبات والمشاريع واللجان.
 */
import { Router } from 'express';
import documentRoutes from './documents.routes';
import documentTemplatesRoutes from './document-templates.routes';

const router = Router();
router.use('/templates', documentTemplatesRoutes);
router.use('/', documentRoutes);

export default router;
