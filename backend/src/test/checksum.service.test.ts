import { describe, it, expect, vi, beforeEach } from 'vitest';
import crypto from 'crypto';
import { ChecksumService } from '../services/checksum.service';

function makeRepo() {
  return {
    getVerificationData: vi.fn(),
    logVerification: vi.fn().mockResolvedValue(undefined),
  };
}

describe('ChecksumService', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('returns UNKNOWN for an unknown reference', async () => {
    const repo = makeRepo() as any;
    repo.getVerificationData.mockResolvedValue(null);
    const service = new ChecksumService(repo);

    const res = await service.verify('DOES-NOT-EXIST-0001', Buffer.from('x'), null);

    expect(res.result).toBe('UNKNOWN');
    expect(res.algorithm).toBe('sha256');
    expect(repo.logVerification).toHaveBeenCalledWith('DOES-NOT-EXIST-0001', null, 'UNKNOWN');
  });

  it('returns VALID when the uploaded hash matches and status is current', async () => {
    const repo = makeRepo() as any;
    const storedHash = crypto.createHash('sha256').update('original-bytes').digest('hex');
    repo.getVerificationData.mockResolvedValue({ checksum_sha256: storedHash, status: 'ISSUED' });
    const service = new ChecksumService(repo);

    const res = await service.verify('DOC-0001', Buffer.from('original-bytes'), '127.0.0.1');

    expect(res.result).toBe('VALID');
    expect(res.status).toBe('ISSUED');
    expect(res.checksum_sha256).toBe(storedHash);
    expect(repo.logVerification).toHaveBeenCalledWith(
      'DOC-0001', '127.0.0.1', 'VALID',
      expect.objectContaining({ document_status: 'ISSUED' })
    );
  });

  it('returns MODIFIED when the uploaded hash differs from the stored hash', async () => {
    const repo = makeRepo() as any;
    repo.getVerificationData.mockResolvedValue({
      checksum_sha256: crypto.createHash('sha256').update('original').digest('hex'),
      status: 'ISSUED',
    });
    const service = new ChecksumService(repo);

    const res = await service.verify('DOC-0002', Buffer.from('tampered-bytes'), null);

    expect(res.result).toBe('MODIFIED');
    expect(res.algorithm).toBe('sha256');
  });

  it('returns INVALID when the hash matches but the document is not current', async () => {
    const repo = makeRepo() as any;
    const storedHash = crypto.createHash('sha256').update('bytes').digest('hex');
    repo.getVerificationData.mockResolvedValue({ checksum_sha256: storedHash, status: 'REVOKED' });
    const service = new ChecksumService(repo);

    const res = await service.verify('DOC-0003', Buffer.from('bytes'), null);

    expect(res.result).toBe('INVALID');
    expect(res.status).toBe('REVOKED');
  });

  it('uses the configured checksum algorithm', async () => {
    const repo = makeRepo() as any;
    repo.getVerificationData.mockResolvedValue({ checksum_sha256: 'abc', status: 'ISSUED' });
    const service = new ChecksumService(repo);

    const res = await service.verify('DOC-0004', Buffer.from('bytes'), null);

    expect(['sha256', 'sha384', 'sha512']).toContain(res.algorithm);
  });
});
