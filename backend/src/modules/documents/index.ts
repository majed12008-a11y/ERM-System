/*
 * وحدة المستندات: رفع وتنزيل وإدارة الملفات والمستندات
 * المرتبطة بالطلبات والمشاريع واللجان.
 */
import { Router } from 'express';
import documentRoutes from './documents.routes';

const router = Router();
router.use('/', documentRoutes);

export default router;
