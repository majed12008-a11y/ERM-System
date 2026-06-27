/*
 * وحدة اللجان: اللجان، الاجتماعات، المراجعات، الأعضاء،
 * التصويت، المخاطر الأخلاقية، الموافقة المستنيرة، والاعتماد.
 */
import { Router } from 'express';
import committeeRoutes from './committees.routes';
import meetingRoutes from './meetings.routes';
import reviewRoutes from './reviews.routes';
import memberRoutes from './members.routes';
import votingRoutes from './voting.routes';
import ethicsRiskRoutes from './ethics-risk.routes';
import consentRoutes from './consent.routes';
import accreditationRoutes from './accreditation.routes';

const router = Router();
router.use('/committees', committeeRoutes);
router.use('/meetings', meetingRoutes);
router.use('/reviews', reviewRoutes);
router.use('/members', memberRoutes);
router.use('/voting', votingRoutes);
router.use('/ethics-risk', ethicsRiskRoutes);
router.use('/consent', consentRoutes);
router.use('/accreditation', accreditationRoutes);

export default router;
