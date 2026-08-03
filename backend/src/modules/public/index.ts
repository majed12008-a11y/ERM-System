import { Router } from 'express';
import certificateRoutes from './certificate.routes';
import documentRoutes from './documents.routes';

const router = Router();
router.use('/certificates', certificateRoutes);
router.use('/documents', documentRoutes);

export default router;
