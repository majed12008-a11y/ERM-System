/*
 * محرك المستندات الرسمية:
 *   - استرجاع القالب النشط حسب (الرمز، اللغة) مع تفضيل الافتراضي.
 *   - تخصيص رقم مستند رسمي ذري.
 *   - بناء الهيكل الرسمي (ترويسة الجهة، رقم المستند، QR، الإصدار،
 *     التاريخ، التوقيعات، سرية، تذييل، ترقيم صفحات).
 *   - توليد PDF (A4) عبر puppeteer-core.
 *   - بصمة SHA-256 وحفظ المستند في سجل المستندات مع الإصدارات
 *     وسجل التوليد والتدقيق.
 * المخرجات غير قابلة للتعديل: كل نسخة تُخزَّن كملف PDF دائم.
 */
import path from 'path';
import fs from 'fs/promises';
import crypto from 'crypto';
import Handlebars from 'handlebars';
import QRCode from 'qrcode';
import { logger } from '../config/logger';
import { env } from '../config/env';
import { AuthUser } from '../shared/types';
import { DocumentNumberingRepository } from '../repositories/document-numbering.repository';
import { DocumentRenderRepository, TemplateRow } from '../repositories/document-render.repository';

const GENERATED_DIR = path.resolve('uploads/generated-documents');

export interface Signatory {
  name: string;
  role: string;
}

export interface RenderRequest {
  templateCode: string;
  language: 'ar' | 'en';
  category: string;
  entityType: string;
  entityId: number;
  titleAr: string;
  titleEn?: string;
  context: Record<string, any>;
  issuedBy: AuthUser;
  signatories?: Signatory[];
  institutionNameAr?: string;
  institutionNameEn?: string;
  committeeNameAr?: string;
  committeeNameEn?: string;
  versionNotes?: string;
}

export interface RenderResult {
  documentId: number;
  documentNumber: string;
  versionNo: number;
  templateId: number;
  storagePath: string;
  fileName: string;
  checksumSha256: string;
  language: string;
}

export class DocumentRenderService {
  constructor(
    private renderRepo = new DocumentRenderRepository(),
    private numberingRepo = new DocumentNumberingRepository(),
  ) {}

