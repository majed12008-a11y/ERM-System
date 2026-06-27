/*
 * الوحدة الأساسية: طلبات البحث والمشاريع والبيانات المرجعية.
 * تشمل العمليات الأساسية للنظام.
 */
import { Router } from 'express';
import projectRoutes from './projects.routes';
import applicationRoutes from './applications.routes';
import lookupRoutes from './lookups.routes';

const router = Router();
router.use('/projects', projectRoutes);
router.use('/applications', applicationRoutes);
router.use('/', lookupRoutes);

export default router;
