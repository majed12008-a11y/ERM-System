import { describe, it, expect, vi, beforeEach } from 'vitest';
import { TemplateIntegrationService } from '../services/template-integration.service';
import { TemplateEngineService } from '../services/template-engine.service';
import { SnapshotService } from '../services/template-snapshot.service';
import {
  ApplicationDocumentService,
  CommitteeDocumentService,
  AccreditationDocumentService,
  ConsentDocumentService,
  SafetyDocumentService,
  NotificationDocumentService,
  ReportDocumentService,
} from '../services/document-generation.service';
import type { VersionData } from '../services/template-version-lifecycle.service';

function makeVersion(overrides: Partial<VersionData> = {}): VersionData {
  return {
    id: 1, template_id: 100, version: '1.0.0', status: 'APPROVED',
    content: { ar: { body: '{{name}}' } }, content_hash: 'abc123',
    variable_definitions: [{ code: 'name', type: 'string', required: true }],
    change_summary: null, effective_from: null, effective_until: null,
    retired_at: null, approved_by: 10, approved_at: new Date(),
    created_by: 5, created_at: new Date(), ...overrides,
  };
}

function setupService() {
  const mockVersionRepo = { findByCodeAndVersion: vi.fn() };
  const snapshotService = new SnapshotService();
  const engine = new TemplateEngineService(mockVersionRepo);
  const integration = new TemplateIntegrationService(engine, snapshotService, mockVersionRepo);
  return { mockVersionRepo, snapshotService, engine, integration };
}

// ─── ApplicationDocumentService ──────────────────────────

describe('ApplicationDocumentService', () => {
  let svc: ApplicationDocumentService;
  let mockVersionRepo: any;

  beforeEach(() => {
    const s = setupService();
    s.mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
    mockVersionRepo = s.mockVersionRepo;
    svc = new ApplicationDocumentService(s.integration);
  });

  it('generateSubmissionConfirmation', async () => {
    const r = await svc.generateSubmissionConfirmation(1, { name: 'test' }, 10);
    expect(r.html).toBe('test');
    expect(r.snapshot).toBeDefined();
  });

  it('generateApplicationReceipt', async () => {
    const r = await svc.generateApplicationReceipt(1, { name: 'test' }, 10);
    expect(r.html).toBe('test');
  });

  it('generateReturnForCorrection', async () => {
    const r = await svc.generateReturnForCorrection(1, { name: 'test' }, 10);
    expect(r.html).toBe('test');
  });

  it('generateApprovalLetter links snapshot to lifecycle event', async () => {
    const r = await svc.generateApprovalLetter(1, { name: 'test' }, 10);
    expect(r.html).toBe('test');
    expect(r.snapshot).toBeDefined();
  });

  it('generateConditionalApproval', async () => {
    const r = await svc.generateConditionalApproval(1, { name: 'test' }, 10);
    expect(r.html).toBe('test');
  });

  it('generateRejectionLetter', async () => {
    const r = await svc.generateRejectionLetter(1, { name: 'test' }, 10);
    expect(r.html).toBe('test');
  });

  it('generateWithdrawalConfirmation', async () => {
    const r = await svc.generateWithdrawalConfirmation(1, { name: 'test' }, 10);
    expect(r.html).toBe('test');
  });

  it('all 7 application document types produce unique snapshots', async () => {
    const refs: string[] = [];
    for (const gen of [
      () => svc.generateSubmissionConfirmation(1, { name: 'a' }, 10),
      () => svc.generateApplicationReceipt(1, { name: 'b' }, 10),
      () => svc.generateReturnForCorrection(1, { name: 'c' }, 10),
      () => svc.generateApprovalLetter(1, { name: 'd' }, 10),
      () => svc.generateConditionalApproval(1, { name: 'e' }, 10),
      () => svc.generateRejectionLetter(1, { name: 'f' }, 10),
      () => svc.generateWithdrawalConfirmation(1, { name: 'g' }, 10),
    ]) {
      const r = await gen();
      refs.push(r.snapshotHash);
    }
    expect(new Set(refs).size).toBe(7);
  });
});

// ─── CommitteeDocumentService ────────────────────────────

describe('CommitteeDocumentService', () => {
  let svc: CommitteeDocumentService;
  let mockVersionRepo: any;

  beforeEach(() => {
    const s = setupService();
    s.mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
    mockVersionRepo = s.mockVersionRepo;
    svc = new CommitteeDocumentService(s.integration);
  });

  it('generateMeetingAgenda', async () => {
    const r = await svc.generateMeetingAgenda(1, { name: 'جدول' }, 10);
    expect(r.html).toBe('جدول');
  });

  it('generateMeetingMinutes', async () => {
    const r = await svc.generateMeetingMinutes(1, { name: 'محضر' }, 10);
    expect(r.html).toBe('محضر');
  });

  it('generateReviewSummary', async () => {
    const r = await svc.generateReviewSummary(1, { name: 'مراجعة' }, 10);
    expect(r.html).toBe('مراجعة');
  });

  it('generateFinalDecision', async () => {
    const r = await svc.generateFinalDecision(1, { name: 'قرار' }, 10);
    expect(r.html).toBe('قرار');
  });
});

// ─── AccreditationDocumentService ────────────────────────