  async render(req: RenderRequest): Promise<RenderResult> {
    const template = await this.renderRepo.findActiveTemplate(req.templateCode, req.language);
    if (!template) {
      throw Object.assign(new Error(`Template ${req.templateCode} not found (active)`), { status: 404 });
    }
    if (template.document_category && req.category !== template.document_category) {
      req = { ...req, category: template.document_category };
    }

    const documentTypeId = await this.renderRepo.findDocumentTypeId(req.category);
    if (!documentTypeId) {
      throw Object.assign(new Error(`No document type mapped for category ${req.category}`), { status: 500 });
    }

    const allocated = await this.numberingRepo.allocate(req.category);

    const previous = await this.renderRepo.findLatestVersionByEntity(
      req.entityType, req.entityId, req.templateCode, template.language
    );
    const versionNo = previous ? previous.current_version_no + 1 : 1;

    const issueDateAr = new Date().toLocaleDateString('ar-SA', { year: 'numeric', month: 'long', day: 'numeric' });
    const issueDateEn = new Date().toLocaleDateString('en-GB', { year: 'numeric', month: 'long', day: 'numeric' });

    const bodyHtml = Handlebars.compile(template.template_content)({
      ...req.context,
      lang: template.language,
      dir: template.language === 'ar' ? 'rtl' : 'ltr',
      documentNumber: allocated.number,
      documentTitle: template.language === 'ar' ? req.titleAr : (req.titleEn || req.titleAr),
      issueDateAr,
      issueDateEn,
      committeeNameAr: req.committeeNameAr || '',
      committeeNameEn: req.committeeNameEn || '',
      institutionNameAr: req.institutionNameAr || '',
      institutionNameEn: req.institutionNameEn || '',
    });

    const sha256 = crypto.createHash('sha256').update(allocated.number).digest('hex');
    const verifyUrl = `${env.FRONTEND_URL}/verify?ref=${encodeURIComponent(allocated.number)}`;
    const qrDataUrl = await QRCode.toDataURL(verifyUrl, { errorCorrectionLevel: 'M', width: 220, margin: 2 });

    const shellHtml = this.buildShell({
      language: template.language,
      template,
      documentNumber: allocated.number,
      title: template.language === 'ar' ? req.titleAr : (req.titleEn || req.titleAr),
      issueDateAr,
      issueDateEn,
      bodyHtml,
      signatories: req.signatories || [],
      qrDataUrl,
      verifyUrl,
      sha256: sha256.slice(0, 16),
      institutionNameAr: req.institutionNameAr || '',
      institutionNameEn: req.institutionNameEn || '',
      committeeNameAr: req.committeeNameAr || '',
      committeeNameEn: req.committeeNameEn || '',
      documentType: req.category,
    });

    await fs.mkdir(GENERATED_DIR, { recursive: true });
    const safeCode = template.template_code.replace(/[^A-Za-z0-9_-]/g, '');
    const fileName = `${safeCode}_${allocated.number}_v${versionNo}.pdf`;
    const pdfPath = path.join(GENERATED_DIR, fileName);

    await this.renderPdf(shellHtml, pdfPath);
    const pdfBytes = await fs.readFile(pdfPath);
    const checksumSha256 = crypto.createHash('sha256').update(pdfBytes).digest('hex');

    const documentId = await this.renderRepo.createDocument({
      document_type_id: documentTypeId,
      entity_type: req.entityType,
      entity_id: req.entityId,
      document_title: req.titleAr,
      file_name: fileName,
      mime_type: 'application/pdf',
      storage_path: pdfPath,
      uploaded_by: req.issuedBy.id,
      file_size_bytes: pdfBytes.length,
      checksum_sha256: checksumSha256,
      document_number: allocated.number,
      document_uuid: crypto.randomUUID(),
      current_version_no: versionNo,
      template_code: template.template_code,
      template_version: template.version_no,
      language: template.language,
      supersedes_version_no: previous ? previous.current_version_no : null,
      superseded_by_document_id: null,
    });

    await this.renderRepo.createVersion({
      document_id: documentId,
      version_no: versionNo,
      file_name: fileName,
      storage_path: pdfPath,
      checksum_sha256: checksumSha256,
      uploaded_by: req.issuedBy.id,
      version_notes: req.versionNotes || `Generated from template ${template.template_code} (${template.language})`,
      document_uuid: crypto.randomUUID(),
      template_code: template.template_code,
      template_version: template.version_no,
      language: template.language,
      supersedes_version_id: previous ? previous.version_id : null,
    });

    if (previous) {
      await this.renderRepo.markSuperseded(previous.id, documentId);
      await this.renderRepo.logAudit(previous.id, 'SUPERSEDED', req.issuedBy.id, {
        superseded_by_document_id: documentId,
        superseded_by_number: allocated.number,
        new_version_no: versionNo,
        reason: req.versionNotes || 'Superseded by a new version of the document',
      });
    }

    await this.renderRepo.createGenerated({
      template_id: template.id,
      entity_type: req.entityType,
      entity_id: req.entityId,
      generated_document_id: documentId,
      generated_by: req.issuedBy.id,
      generation_parameters: {
        document_number: allocated.number,
        language: template.language,
        title_ar: req.titleAr,
        title_en: req.titleEn || null,
        version_no: versionNo,
        template_version: template.version_no,
      },
    });

    await this.renderRepo.logAudit(documentId, 'GENERATED', req.issuedBy.id, {
      document_number: allocated.number,
      template_code: template.template_code,
      language: template.language,
      version_no: versionNo,
      supersedes_version_no: previous ? previous.current_version_no : null,
      sha256: checksumSha256,
    });

    logger.info(
      { documentId, number: allocated.number, template: template.template_code, language: template.language, size: pdfBytes.length, versionNo },
      'Official document generated'
    );

    return {
      documentId,
      documentNumber: allocated.number,
      versionNo,
      templateId: template.id,
      storagePath: pdfPath,
      fileName,
      checksumSha256,
      language: template.language,
    };
  }

