/*
 * الوحدة الأساسية: طلبات البحث والمشاريع والبيانات المرجعية.
 * تشمل العمليات الأساسية للنظام.
 */
import { Router } from 'express';
import projectRoutes from './projects.routes';
import applicationRoutes from './applications.routes';
import conditionsRoutes from './conditions.routes';
import certificateRoutes from './certificate.routes';
import lookupRoutes from './lookups.routes';

const router = Router();
router.use('/projects', projectRoutes);
router.use('/applications', applicationRoutes);
router.use('/applications/:applicationId/conditions', conditionsRoutes);
router.use('/applications/:applicationId/certificates', certificateRoutes);
router.use('/', lookupRoutes);

export default router;
