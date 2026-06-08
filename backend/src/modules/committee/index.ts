import { Router } from 'express';
import committeeRoutes from './committees.routes';
import meetingRoutes from './meetings.routes';
import reviewRoutes from './reviews.routes';
import memberRoutes from './members.routes';
import votingRoutes from './voting.routes';

const router = Router();
router.use('/committees', committeeRoutes);
router.use('/meetings', meetingRoutes);
router.use('/reviews', reviewRoutes);
router.use('/members', memberRoutes);
router.use('/voting', votingRoutes);

export default router;