  private buildShell(opts: {
    language: string;
    template: TemplateRow;
    documentNumber: string;
    title: string;
    issueDateAr: string;
    issueDateEn: string;
    bodyHtml: string;
    signatories: Signatory[];
    qrDataUrl: string;
    verifyUrl: string;
    sha256: string;
    institutionNameAr: string;
    institutionNameEn: string;
    committeeNameAr: string;
    committeeNameEn: string;
    documentType: string;
  }): string {
    const isAr = opts.language === 'ar';
    const dir = isAr ? 'rtl' : 'ltr';
    const authority = isAr
      ? (opts.committeeNameAr || opts.institutionNameAr || 'اللجنة الوطنية للأخلاقيات')
      : (opts.committeeNameEn || opts.institutionNameEn || 'National Ethics Committee');
    const institution = isAr
      ? (opts.institutionNameAr || '')
      : (opts.institutionNameEn || '');
    const confidentiality = isAr
      ? 'وثيقة سرية — مخصصة للجهات المختصة فقط'
      : 'CONFIDENTIAL — For authorised parties only';
    const verifyLabel = isAr ? 'تحقق من صحة الوثيقة عبر رمز QR أو الرابط أدناه' : 'Verify authenticity via QR code or the link below';
    const pageLabel = isAr ? 'صفحة' : 'Page';
    const refLabel = isAr ? 'رقم الوثيقة' : 'Document No.';
    const dateLabel = isAr ? 'التاريخ' : 'Date';
    const versionLabel = isAr ? 'الإصدار' : 'Version';
    const issuedByLabel = isAr ? 'الجهة المصدرة' : 'Issued by';

    const signatoryBlocks = opts.signatories
      .map(
        (s) => `
      <div class="signature-block">
        <div class="signature-line"></div>
        <div class="signature-name">${this.escapeHtml(s.name)}</div>
        <div class="signature-role">${this.escapeHtml(s.role)}</div>
      </div>`
      )
      .join('');

    const signaturesHtml = opts.signatories.length
      ? `<div class="doc-signatures">${signatoryBlocks}</div>`
      : '';

    return `<!DOCTYPE html>
<html lang="${isAr ? 'ar' : 'en'}" dir="${dir}">
<head>
<meta charset="UTF-8">
<title>${this.escapeHtml(opts.title)}</title>
<style>
  @page { size: A4; margin: 16mm 15mm 22mm 15mm; }
  * { box-sizing: border-box; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
  html, body { margin: 0; padding: 0; }
  body {
    font-family: 'Segoe UI', Tahoma, 'Noto Sans Arabic', 'Arial', sans-serif;
    color: #111; font-size: 11pt; line-height: 1.75;
  }
  .doc-shell { max-width: 100%; }
  /* ── Header ── */
  .doc-header {
    display: flex; justify-content: space-between; align-items: stretch;
    border-bottom: 3px solid #0b3d2e; padding-bottom: 8px; margin-bottom: 10px;
  }
  .doc-header .seal-col { width: 16mm; text-align: center; }
  .doc-header .seal-col img { width: 14mm; height: 14mm; }
  .doc-header .authority-col { flex: 1; text-align: center; }
  .doc-header .authority-col .institution { font-size: 12pt; font-weight: 700; color: #0b3d2e; }
  .doc-header .authority-col .committee { font-size: 14pt; font-weight: 800; color: #111; margin-top: 2px; }
  .doc-header .authority-col .wordmark { font-size: 8.5pt; color: #555; letter-spacing: .5px; margin-top: 2px; }
  /* ── Reference row ── */
  .doc-ref {
    display: flex; justify-content: space-between; font-size: 9.5pt; color: #333;
    border-bottom: 1px solid #ccc; padding-bottom: 6px; margin-bottom: 14px;
  }
  .doc-ref .ref-item { margin: 0; }
  .doc-ref .ref-label { font-weight: 700; }
  /* ── Title ── */
  .doc-title {
    text-align: center; font-size: 14.5pt; font-weight: 800; color: #0b3d2e;
    margin: 10px 0 18px; padding: 6px 12px;
    border: 1.5px solid #0b3d2e; border-radius: 4px; display: inline-block; width: 100%;
  }
  /* ── Body (template fragment styles shared) ── */
  .doc-body { margin-bottom: 20px; }
  .doc-body p { margin: 0 0 8px; }
  .doc-body .label { font-weight: 700; }
  .doc-body .section-heading {
    font-size: 11.5pt; font-weight: 800; color: #0b3d2e;
    border-bottom: 1px solid #0b3d2e; margin: 16px 0 8px; padding-bottom: 3px;
  }
  .doc-body table.doc-section { width: 100%; border-collapse: collapse; margin: 6px 0 12px; }
  .doc-body table.doc-section th, .doc-body table.doc-section td {
    border: 1px solid #999; padding: 5px 8px; vertical-align: top; font-size: 10pt;
  }
  .doc-body table.doc-section th { background: #eef4f1; color: #0b3d2e; text-align: center; }
  .doc-body table.doc-section td.field-label { width: 30%; font-weight: 700; background: #f7faf8; }
  .doc-body .decision-summary {
    background: #f3f8f5; border-right: 4px solid #0b3d2e; padding: 8px 12px;
    margin: 8px 0; font-weight: 700; border-radius: 3px;
  }
  .doc-body .salutation { font-weight: 700; }
  .doc-body .appeal-note { font-style: italic; color: #444; margin-top: 10px; }
  .doc-body ol.conditions-list { margin: 4px 0 8px 0; padding-inline-start: 24px; }
  .doc-body .review-meta { margin-bottom: 8px; }
  .doc-body .review-meta .label { margin-inline-end: 10px; }
  .doc-body .signature-note { margin-top: 16px; font-weight: 700; }
  /* ── Signatures ── */
  .doc-signatures {
    display: flex; justify-content: space-around; gap: 24px;
    margin: 28px 0 24px;
  }
  .signature-block { flex: 1; max-width: 46%; }
  .signature-line { border-top: 1px solid #333; height: 1px; margin-bottom: 4px; }
  .signature-name { font-weight: 700; font-size: 10.5pt; }
  .signature-role { font-size: 9.5pt; color: #444; }
  /* ── Footer ── */
  .doc-footer {
    display: flex; justify-content: space-between; align-items: center;
    border-top: 2px solid #0b3d2e; margin-top: 18px; padding-top: 8px;
  }
  .doc-footer .qr-col { width: 18mm; text-align: center; }
  .doc-footer .qr-col img { width: 16mm; height: 16mm; }
  .doc-footer .info-col { flex: 1; font-size: 8.5pt; color: #444; padding: 0 10px; }
  .doc-footer .info-col .verify { font-weight: 700; color: #0b3d2e; }
  .doc-footer .confidentiality {
    font-size: 8pt; font-weight: 700; text-align: center; color: #0b3d2e; margin-top: 4px;
  }
</style>
</head>
<body>
<div class="doc-shell">
  <div class="doc-header">
    <div class="seal-col"></div>
    <div class="authority-col">
      <div class="institution">${this.escapeHtml(institution)}</div>
      <div class="committee">${this.escapeHtml(authority)}</div>
      <div class="wordmark">${this.escapeHtml(isAr ? 'اللجنة الوطنية للأخلاقيات — نظام إدارة المراجعات' : 'National Ethics Committee — Review Management System')}</div>
    </div>
    <div class="seal-col"></div>
  </div>

  <div class="doc-ref">
    <div class="ref-item"><span class="ref-label">${refLabel}: </span>${this.escapeHtml(opts.documentNumber)}</div>
    <div class="ref-item"><span class="ref-label">${dateLabel}: </span>${isAr ? this.escapeHtml(opts.issueDateAr) : this.escapeHtml(opts.issueDateEn)}</div>
    <div class="ref-item"><span class="ref-label">${versionLabel}: </span>${opts.template.version_no}</div>
    <div class="ref-item"><span class="ref-label">${issuedByLabel}: </span>${this.escapeHtml(authority)}</div>
  </div>

  <div class="doc-title">${this.escapeHtml(opts.title)}</div>

  <div class="doc-body">${opts.bodyHtml}</div>

  ${signaturesHtml}

  <div class="doc-footer">
    <div class="qr-col"><img src="${opts.qrDataUrl}" alt="QR"></div>
    <div class="info-col">
      <div class="verify">${verifyLabel}</div>
      <div>${this.escapeHtml(opts.verifyUrl)}</div>
      <div>SHA-256: ${opts.sha256}...</div>
    </div>
    <div class="qr-col"></div>
  </div>
  <div class="confidentiality">${confidentiality}</div>
</div>
</body>
</html>`;
  }

