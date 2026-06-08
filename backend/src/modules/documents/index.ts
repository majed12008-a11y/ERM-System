import { Router } from 'express';
import documentRoutes from './documents.routes';

const router = Router();
router.use('/', documentRoutes);

export default router;
