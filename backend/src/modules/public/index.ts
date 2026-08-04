import { Router } from 'express';
import certificateRoutes from './certificate.routes';
import documentRoutes from './documents.routes';
import verificationRoutes from './verification.routes';

const router = Router();
router.use('/certificates', certificateRoutes);
router.use('/documents', documentRoutes);
router.use('/verification', verificationRoutes);

export default router;
