/*
 * خدمة التحقق من تكامل المستند: مقارنة بصمة الملف المرفوع
 * بالبصمة المخزنة عند التوليد. الخوارزمية قابلة للتكوين.
 */
import crypto from 'crypto';
import { env } from '../config/env';
import { logger } from '../config/logger';
import { DocumentRenderRepository } from '../repositories/document-render.repository';

export type ChecksumResult = 'VALID' | 'INVALID' | 'MODIFIED' | 'UNKNOWN';

export class ChecksumService {
  constructor(private renderRepo = new DocumentRenderRepository()) {}

  async verify(
    reference: string,
    fileBuffer: Buffer,
    ip: string | null
  ): Promise<{ result: ChecksumResult; algorithm: string; checksum_sha256?: string; status?: string }> {
    const algorithm = env.CHECKSUM_ALGORITHM;
    const data = await this.renderRepo.getVerificationData(reference);

    if (!data) {
      await this.renderRepo.logVerification(reference, ip, 'UNKNOWN');
      return { result: 'UNKNOWN', algorithm };
    }

    const provided = crypto.createHash(algorithm).update(fileBuffer).digest('hex');
    const match = provided === data.checksum_sha256;
    const current = ['ISSUED', 'APPROVED'].includes(data.status);

    let result: ChecksumResult;
    if (!match) result = 'MODIFIED';
    else if (!current) result = 'INVALID';
    else result = 'VALID';

    await this.renderRepo.logVerification(reference, ip, result, {
      algorithm,
      provided_hash: provided,
      expected_hash: data.checksum_sha256,
      document_status: data.status,
    });

    logger.info({ reference, result, algorithm }, 'Checksum verification completed');
    return { result, algorithm, checksum_sha256: data.checksum_sha256, status: data.status };
  }
}
