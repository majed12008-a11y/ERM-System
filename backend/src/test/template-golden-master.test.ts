import Handlebars from 'handlebars';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { TemplateEngineService } from '../services/template-engine.service';
import { TemplateIntegrationService } from '../services/template-integration.service';
import { SnapshotService } from '../services/template-snapshot.service';
import type { VersionData } from '../services/template-version-lifecycle.service';

// Register partials matching 57-template-seed-content.sql
Handlebars.registerPartial('disclaimer_standard',
  '<div style="border:1px solid #e74c3c;padding:10px;margin:15px 0;background:#fdf2f2;font-size:12px;"><p><strong>تنبيه:</strong> هذا المستند صادر عن اللجنة ويحتوي على معلومات سرية. لا يجوز نسخه أو توزيعه دون إذن خطي.</p></div>');

Handlebars.registerPartial('footer_standard',
  '<div style="border-top:1px solid #ccc;padding-top:8px;margin-top:30px;font-size:11px;color:#666;text-align:center;"><p>لجنة أخلاقيات البحث – جامعة صنعاء</p><p>العنوان | هاتف: د. خالد</p><p>تاريخ الطباعة: 2024-06-01</p></div>');

function makeGoldenVersion(overrides: Partial<VersionData> = {}): VersionData {
  const defaults: VersionData = {
    id: 1, template_id: 100, version: '1.0.0', status: 'APPROVED',
    content: { ar: { body: '{{name}}' } },
    content_hash: 'golden-hash',
    variable_definitions: [{ code: 'name', type: 'string', required: true }],
    change_summary: null, effective_from: null, effective_until: null,
    retired_at: null, approved_by: 10, approved_at: new Date(),
    created_by: 5, created_at: new Date(),
  };
  return { ...defaults, ...overrides };
}

// ─── Template 1: protocol-full ───────────────────────────

const PROTOCOL_AR_BODY = `<h2>بروتوكول البحث العلمي</h2><p><strong>رقم المرجع:</strong> {{applicationReferenceNumber}}</p><p><strong>تاريخ التقديم:</strong> {{applicationSubmittedAt}}</p><hr/><h3>معلومات المشروع</h3><table border="1" cellpadding="8" cellspacing="0" style="width:100%;border-collapse:collapse;"><tr><td style="width:30%;background:#f5f5f5;"><strong>عنوان المشروع (عربي)</strong></td><td>{{projectTitleAr}}</td></tr><tr><td style="background:#f5f5f5;"><strong>عنوان المشروع (إنجليزي)</strong></td><td>{{projectTitleEn}}</td></tr><tr><td style="background:#f5f5f5;"><strong>مستوى المخاطر</strong></td><td>{{projectRiskLevel}}</td></tr><tr><td style="background:#f5f5f5;"><strong>مصدر التمويل</strong></td><td>{{projectFundingSource}}</td></tr></table><h3>مقدم الطلب</h3><p><strong>الاسم:</strong> {{applicationSubmittedBy}}</p><p><strong>نوع الطلب:</strong> {{applicationType}}</p><h3>الباحث الرئيسي</h3><p><strong>الاسم:</strong> {{piFullName}}<br/><strong>البريد الإلكتروني:</strong> {{piEmail}}<br/><strong>الهاتف:</strong> {{piPhone}}</p>{{> disclaimer_standard}}<p style="text-align:left;"><strong>تاريخ الطباعة:</strong> {{today}}</p>`;

