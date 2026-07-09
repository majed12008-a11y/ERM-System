import path from 'path';
import fs from 'fs/promises';
import Handlebars from 'handlebars';
import QRCode from 'qrcode';
import { CertificateRepository, CertificateVerificationData } from '../repositories/certificate.repository';
import { DocumentRepository } from '../repositories/document.repository';
import { AuthUser } from '../shared/types';
import { logger } from '../config/logger';
import { NotificationService } from './notification.service';
import {
  certificateOperationsTotal,
  certificateGenerationDurationSeconds,
  certificateVerificationsTotal,
} from './metrics.service';

const CERTIFICATE_TEMPLATE_CODE = 'APPROVAL_CERTIFICATE_V1';
const UPLOADS_DIR = path.resolve('uploads/certificates');

interface TemplateContext {
  serialNumber: string;
  applicationNumber: string;
  projectTitle: string;
  researcherName: string;
  committeeName: string;
  committeeNameEn: string;
  institutionName: string;
  issueDate: string;
  expiryDate: string | null;
  qrCodeDataUrl: string;
  approvalStatement: string;
  conditions: { text: string; category: string }[];
  issuingAuthority: string;
}

export class CertificateService {
  constructor(
    private repo: CertificateRepository,
    private documentRepo: DocumentRepository,
  ) {}

  async generate(applicationId: number, issuedBy: AuthUser): Promise<void> {
    const genStart = process.hrtime.bigint();
    try {
      const existing = await this.repo.findActiveByApplication(applicationId);
      if (existing && ['ISSUED', 'GENERATING'].includes(existing.status)) {
        return;
      }

      let cert = existing;
      if (cert?.status === 'FAILED') {
        await this.repo.updateStatus(cert.id, 'GENERATING');
      }

      if (!cert) {
        await this.repo.acquireAdvisoryLock(applicationId);

        const existingAgain = await this.repo.findActiveByApplication(applicationId);
        if (existingAgain && ['ISSUED', 'GENERATING'].includes(existingAgain.status)) {
          return;
        }

        const appRow = await this.getApplicationData(applicationId);
        const maxVer = await this.repo.getMaxVersion(applicationId);
        const versionNo = maxVer + 1;
        const serialNumber = `CERT-${appRow.application_number}-V${versionNo}`;

        cert = await this.repo.create({
          application_id: applicationId,
          serial_number: serialNumber,
          version_no: versionNo,
          status: 'GENERATING',
          issued_to_user_id: appRow.submitted_by,
          issued_by_user_id: issuedBy.id,
          metadata: { generated_at: new Date().toISOString() },
        });
      }

      await this.renderAndSave(cert.id, cert.serial_number, applicationId);

      await this.repo.markIssued(cert.id);
      const durationSeconds = Number(process.hrtime.bigint() - genStart) / 1e9;
      logger.info({ applicationId, serial: cert.serial_number, durationSeconds }, 'Certificate issued');
      certificateOperationsTotal.inc({ operation: 'generate', result: 'success' });
      certificateGenerationDurationSeconds.observe({ operation: 'generate' }, durationSeconds);

      const issuedNotif = new NotificationService();
      await issuedNotif.send({
        userId: cert.issued_to_user_id,
        notificationType: 'CERTIFICATE_ISSUED',
        subject: `Certificate Issued - ${cert.serial_number}`,
        messageBody: `Certificate ${cert.serial_number} has been issued for application #${applicationId}.`,
        sourceEntityType: 'Certificate',
        sourceEntityId: cert.id,
      });
    } catch (err) {
      const durationSeconds = Number(process.hrtime.bigint() - genStart) / 1e9;
      logger.error({ err, applicationId, durationSeconds }, 'Certificate generation failed');
      certificateOperationsTotal.inc({ operation: 'generate', result: 'failure' });
      if (err instanceof Error) {
        const existing = await this.repo.findActiveByApplication(applicationId);
        if (existing) {
          await this.repo.updateStatus(existing.id, 'FAILED', {
            generation_error: { message: err.message, stack: err.stack, timestamp: new Date().toISOString() },
          });

          const failNotif = new NotificationService();
          const adminIds = await this.repo.getEthicsAdmins();
          for (const adminId of adminIds) {
            await failNotif.send({
              userId: adminId,
              notificationType: 'CERTIFICATE_GENERATION_FAILED',
              subject: `Certificate Generation Failed - Application #${applicationId}`,
              messageBody: `Certificate generation failed for application #${applicationId}. Please retry.`,
              sourceEntityType: 'Certificate',
              sourceEntityId: existing.id,
            });
          }
        }
      }
    }
  }

