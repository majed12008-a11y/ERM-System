import { Router, Request, Response } from 'express';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { authenticate } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { CommunicationService } from '../../services/communication.service';

const router = Router();
const MSG_UPLOAD_DIR = path.resolve('uploads/messages');
if (!fs.existsSync(MSG_UPLOAD_DIR)) {
  fs.mkdirSync(MSG_UPLOAD_DIR, { recursive: true });
}
const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, MSG_UPLOAD_DIR),
  filename: (_req, file, cb) => cb(null, `${Date.now()}-${file.originalname}`),
});
const upload = multer({ storage, limits: { fileSize: 10 * 1024 * 1024 } });
const service = new CommunicationService();

router.get('/messages', authenticate, async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    res.json(successResponse(await service.getMessages(user.id, (req.query.box as string) || 'inbox')));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/messages/unread-count', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse({ count: await service.getUnreadCount((req as any).user.id) }));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/messages/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const msg = await service.getMessageById(Number(req.params.id), user.id);
    if (!msg) { res.status(404).json(errorResponse('Message not found')); return; }
    res.json(successResponse(msg));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/messages', authenticate, upload.array('attachments'), async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    let recipient_ids: number[];
    if (typeof req.body.recipient_ids === 'string') {
      try { recipient_ids = JSON.parse(req.body.recipient_ids); } catch { recipient_ids = req.body.recipient_ids.split(',').map(Number); }
    } else if (Array.isArray(req.body.recipient_ids)) {
      recipient_ids = req.body.recipient_ids.map(Number);
    } else {
      res.status(400).json(errorResponse('At least one recipient required')); return;
    }
    if (!recipient_ids.length) { res.status(400).json(errorResponse('At least one recipient required')); return; }
    const msg = await service.createMessage(
      user.id,
      {
        recipient_ids,
        subject: req.body.subject as string,
        message_body: req.body.message_body as string,
        related_entity_type: req.body.related_entity_type as string,
        related_entity_id: req.body.related_entity_id as string,
      },
      (req as any).files as Express.Multer.File[],
    );
    res.status(201).json(successResponse(msg, 'Message sent'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/messages/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const deleted = await service.deleteMessage(Number(req.params.id), (req as any).user.id);
    if (!deleted) { res.status(404).json(errorResponse('Message not found')); return; }
    res.json(successResponse(null, 'Message deleted'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/messages/:id/attachments/:attachmentId', authenticate, async (req: Request, res: Response) => {
  try {
    const att = await service.getAttachment(Number(req.params.attachmentId), Number(req.params.id));
    if (!att) { res.status(404).json(errorResponse('Attachment not found')); return; }
    res.download(att.file_path, att.file_name);
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/users/search', authenticate, async (req: Request, res: Response) => {
  try {
    const q = req.query.q as string;
    if (!q || q.length < 2) { res.json(successResponse([])); return; }
    res.json(successResponse(await service.searchUsers(q)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