describe('Golden Master — protocol-full', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;
  const goldenVars = {
    applicationReferenceNumber: 'REF-001',
    applicationSubmittedAt: '2024-01-15',
    projectTitleAr: 'دراسة السرطان',
    projectTitleEn: 'Cancer Study',
    projectRiskLevel: 'مرتفع',
    projectFundingSource: 'جامعة صنعاء',
    applicationSubmittedBy: 'د. أحمد',
    applicationType: 'جديد',
    piFullName: 'د. محمد',
    piEmail: 'mohamed@example.com',
    piPhone: '777777777',
    today: '2024-06-01',
  };

  beforeEach(() => {
    mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    service = new TemplateEngineService(mockVersionRepo);
  });

  it('produces golden output for Arabic with partial fully rendered', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeGoldenVersion({
      content: { ar: { body: PROTOCOL_AR_BODY } },
      variable_definitions: Object.keys(goldenVars).map(k => ({
        code: k, type: 'string', required: true,
      })),
    }));

    const result = await service.render({
      templateCode: 'protocol-full', version: '1.0.0',
      variables: goldenVars, locale: 'ar',
    });

    expect(result.html).toContain('REF-001');
    expect(result.html).toContain('دراسة السرطان');
    expect(result.html).toContain('د. محمد');
    expect(result.html).toContain('تنبيه');
    expect(result.html).not.toContain('{{>');
    expect(result.locale).toBe('ar');
    expect(result.variableCount).toBe(Object.keys(goldenVars).length);
  });

  it('produces consistent output on re-render', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeGoldenVersion({
      content: { ar: { body: PROTOCOL_AR_BODY } },
      variable_definitions: Object.keys(goldenVars).map(k => ({
        code: k, type: 'string', required: true,
      })),
    }));

    const r1 = await service.render({
      templateCode: 'protocol-full', version: '1.0.0',
      variables: goldenVars, locale: 'ar',
    });
    const r2 = await service.render({
      templateCode: 'protocol-full', version: '1.0.0',
      variables: goldenVars, locale: 'ar',
    });

    expect(r1.html).toBe(r2.html);
  });
});

// ─── Template 2: consent-standard ────────────────────────

const CONSENT_AR_BODY = `<h2>نموذج الموافقة المستنيرة</h2><p><strong>رقم المرجع:</strong> {{applicationReferenceNumber}}</p><hr/><h3>دعوة للمشاركة في البحث</h3><p>أنت مدعو للمشاركة في البحث العلمي بعنوان: <strong>{{projectTitleAr}}</strong></p><h3>نوع الموافقة</h3><p>{{consentType}}</p><h3>حالة الموافقة</h3><p>{{consentStatus}}</p><p><strong>تاريخ التوقيع:</strong> {{consentSignedDate}}</p><h3>معلومات الاتصال</h3><p><strong>اسم الباحث الرئيسي:</strong> {{piFullName}}<br/><strong>الهاتف:</strong> {{piPhone}}<br/><strong>البريد الإلكتروني:</strong> {{piEmail}}</p><p><strong>اللجنة:</strong> {{committeeNameAr}}<br/><strong>رئيس اللجنة:</strong> {{chairpersonName}}</p><hr/><p style="text-align:center;"><strong>المؤسسة:</strong> {{institutionNameAr}}</p><p style="text-align:center;">{{today}}</p>`;

describe('Golden Master — consent-standard', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;
  const goldenVars = {
    applicationReferenceNumber: 'REF-002',
    projectTitleAr: 'دراسة القلب',
    consentType: 'شخص بالغ',
    consentStatus: 'موقّع',
    consentSignedDate: '2024-02-01',
    piFullName: 'د. سارة',
    piPhone: '711111111',
    piEmail: 'sara@example.com',
    committeeNameAr: 'لجنة أخلاقيات البحث',
    chairpersonName: 'د. خالد',
    institutionNameAr: 'جامعة صنعاء',
    today: '2024-06-01',
  };

  beforeEach(() => {
    mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    service = new TemplateEngineService(mockVersionRepo);
  });

  it('produces golden output for Arabic', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeGoldenVersion({
      content: { ar: { body: CONSENT_AR_BODY } },
      variable_definitions: Object.keys(goldenVars).map(k => ({
        code: k, type: 'string', required: true,
      })),
    }));

    const result = await service.render({
      templateCode: 'consent-standard', version: '1.0.0',
      variables: goldenVars, locale: 'ar',
    });

    expect(result.html).toContain('REF-002');
    expect(result.html).toContain('دراسة القلب');
    expect(result.html).toContain('د. سارة');
    expect(result.locale).toBe('ar');
  });
});

// ─── Template 3: decision-standard ───────────────────────