  async retry(certificateId: number, issuedBy: AuthUser): Promise<void> {
    const cert = await this.repo.findById(certificateId);
    if (!cert) {
      throw Object.assign(new Error('Certificate not found'), { status: 404 });
    }
    if (cert.status !== 'FAILED') {
      throw Object.assign(new Error('Only FAILED certificates can be retried'), { status: 400 });
    }

    const retryStart = process.hrtime.bigint();
    await this.repo.updateStatus(certificateId, 'GENERATING');
    try {
      await this.renderAndSave(cert.id, cert.serial_number, cert.application_id);
      await this.repo.markIssued(cert.id);
      const durationSeconds = Number(process.hrtime.bigint() - retryStart) / 1e9;

      logger.info({ certificateId, serial: cert.serial_number, durationSeconds }, 'Certificate retry succeeded');
      certificateOperationsTotal.inc({ operation: 'retry', result: 'success' });
      certificateGenerationDurationSeconds.observe({ operation: 'retry' }, durationSeconds);

      const retryNotif = new NotificationService();
      await retryNotif.send({
        userId: cert.issued_to_user_id,
        notificationType: 'CERTIFICATE_ISSUED',
        subject: `Certificate Issued - ${cert.serial_number}`,
        messageBody: `Certificate ${cert.serial_number} has been issued for application #${cert.application_id} (retry).`,
        sourceEntityType: 'Certificate',
        sourceEntityId: cert.id,
      });
    } catch (err) {
      const durationSeconds = Number(process.hrtime.bigint() - retryStart) / 1e9;
      logger.error({ err, certificateId, serial: cert.serial_number, durationSeconds }, 'Certificate retry failed');
      certificateOperationsTotal.inc({ operation: 'retry', result: 'failure' });

      await this.repo.updateStatus(certificateId, 'FAILED', {
        generation_error: err instanceof Error
          ? { message: err.message, stack: err.stack, timestamp: new Date().toISOString() }
          : { message: String(err) },
      });

      const retryFailNotif = new NotificationService();
      const adminIds = await this.repo.getEthicsAdmins();
      for (const adminId of adminIds) {
        await retryFailNotif.send({
          userId: adminId,
          notificationType: 'CERTIFICATE_GENERATION_FAILED',
          subject: `Certificate Generation Failed - ${cert.serial_number}`,
          messageBody: `Certificate generation retry failed for application #${cert.application_id}.`,
          sourceEntityType: 'Certificate',
          sourceEntityId: certificateId,
        });
      }

      throw err;
    }
  }

