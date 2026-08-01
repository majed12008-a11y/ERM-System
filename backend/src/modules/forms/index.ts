/*
 * وحدة مكتبة النماذج: تعريفات النماذج، مثيلاتها،
 * وتوليد المستندات الرسمية من استجاباتها.
 */
import { Router } from 'express';
import formsRoutes from './forms.routes';

const router = Router();
router.use('/', formsRoutes);

export default router;
