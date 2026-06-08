import { Router } from 'express';
import workflowRoutes from './workflow.routes';

const router = Router();
router.use('/', workflowRoutes);

export default router;
