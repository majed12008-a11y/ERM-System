/*
 * وحدة الأمان: المصادقة (تسجيل الدخول)، إدارة المستخدمين،
 * الأدوار، الصلاحيات، المسؤوليات، والملفات الشخصية.
 */
import { Router } from 'express';
import authRoutes from './auth.routes';
import userRoutes from './users.routes';
import roleRoutes from './roles.routes';
import permissionRoutes from './permissions.routes';
import profileRoutes from './profiles.routes';
import responsibilityRoutes from './responsibility.routes';

const router = Router();
router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/roles', roleRoutes);
router.use('/permissions', permissionRoutes);
router.use('/', profileRoutes);
router.use('/', responsibilityRoutes);

export default router;
