import 'dotenv/config';
import QRCode from 'qrcode';
import crypto from 'crypto';
import Handlebars from 'handlebars';
import { DocumentRenderRepository } from './src/repositories/document-render.repository';
import { DocumentNumberingRepository } from './src/repositories/document-numbering.repository';
import { DocumentRenderService } from './src/services/document-render.service';

function t(label: string, fn: () => Promise<any>) {
  const s = Date.now();
  return fn().then(
    (r) => { console.log(`[${Date.now() - s}ms] ${label}`); return r; },
    (e) => { console.log(`[${Date.now() - s}ms] ${label} FAILED: ${e.message}`); throw e; }
  );
}

(async () => {
  const repo = new DocumentRenderRepository();
  const numRepo = new DocumentNumberingRepository();

  console.log('--- probing repo queries ---');
  const template = await t('findActiveTemplate APPLICATION_DOC/ar', () => repo.findActiveTemplate('APPLICATION_DOC', 'ar'));
  console.log('  template:', template ? `${template.template_code} v${template.version_no}` : 'NOT FOUND');
  const docType = await t('findDocumentTypeId APPLICATION', () => repo.findDocumentTypeId('APPLICATION'));
  console.log('  documentTypeId:', docType);
  const allocated = await t('numbering allocate APPLICATION', () => numRepo.allocate('APPLICATION'));
  console.log('  allocated:', allocated.number);

  console.log('--- probing render steps ---');
  const bodyHtml = Handlebars.compile('{{titleAr}}')({ titleAr: 'x' });
  const verifyUrl = 'http://localhost:5173/verify?ref=test';
  const qr = await t('QRCode.toDataURL', () => QRCode.toDataURL(verifyUrl, { errorCorrectionLevel: 'M', width: 220, margin: 2 }));
  console.log('  qr bytes:', qr.length);

  console.log('--- calling full DocumentRenderService.render (fresh entity) ---');
  const svc = new DocumentRenderService();
  const result = await t('render()', () => svc.render({
    templateCode: 'APPLICATION_DOC',
    language: 'ar',
    category: 'APPLICATION',
    entityType: 'Form',
    entityId: 99999,
    titleAr: 'نموذج تسجيل مشروع بحثي',
    context: { sections: [] },
    issuedBy: { id: 105 } as any,
    watermark: { code: 'OFFICIAL' },
  }));
  console.log('  render result:', JSON.stringify(result, null, 2));
  process.exit(0);
})().catch((e) => { console.error('FATAL', e); process.exit(1); });