const DECISION_AR_BODY = `<h2 style="text-align:center;">قرار لجنة أخلاقيات البحث العلمي</h2><p style="text-align:center;"><strong>رقم القرار:</strong> {{decisionNumber}}</p><p style="text-align:center;"><strong>تاريخ القرار:</strong> {{decisionDate}}</p><hr/><h3>بيانات الطلب</h3><table border="1" cellpadding="8" cellspacing="0" style="width:100%;border-collapse:collapse;"><tr><td style="width:30%;background:#f5f5f5;"><strong>رقم المرجع</strong></td><td>{{applicationReferenceNumber}}</td></tr><tr><td style="background:#f5f5f5;"><strong>عنوان البحث</strong></td><td>{{projectTitleAr}}</td></tr><tr><td style="background:#f5f5f5;"><strong>مقدم الطلب</strong></td><td>{{applicationSubmittedBy}}</td></tr><tr><td style="background:#f5f5f5;"><strong>الباحث الرئيسي</strong></td><td>{{piFullName}}</td></tr></table><h3>نتيجة القرار</h3><p style="font-size:16px;font-weight:bold;color:#1a5276;">{{decisionResult}}</p><h3>معلومات اللجنة</h3><p><strong>اللجنة:</strong> {{committeeNameAr}}<br/><strong>رئيس اللجنة:</strong> {{chairpersonName}}</p>{{> footer_standard}}`;

describe('Golden Master — decision-standard', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;
  const goldenVars = {
    decisionNumber: 'DEC-001',
    decisionDate: '2024-03-01',
    applicationReferenceNumber: 'REF-003',
    projectTitleAr: 'دراسة السكري',
    applicationSubmittedBy: 'د. أحمد',
    piFullName: 'د. محمد',
    decisionResult: 'موافقة',
    committeeNameAr: 'لجنة أخلاقيات البحث',
    institutionNameAr: 'جامعة صنعاء',
    chairpersonName: 'د. خالد',
    today: '2024-06-01',
  };

  beforeEach(() => {
    mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    service = new TemplateEngineService(mockVersionRepo);
  });

  it('produces golden output for Arabic with partial', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeGoldenVersion({
      content: { ar: { body: DECISION_AR_BODY } },
      variable_definitions: Object.keys(goldenVars).map(k => ({
        code: k, type: 'string', required: true,
      })),
    }));

    const result = await service.render({
      templateCode: 'decision-standard', version: '1.0.0',
      variables: goldenVars, locale: 'ar',
    });

    expect(result.html).toContain('DEC-001');
    expect(result.html).toContain('موافقة');
    expect(result.html).toContain('د. خالد');
    expect(result.html).toContain('تاريخ الطباعة');
    expect(result.html).not.toContain('{{>');
    expect(result.locale).toBe('ar');
  });
});

// ─── Template 4: certificate-approval ────────────────────

const CERT_AR_BODY = `<div style="border:4px double #1a5276;padding:30px;text-align:center;"><h1 style="color:#1a5276;">{{institutionNameAr}}</h1><h3>{{committeeNameAr}}</h3><hr style="border:1px solid #1a5276;"/><h2 style="color:#1a5276;">شهادة اعتماد أخلاقي</h2><p style="font-size:16px;">رقم القرار: <strong>{{decisionNumber}}</strong></p><p style="font-size:14px;">تاريخ القرار: <strong>{{decisionDate}}</strong></p><hr/><h3>البحث المعتمد</h3><p style="font-size:16px;"><strong>{{projectTitleAr}}</strong></p><p><strong>{{projectTitleEn}}</strong></p><table align="center" cellpadding="5"><tr><td style="text-align:left;"><strong>رقم المرجع:</strong></td><td>{{applicationReferenceNumber}}</td></tr><tr><td style="text-align:left;"><strong>مقدم الطلب:</strong></td><td>{{applicationSubmittedBy}}</td></tr><tr><td style="text-align:left;"><strong>الباحث الرئيسي:</strong></td><td>{{piFullName}}</td></tr><tr><td style="text-align:left;"><strong>مستوى المخاطر:</strong></td><td>{{projectRiskLevel}}</td></tr></table><hr/><h3>الاعتماد</h3><p><strong>الحالة:</strong> {{accreditationStatus}}</p><p><strong>صالح حتى:</strong> {{accreditationValidUntil}}</p><br/><p>رئيس اللجنة</p><p><strong>{{chairpersonName}}</strong></p><p>{{committeeNameAr}}</p><p>{{today}}</p></div>`;