  async reissue(certificateId: number, issuedBy: AuthUser): Promise<void> {
    const oldCert = await this.repo.findById(certificateId);
    if (!oldCert) {
      throw Object.assign(new Error('Certificate not found'), { status: 404 });
    }
    if (oldCert.status !== 'ISSUED') {
      throw Object.assign(new Error('Only ISSUED certificates can be re-issued'), { status: 400 });
    }

    await this.repo.acquireAdvisoryLock(oldCert.application_id);

    const appRow = await this.getApplicationData(oldCert.application_id);
    const maxVer = await this.repo.getMaxVersion(oldCert.application_id);
    const versionNo = maxVer + 1;
    const serialNumber = `CERT-${appRow.application_number}-V${versionNo}`;

    const newCert = await this.repo.create({
      application_id: oldCert.application_id,
      serial_number: serialNumber,
      version_no: versionNo,
      status: 'GENERATING',
      issued_to_user_id: oldCert.issued_to_user_id,
      issued_by_user_id: issuedBy.id,
      metadata: { reissued_from: certificateId, reissued_at: new Date().toISOString() },
    });

    const reissueStart = process.hrtime.bigint();
    try {
      await this.renderAndSave(newCert.id, serialNumber, oldCert.application_id);
      await this.repo.markIssued(newCert.id);
      await this.repo.supersede(certificateId, newCert.id);
      const durationSeconds = Number(process.hrtime.bigint() - reissueStart) / 1e9;

      logger.info({ certificateId, newCertId: newCert.id, serial: serialNumber, durationSeconds }, 'Certificate re-issue succeeded');
      certificateOperationsTotal.inc({ operation: 'reissue', result: 'success' });
      certificateGenerationDurationSeconds.observe({ operation: 'reissue' }, durationSeconds);

      const reissueNotif = new NotificationService();
      await reissueNotif.send({
        userId: newCert.issued_to_user_id,
        notificationType: 'CERTIFICATE_REISSUED',
        subject: `Certificate Re-issued - ${serialNumber}`,
        messageBody: `Certificate ${serialNumber} has been re-issued for application #${oldCert.application_id}.`,
        sourceEntityType: 'Certificate',
        sourceEntityId: newCert.id,
      });
    } catch (err) {
      const durationSeconds = Number(process.hrtime.bigint() - reissueStart) / 1e9;
      logger.error({ err, certificateId, serial: serialNumber, durationSeconds }, 'Certificate re-issue failed');
      certificateOperationsTotal.inc({ operation: 'reissue', result: 'failure' });

      await this.repo.updateStatus(newCert.id, 'FAILED', {
        generation_error: err instanceof Error
          ? { message: err.message, stack: err.stack, timestamp: new Date().toISOString() }
          : { message: String(err) },
      });

      const reissueFailNotif = new NotificationService();
      const adminIds = await this.repo.getEthicsAdmins();
      for (const adminId of adminIds) {
        await reissueFailNotif.send({
          userId: adminId,
          notificationType: 'CERTIFICATE_GENERATION_FAILED',
          subject: `Certificate Generation Failed - ${serialNumber}`,
          messageBody: `Certificate re-issue generation failed for application #${oldCert.application_id}.`,
          sourceEntityType: 'Certificate',
          sourceEntityId: newCert.id,
        });
      }

      throw Object.assign(new Error('Certificate re-issuance failed'), { status: 500 });
    }
  }

  async revoke(certificateId: number, reason: string, revokedBy: AuthUser): Promise<void> {
    const cert = await this.repo.findById(certificateId);
    if (!cert) {
      throw Object.assign(new Error('Certificate not found'), { status: 404 });
    }
    if (cert.status !== 'ISSUED') {
      throw Object.assign(new Error('Only ISSUED certificates can be revoked'), { status: 400 });
    }

    const revokeStart = process.hrtime.bigint();
    await this.repo.revoke(certificateId, reason, revokedBy.id);
    const durationSeconds = Number(process.hrtime.bigint() - revokeStart) / 1e9;

    logger.info({ certificateId, serial: cert.serial_number, reason, revokedBy: revokedBy.id, durationSeconds }, 'Certificate revoked');
    certificateOperationsTotal.inc({ operation: 'revoke', result: 'success' });

    const revokeNotif = new NotificationService();
    await revokeNotif.send({
      userId: cert.issued_to_user_id,
      notificationType: 'CERTIFICATE_REVOKED',
      subject: `Certificate Revoked - ${cert.serial_number}`,
      messageBody: `Certificate ${cert.serial_number} for application #${cert.application_id} has been revoked. Reason: ${reason}`,
      sourceEntityType: 'Certificate',
      sourceEntityId: certificateId,
    });
  }

  async verify(serialNumber: string, ip?: string): Promise<CertificateVerificationData> {
    const data = await this.repo.getVerificationData(serialNumber);
    if (!data) {
      await this.repo.logVerification(serialNumber, ip || null, 'NOT_FOUND');
      certificateVerificationsTotal.inc({ result: 'NOT_FOUND' });
      logger.warn({ serialNumber, ip }, 'Certificate verification: not found');
      throw Object.assign(new Error('Certificate not found'), { status: 404 });
    }

    data.verifiedAt = new Date().toISOString();
    const allowedResults = ['VALID', 'REVOKED', 'SUPERSEDED', 'NOT_FOUND', 'ERROR'];
    const logResult = data.status === 'ISSUED' ? 'VALID' : (allowedResults.includes(data.status) ? data.status : 'ERROR');
    await this.repo.logVerification(serialNumber, ip || null, logResult, {
      status: data.status,
    });

    certificateVerificationsTotal.inc({ result: logResult });
    logger.info({ serialNumber, result: logResult, status: data.status, ip }, 'Certificate verification');

    return data;
  }