  private escapeHtml(value: string): string {
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  private async renderPdf(html: string, outputPath: string): Promise<void> {
    let browser;
    try {
      const puppeteer = await import('puppeteer-core');
      const executablePath = process.env.CHROME_PATH || process.env.PUPPETEER_CHROMIUM_REVISION
        ? undefined
        : await this.findChrome();

      browser = await puppeteer.launch({
        headless: true,
        executablePath,
        args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'],
      });

      const page = await browser.newPage();
      await page.setContent(html, { waitUntil: 'load' });

      const isRtl = html.includes('dir="rtl"');
      await page.pdf({
        path: outputPath,
        format: 'A4',
        printBackground: true,
        displayHeaderFooter: true,
        headerTemplate: '<div></div>',
        footerTemplate:
          `<div style="width:100%;font-size:8px;padding:0 15mm;display:flex;justify-content:space-between;align-items:center;font-family:Tahoma,sans-serif;">
             <span style="color:#555;">${isRtl ? 'صفحة' : 'Page'} <span class="pageNumber"></span> / <span class="totalPages"></span></span>
             <span style="color:#0b3d2e;font-weight:bold;">${isRtl ? 'وثيقة رسمية — سرية' : 'Official — Confidential'}</span>
           </div>`,
        margin: { top: '16mm', bottom: '22mm', left: '15mm', right: '15mm' },
      });
    } finally {
      if (browser) await browser.close();
    }
  }

  private async findChrome(): Promise<string | undefined> {
    const commonPaths = [
      'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
      'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe',
      'C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe',
      'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe',
      '/usr/bin/chromium-browser',
      '/usr/bin/chromium',
      '/usr/bin/google-chrome',
      '/usr/bin/google-chrome-stable',
      '/usr/bin/microsoft-edge',
    ];

    for (const p of commonPaths) {
      try {
        await fs.access(p);
        return p;
      } catch {
        continue;
      }
    }

    logger.warn('No Chrome/Chromium binary found. Install Chrome or set CHROME_PATH env var.');
    return undefined;
  }
}