describe('Golden Master — certificate-approval', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;
  const goldenVars = {
    institutionNameAr: 'جامعة صنعاء',
    committeeNameAr: 'لجنة أخلاقيات البحث',
    decisionNumber: 'CERT-001',
    decisionDate: '2024-04-01',
    projectTitleAr: 'دراسة الدماغ',
    projectTitleEn: 'Brain Study',
    applicationReferenceNumber: 'REF-004',
    applicationSubmittedBy: 'د. أحمد',
    piFullName: 'د. محمد',
    projectRiskLevel: 'منخفض',
    accreditationStatus: 'ممنوح',
    accreditationValidUntil: '2025-04-01',
    chairpersonName: 'د. خالد',
    today: '2024-06-01',
  };

  beforeEach(() => {
    mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    service = new TemplateEngineService(mockVersionRepo);
  });

  it('produces golden output for Arabic', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeGoldenVersion({
      content: { ar: { body: CERT_AR_BODY } },
      variable_definitions: Object.keys(goldenVars).map(k => ({
        code: k, type: 'string', required: true,
      })),
    }));

    const result = await service.render({
      templateCode: 'certificate-approval', version: '1.0.0',
      variables: goldenVars, locale: 'ar',
    });

    expect(result.html).toContain('شهادة اعتماد أخلاقي');
    expect(result.html).toContain('CERT-001');
    expect(result.html).toContain('دراسة الدماغ');
    expect(result.html).toContain('ممنوح');
    expect(result.locale).toBe('ar');
  });
});

// ─── Template 5: condition-letter ────────────────────────

const CONDITION_AR_BODY = `<h2 style="text-align:center;">قرار مشروط</h2><p><strong>رقم المرجع:</strong> {{applicationReferenceNumber}}</p><p><strong>تاريخ القرار:</strong> {{decisionDate}}</p><hr/><h3>السيد/ {{applicationSubmittedBy}}</h3><p>تحية طيبة وبعد،</p><p>بالإشارة إلى طلبكم رقم <strong>{{applicationReferenceNumber}}</strong> والمقدم بتاريخ <strong>{{applicationSubmittedAt}}</strong> بخصوص مشروع <strong>{{projectTitleAr}}</strong>.</p><p>نفيدكم بأن اللجنة وبعد دراسة الطلب قد اتخذت القرار التالي:</p><p style="font-size:16px;background:#fef9e7;padding:10px;border-right:4px solid #f1c40f;"><strong>{{decisionResult}}</strong></p><p>يرجى الالتزام بالاشتراطات المرفقة واستيفاء المتطلبات خلال الفترة المحددة.</p><h3>معلومات المتابعة</h3><p><strong>الحالة الحالية:</strong> {{workflowCurrentState}}<br/><strong>تاريخ الانتقال:</strong> {{workflowTransitionedAt}}</p><p>وتفضلوا بقبول فائق الاحترام،</p><p><strong>{{chairpersonName}}</strong><br/>{{committeeNameAr}}</p>{{> footer_standard}}`;

describe('Golden Master — condition-letter', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;
  const goldenVars = {
    applicationReferenceNumber: 'REF-005',
    decisionDate: '2024-05-01',
    applicationSubmittedBy: 'د. أحمد',
    applicationSubmittedAt: '2024-04-15',
    projectTitleAr: 'دراسة الكبد',
    decisionResult: 'قرار مشروط',
    workflowCurrentState: 'AWAITING_CONDITIONS',
    workflowTransitionedAt: '2024-05-01',
    chairpersonName: 'د. خالد',
    committeeNameAr: 'لجنة أخلاقيات البحث',
    institutionNameAr: 'جامعة صنعاء',
    today: '2024-06-01',
  };

  beforeEach(() => {
    mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    service = new TemplateEngineService(mockVersionRepo);
  });

  it('produces golden output with partial', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeGoldenVersion({
      content: { ar: { body: CONDITION_AR_BODY } },
      variable_definitions: Object.keys(goldenVars).map(k => ({
        code: k, type: 'string', required: true,
      })),
    }));

    const result = await service.render({
      templateCode: 'condition-letter', version: '1.0.0',
      variables: goldenVars, locale: 'ar',
    });

    expect(result.html).toContain('REF-005');
    expect(result.html).toContain('دراسة الكبد');
    expect(result.html).toContain('AWAITING_CONDITIONS');
    expect(result.html).toContain('تاريخ الطباعة');
    expect(result.html).not.toContain('{{>');
  });
});