  async listByApplication(applicationId: number): Promise<any[]> {
    const certs = await this.repo.findByApplication(applicationId);
    const result = [];
    for (const cert of certs) {
      const docs = await this.repo.getLinkedDocuments(cert.id);
      result.push({
        ...cert,
        documents: docs,
      });
    }
    return result;
  }

  async getDownloadInfo(certificateId: number): Promise<{ storagePath: string; fileName: string } | null> {
    const docs = await this.repo.getLinkedDocuments(certificateId);
    if (docs.length === 0) return null;

    const doc = await this.documentRepo.findById(docs[0].document_id);
    if (!doc) return null;

    return {
      storagePath: doc.storage_path,
      fileName: doc.file_name,
    };
  }

  async getDocumentId(certificateId: number): Promise<number | null> {
    const docs = await this.repo.getLinkedDocuments(certificateId);
    return docs.length > 0 ? docs[0].document_id : null;
  }

  private async renderAndSave(certificateId: number, serialNumber: string, applicationId: number): Promise<void> {
    const ctx = await this.buildTemplateContext(serialNumber, applicationId);

    const templateContent = await this.repo.getTemplateContent(CERTIFICATE_TEMPLATE_CODE);
    if (!templateContent) {
      throw new Error(`Template ${CERTIFICATE_TEMPLATE_CODE} not found`);
    }

    const html = Handlebars.compile(templateContent)(ctx);

    const pdfPath = path.join(UPLOADS_DIR, `${serialNumber}.pdf`);
    await fs.mkdir(UPLOADS_DIR, { recursive: true });

    await this.renderPdf(html, pdfPath);

    const doc = await this.documentRepo.create({
      document_type_id: undefined,
      entity_type: 'Application',
      entity_id: applicationId,
      document_title: `شهادة اعتماد - ${serialNumber}`,
      file_name: `${serialNumber}.pdf`,
      mime_type: 'application/pdf',
      storage_path: pdfPath,
      uploaded_by: ctx.issued_by_user_id,
      file_size_bytes: (await fs.stat(pdfPath)).size,
    });

    await this.repo.linkDocument(certificateId, doc.id, true);
  }

  private async buildTemplateContext(serialNumber: string, applicationId: number): Promise<TemplateContext & { issued_by_user_id: number }> {
    const row = await this.repo.getApplicationBuildContext(applicationId);
    if (!row) {
      throw new Error(`Application ${applicationId} not found`);
    }

    const qrCodeDataUrl = await QRCode.toDataURL(`https://ethics.erc.gov.sa/verify?serial=${serialNumber}`, {
      errorCorrectionLevel: 'M',
      width: 256,
      margin: 2,
    });

    return {
      serialNumber,
      applicationNumber: row.application_number,
      projectTitle: row.title_ar,
      researcherName: row.researcher_name,
      committeeName: row.committee_name,
      committeeNameEn: row.committee_name_en,
      institutionName: row.institution_name,
      issueDate: new Date().toLocaleDateString('ar-SA', { year: 'numeric', month: 'long', day: 'numeric' }),
      expiryDate: null,
      qrCodeDataUrl,
      approvalStatement: 'يشهد الفريق المختص بأن البحث المقدم قد استوفي المتطلبات الأخلاقية',
      conditions: [],
      issuingAuthority: 'اللجنة الوطنية للأخلاقيات',
      issued_by_user_id: row.created_by || row.submitted_by,
    };
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
      await page.pdf({
        path: outputPath,
        format: 'A4',
        margin: { top: '20mm', bottom: '20mm', left: '20mm', right: '20mm' },
        printBackground: true,
      });
    } finally {
      if (browser) await browser.close();
    }
  }

  private async findChrome(): Promise<string | undefined> {
    const commonPaths = [
      'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
      'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe',
      '/usr/bin/chromium-browser',
      '/usr/bin/chromium',
      '/usr/bin/google-chrome',
      '/usr/bin/google-chrome-stable',
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

  private async getApplicationData(applicationId: number): Promise<{ application_number: string; submitted_by: number }> {
    const data = await this.repo.getBasicApplicationData(applicationId);
    if (!data) {
      throw Object.assign(new Error('Application not found'), { status: 404 });
    }
    return data;
  }
}