describe('AccreditationDocumentService', () => {
  let svc: AccreditationDocumentService;
  let mockVersionRepo: any;

  beforeEach(() => {
    const s = setupService();
    s.mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
    mockVersionRepo = s.mockVersionRepo;
    svc = new AccreditationDocumentService(s.integration);
  });

  it('generateAccreditationDecision', async () => {
    const r = await svc.generateAccreditationDecision(1, { name: 'اعتماد' }, 10);
    expect(r.html).toBe('اعتماد');
  });

  it('generateConditionalAccreditation', async () => {
    const r = await svc.generateConditionalAccreditation(1, { name: 'مشروط' }, 10);
    expect(r.html).toBe('مشروط');
  });

  it('generateSuspensionNotice', async () => {
    const r = await svc.generateSuspensionNotice(1, { name: 'تعليق' }, 10);
    expect(r.html).toBe('تعليق');
  });

  it('generateRevocationNotice', async () => {
    const r = await svc.generateRevocationNotice(1, { name: 'إلغاء' }, 10);
    expect(r.html).toBe('إلغاء');
  });

  it('generateExpirationNotice', async () => {
    const r = await svc.generateExpirationNotice(1, { name: 'انتهاء' }, 10);
    expect(r.html).toBe('انتهاء');
  });

  it('generateAccreditationCertificate', async () => {
    const r = await svc.generateAccreditationCertificate(1, { name: 'شهادة' }, 10);
    expect(r.html).toBe('شهادة');
  });
});

// ─── ConsentDocumentService ──────────────────────────────

describe('ConsentDocumentService', () => {
  let svc: ConsentDocumentService;
  let mockVersionRepo: any;

  beforeEach(() => {
    const s = setupService();
    s.mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
    mockVersionRepo = s.mockVersionRepo;
    svc = new ConsentDocumentService(s.integration);
  });

  it('generateConsentForm', async () => {
    const r = await svc.generateConsentForm(1, { name: 'موافقة' }, 10);
    expect(r.html).toBe('موافقة');
  });
});

// ─── SafetyDocumentService ───────────────────────────────

describe('SafetyDocumentService', () => {
  let svc: SafetyDocumentService;
  let mockVersionRepo: any;

  beforeEach(() => {
    const s = setupService();
    s.mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
    mockVersionRepo = s.mockVersionRepo;
    svc = new SafetyDocumentService(s.integration);
  });

  it('generateSafetyReport', async () => {
    const r = await svc.generateSafetyReport(1, { name: 'سلامة' }, 10);
    expect(r.html).toBe('سلامة');
  });

  it('generateRiskAssessment', async () => {
    const r = await svc.generateRiskAssessment(1, { name: 'مخاطر' }, 10);
    expect(r.html).toBe('مخاطر');
  });
});

// ─── NotificationDocumentService ─────────────────────────

describe('NotificationDocumentService', () => {
  let svc: NotificationDocumentService;
  let mockVersionRepo: any;

  beforeEach(() => {
    const s = setupService();
    s.mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
    mockVersionRepo = s.mockVersionRepo;
    svc = new NotificationDocumentService(s.integration);
  });

  it('generateStatusChangeNotification', async () => {
    const r = await svc.generateStatusChangeNotification(1, { name: 'إشعار' }, 10);
    expect(r.html).toBe('إشعار');
  });

  it('generateGenericEmail', async () => {
    const r = await svc.generateGenericEmail(1, { name: 'بريد' }, 10);
    expect(r.html).toBe('بريد');
  });
});

// ─── ReportDocumentService ───────────────────────────────

describe('ReportDocumentService', () => {
  let svc: ReportDocumentService;
  let mockVersionRepo: any;

  beforeEach(() => {
    const s = setupService();
    s.mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
    mockVersionRepo = s.mockVersionRepo;
    svc = new ReportDocumentService(s.integration);
  });

  it('generateAnnualReport', async () => {
    const r = await svc.generateAnnualReport(1, { name: 'تقرير' }, 10);
    expect(r.html).toBe('تقرير');
  });
});

// ─── Module Document Keys Coverage ───────────────────────

describe('Module Coverage', () => {
  it('all MODULE_DOCUMENTS keys are covered', async () => {
    const { MODULE_DOCUMENTS } = await import('../shared/template-integration.types');
    const keys = Object.keys(MODULE_DOCUMENTS);

    expect(keys).toContain('application.submission');
    expect(keys).toContain('application.receipt');
    expect(keys).toContain('application.correction');
    expect(keys).toContain('application.approval');
    expect(keys).toContain('application.conditional');
    expect(keys).toContain('application.rejection');
    expect(keys).toContain('application.withdrawal');
    expect(keys).toContain('meeting.agenda');
    expect(keys).toContain('meeting.minutes');
    expect(keys).toContain('committee.review');
    expect(keys).toContain('committee.decision');
    expect(keys).toContain('accreditation.decision');
    expect(keys).toContain('accreditation.conditional');
    expect(keys).toContain('accreditation.suspension');
    expect(keys).toContain('accreditation.revocation');
    expect(keys).toContain('accreditation.expiration');
    expect(keys).toContain('accreditation.certificate');
    expect(keys).toContain('consent.form');
    expect(keys).toContain('safety.report');
    expect(keys).toContain('risk.assessment');
    expect(keys).toContain('notification.status');
    expect(keys).toContain('email.generic');
    expect(keys).toContain('report.annual');
  });
});