// ─── Template 6: notification-status-change ──────────────

const NOTIFICATION_AR_BODY = `<h2>تحديث حالة الطلب</h2><p>عزيزي/ {{applicationSubmittedBy}}،</p><p>نود إعلامك بأن حالة طلبك رقم <strong>{{applicationReferenceNumber}}</strong> قد تم تحديثها.</p><table cellpadding="5" style="margin:15px 0;"><tr><td><strong>الحالة السابقة:</strong></td><td>{{workflowPreviousState}}</td></tr><tr><td><strong>الحالة الحالية:</strong></td><td><strong>{{workflowCurrentState}}</strong></td></tr><tr><td><strong>تاريخ التحديث:</strong></td><td>{{workflowTransitionedAt}}</td></tr></table>`;

describe('Golden Master — notification-status-change', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;
  const goldenVars = {
    applicationReferenceNumber: 'REF-006',
    applicationSubmittedBy: 'د. أحمد',
    workflowPreviousState: 'SUBMITTED',
    workflowCurrentState: 'UNDER_REVIEW',
    workflowTransitionedAt: '2024-06-01',
    today: '2024-06-01',
  };

  beforeEach(() => {
    mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    service = new TemplateEngineService(mockVersionRepo);
  });

  it('produces golden output', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeGoldenVersion({
      content: { ar: { body: NOTIFICATION_AR_BODY } },
      variable_definitions: Object.keys(goldenVars).map(k => ({
        code: k, type: 'string', required: true,
      })),
    }));

    const result = await service.render({
      templateCode: 'notification-status-change', version: '1.0.0',
      variables: goldenVars, locale: 'ar',
    });

    expect(result.html).toContain('REF-006');
    expect(result.html).toContain('UNDER_REVIEW');
    expect(result.html).toContain('SUBMITTED');
  });
});

// ─── Golden Master Consistency ───────────────────────────

describe('Golden Master — Cross-Service Consistency', () => {
  it('engine + integration produce identical HTML', async () => {
    const mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    const vars = { name: 'golden' };

    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeGoldenVersion());

    const engine = new TemplateEngineService(mockVersionRepo);
    const snapshotService = new SnapshotService();
    const integration = new TemplateIntegrationService(engine, snapshotService, mockVersionRepo);

    const engineResult = await engine.render({
      templateCode: 'TPL-001', version: '1.0.0', variables: vars,
    });

    const integrationResult = await integration.renderDocument({
      templateCode: 'TPL-001', version: '1.0.0', variables: vars,
      renderedBy: 1,
    });

    expect(integrationResult.html).toBe(engineResult.html);
  });

  it('golden output is deterministic across 5 runs', async () => {
    const mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeGoldenVersion());
    const engine = new TemplateEngineService(mockVersionRepo);

    const outputs: string[] = [];
    for (let i = 0; i < 5; i++) {
      const r = await engine.render({
        templateCode: 'TPL-001', version: '1.0.0',
        variables: { name: 'golden_test' },
      });
      outputs.push(r.html);
    }

    expect(new Set(outputs).size).toBe(1);
  });

  it('golden output includes expected HTML structure', async () => {
    const mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeGoldenVersion({
      content: { ar: { body: '<div class="golden">{{name}}</div>' } },
    }));
    const engine = new TemplateEngineService(mockVersionRepo);

    const result = await engine.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'master' },
    });

    expect(result.html).toBe('<div class="golden">master</div>');
  });
});
