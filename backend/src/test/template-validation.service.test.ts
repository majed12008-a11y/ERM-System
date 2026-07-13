import { describe, it, expect } from 'vitest';
import { TemplateValidationService } from '../services/template-validation.service';
import { TEMPLATE_VALIDATION_CODES as C } from '../shared/template-validation.types';

const service = new TemplateValidationService();

function validTemplate(overrides: Record<string, any> = {}): any {
  return {
    category_id: 1,
    code: 'TEST_TEMPLATE_01',
    name_ar: 'قالب اختبار',
    name_en: 'Test Template',
    description: 'A test template',
    engine: 'handlebars',
    default_locale: 'ar',
    default_output_format: 'PDF',
    tags: ['test'],
    versions: [
      {
        version: '1.0.0',
        status: 'DRAFT',
        content: {
          ar: { body: 'مرحبا {{applicant_name}}' },
          en: { body: 'Hello {{applicant_name}}' },
        },
        variable_definitions: [
          {
            code: 'applicant_name',
            name_ar: 'اسم المتقدم',
            name_en: 'Applicant Name',
            type: 'string',
            source_type: 'manual',
            required: true,
            is_active: true,
          },
        ],
      },
    ],
    partials: [],
    ...overrides,
  };
}

describe('TemplateValidationService', () => {
  // ─────────────────────────────────────────────────────────────────
  // Template Structure (TPL-VAL-001 to TPL-VAL-006)
  // ─────────────────────────────────────────────────────────────────

  describe('validateStructure', () => {
    it('passes a fully valid template', () => {
      const result = service.validateTemplate(validTemplate());
      expect(result.isValid).toBe(true);
      expect(result.errors).toHaveLength(0);
    });

    it('reports error when code is empty (TPL-VAL-001)', () => {
      const result = service.validateTemplate(validTemplate({ code: '' }));
      expect(result.errors.some(e => e.code === C.TPL_VAL_001)).toBe(true);
    });

    it('reports error when name_ar is empty (TPL-VAL-001)', () => {
      const result = service.validateTemplate(validTemplate({ name_ar: '' }));
      expect(result.errors.some(e => e.code === C.TPL_VAL_001)).toBe(true);
    });

    it('reports error when name_en is empty (TPL-VAL-001)', () => {
      const result = service.validateTemplate(validTemplate({ name_en: '' }));
      expect(result.errors.some(e => e.code === C.TPL_VAL_001)).toBe(true);
    });

    it('reports error when category_id is missing (TPL-VAL-002)', () => {
      const result = service.validateTemplate(validTemplate({ category_id: 0 }));
      expect(result.errors.some(e => e.code === C.TPL_VAL_002)).toBe(true);
    });

    it('reports error for unsupported output format (TPL-VAL-006)', () => {
      const result = service.validateTemplate(validTemplate({ default_output_format: 'XML' }));
      expect(result.errors.some(e => e.code === C.TPL_VAL_006)).toBe(true);
    });

    it('passes with no versions but produces warning', () => {
      const result = service.validateTemplate(validTemplate({ versions: [] }));
      expect(result.warnings.some(e => e.code === C.TPL_VAL_003)).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // Version Status (TPL-VAL-003, TPL-VAL-005)
  // ─────────────────────────────────────────────────────────────────

  describe('validateVersionStatuses', () => {
    it('passes valid version status values', () => {
      for (const status of ['DRAFT', 'REVIEW', 'APPROVED', 'DEPRECATED', 'ARCHIVED']) {
        const result = service.validateTemplate(validTemplate({
          versions: [{ ...validTemplate().versions[0], status }],
        }));
        expect(result.errors.some(e => e.code === C.TPL_VAL_003)).toBe(false);
      }
    });

    it('reports error for invalid version status (TPL-VAL-003)', () => {
      const result = service.validateTemplate(validTemplate({
        versions: [{ ...validTemplate().versions[0], status: 'PUBLISHED' }],
      }));
      expect(result.errors.some(e => e.code === C.TPL_VAL_003)).toBe(true);
    });

    it('reports error for duplicate version identifiers (TPL-VAL-005)', () => {
      const v = validTemplate().versions[0];
      const result = service.validateTemplate(validTemplate({ versions: [v, { ...v }] }));
      expect(result.errors.some(e => e.code === C.TPL_VAL_005)).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // Variable Definitions (TPL-VAL-010 to TPL-VAL-014)
  // ─────────────────────────────────────────────────────────────────

  describe('validateVariableDefinitions', () => {
    it('passes valid variable definitions', () => {
      const template = validTemplate();
      template.versions[0].variable_definitions = [
        { code: 'name', name_ar: 'الاسم', name_en: 'Name', type: 'string', source_type: 'manual', required: false, is_active: true },
        { code: 'age', name_ar: 'العمر', name_en: 'Age', type: 'number', source_type: 'entity', resolver_path: 'Application.repository.getAge', required: true, is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_010)).toBe(false);
    });

    it('reports error for duplicate variable codes (TPL-VAL-010)', () => {
      const template = validTemplate();
      template.versions[0].variable_definitions = [
        { code: 'dup', name_ar: 'مكرر', name_en: 'Dup', type: 'string', source_type: 'manual', required: false, is_active: true },
        { code: 'dup', name_ar: 'مكرر', name_en: 'Dup', type: 'string', source_type: 'manual', required: false, is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_010)).toBe(true);
    });

    it('reports error for unsupported variable type (TPL-VAL-011)', () => {
      const template = validTemplate();
      template.versions[0].variable_definitions = [
        { code: 'bad', name_ar: 'سيء', name_en: 'Bad', type: 'binary', source_type: 'manual', required: false, is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_011)).toBe(true);
    });

    it('reports warning when required var has no resolver or default (TPL-VAL-012)', () => {
      const template = validTemplate();
      template.versions[0].variable_definitions = [
        { code: 'req', name_ar: 'مطلوب', name_en: 'Required', type: 'string', source_type: 'entity', required: true, is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_012)).toBe(true);
    });

    it('passes when required var has default value (TPL-VAL-012 negative)', () => {
      const template = validTemplate();
      template.versions[0].variable_definitions = [
        { code: 'req', name_ar: 'مطلوب', name_en: 'Required', type: 'string', source_type: 'entity', required: true, default_value: 'N/A', resolver_path: '', is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_012)).toBe(false);
    });

    it('reports error for entity variable missing resolver_path (TPL-VAL-013)', () => {
      const template = validTemplate();
      template.versions[0].variable_definitions = [
        { code: 'entity_var', name_ar: 'كيان', name_en: 'Entity', type: 'string', source_type: 'entity', resolver_path: '', is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_013)).toBe(true);
    });

    it('reports warning for unknown entity whitelist root (TPL-VAL-014)', () => {
      const template = validTemplate();
      template.versions[0].variable_definitions = [
        { code: 'bad_root', name_ar: 'جذر', name_en: 'Root', type: 'string', source_type: 'entity', resolver_path: 'UnknownRepo.method', entity_whitelist_root: 'UnknownRepo', is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_014)).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // Template Content (TPL-VAL-020, TPL-VAL-022, TPL-VAL-023, TPL-VAL-024, TPL-VAL-025)
  // ─────────────────────────────────────────────────────────────────

  describe('validateTemplateContent', () => {
    it('passes when all content variables are defined', () => {
      const template = validTemplate();
      template.versions[0].content = {
        ar: { body: 'مرحبا {{applicant_name}}، رقم {{application_id}}' },
        en: { body: 'Hello {{applicant_name}}, ID {{application_id}}' },
      };
      template.versions[0].variable_definitions = [
        { code: 'applicant_name', name_ar: 'اسم', name_en: 'Name', type: 'string', source_type: 'manual', required: false, is_active: true },
        { code: 'application_id', name_ar: 'رقم', name_en: 'ID', type: 'number', source_type: 'manual', required: false, is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.isValid).toBe(true);
    });

    it('reports warning for undefined variable in content (TPL-VAL-020)', () => {
      const template = validTemplate();
      template.versions[0].content = {
        en: { body: 'Hello {{undefined_var}}' },
      };
      template.versions[0].variable_definitions = [];
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_020)).toBe(true);
    });

    it('reports error for malformed Handlebars syntax (TPL-VAL-022)', () => {
      const template = validTemplate();
      template.versions[0].content = {
        en: { body: 'Hello {{#invalid' },
      };
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_022)).toBe(true);
    });

    it('reports warning for required variable not used in content (TPL-VAL-025)', () => {
      const template = validTemplate();
      template.versions[0].content = {
        en: { body: 'Hello world' },
      };
      template.versions[0].variable_definitions = [
        { code: 'unused_required', name_ar: 'غير مستخدم', name_en: 'Unused', type: 'string', source_type: 'manual', required: true, is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_025)).toBe(true);
    });

    it('passes when required variable IS used in content (TPL-VAL-025 negative)', () => {
      const template = validTemplate();
      template.versions[0].content = {
        en: { body: 'Hello {{used_var}}' },
      };
      template.versions[0].variable_definitions = [
        { code: 'used_var', name_ar: 'مستخدم', name_en: 'Used', type: 'string', source_type: 'manual', required: true, is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_025)).toBe(false);
    });

    it('reports error for empty content object', () => {
      const template = validTemplate();
      template.versions[0].content = {};
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_004)).toBe(true);
    });

    it('reports warning for undefined partial reference', () => {
      const template = validTemplate();
      template.versions[0].content = {
        en: { body: 'Hello {{> missing_partial}}' },
      };
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_020)).toBe(true);
    });

    it('handles multi-field locale content correctly', () => {
      const template = validTemplate();
      template.versions[0].content = {
        ar: { subject: 'تأكيد', body: 'مرحبا {{name}}', footer: 'شكرا' },
        en: { subject: 'Confirmation', body: 'Hello {{name}}', footer: 'Thank you' },
      };
      template.versions[0].variable_definitions = [
        { code: 'name', name_ar: 'اسم', name_en: 'Name', type: 'string', source_type: 'manual', required: false, is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.isValid).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // Function Registry (TPL-VAL-023, TPL-VAL-024, TPL-VAL-040, TPL-VAL-041, TPL-VAL-042)
  // ─────────────────────────────────────────────────────────────────

  describe('validateFunctionRegistry', () => {
    it('passes when using known enabled helpers', () => {
      const template = validTemplate();
      template.versions[0].content = {
        en: { body: '{{formatDate date "YYYY"}} {{upper name}}' },
      };
      template.versions[0].variable_definitions = [
        { code: 'date', name_ar: 'تاريخ', name_en: 'Date', type: 'date', source_type: 'manual', required: false, is_active: true },
        { code: 'name', name_ar: 'اسم', name_en: 'Name', type: 'string', source_type: 'manual', required: false, is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_023)).toBe(false);
      expect(result.errors.some(e => e.code === C.TPL_VAL_024)).toBe(false);
    });

    it('reports error for unknown helper (TPL-VAL-023)', () => {
      const template = validTemplate();
      template.versions[0].content = {
        en: { body: '{{unknownHelper arg}}' },
      };
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_023)).toBe(true);
    });

    it('reports error for forbidden helper (TPL-VAL-024)', () => {
      const template = validTemplate();
      template.versions[0].content = {
        en: { body: '{{eval "code"}}' },
      };
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_024)).toBe(true);
    });

    it('reports error for disabled helper (TPL-VAL-041)', () => {
      const template = validTemplate();
      template.versions[0].content = {
        en: { body: '{{debug arg}}' },
      };
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_041)).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // Resolver References (TPL-VAL-030 to TPL-VAL-032)
  // ─────────────────────────────────────────────────────────────────

  describe('validateResolverReferences', () => {
    it('passes with valid resolver paths', () => {
      const template = validTemplate();
      template.versions[0].variable_definitions = [
        {
          code: 'app_name',
          name_ar: 'اسم',
          name_en: 'Name',
          type: 'string',
          source_type: 'entity',
          resolver_path: 'Application.repository.getName',
          is_active: true,
        },
      ];
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_030)).toBe(false);
    });

    it('reports warning for unknown entity root in resolver path (TPL-VAL-030)', () => {
      const template = validTemplate();
      template.versions[0].variable_definitions = [
        {
          code: 'bad',
          name_ar: 'سيء',
          name_en: 'Bad',
          type: 'string',
          source_type: 'entity',
          resolver_path: 'UnknownRoot.repository.get',
          is_active: true,
        },
      ];
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_030)).toBe(true);
    });

    it('reports warning for resolver path without repository context (TPL-VAL-032)', () => {
      const template = validTemplate();
      template.versions[0].variable_definitions = [
        {
          code: 'short',
          name_ar: 'قصير',
          name_en: 'Short',
          type: 'string',
          source_type: 'entity',
          resolver_path: 'Application',
          is_active: true,
        },
      ];
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_032)).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // Localization (TPL-VAL-050 to TPL-VAL-053)
  // ─────────────────────────────────────────────────────────────────

  describe('validateLocalization', () => {
    it('passes with both ar and en locales having same structure', () => {
      const template = validTemplate();
      template.versions[0].content = {
        ar: { body: 'مرحبا {{name}}', subject: 'تأكيد' },
        en: { body: 'Hello {{name}}', subject: 'Confirmation' },
      };
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_053)).toBe(false);
    });

    it('reports error when default locale is missing (TPL-VAL-053)', () => {
      const template = validTemplate();
      template.versions[0].content = { en: { body: 'Hello' } };
      template.default_locale = 'ar';
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_053)).toBe(true);
    });

    it('reports error when locale has empty content (TPL-VAL-050)', () => {
      const template = validTemplate();
      template.versions[0].content = { ar: {}, en: { body: 'Hello' } };
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_050)).toBe(true);
    });

    it('reports warning when locales have inconsistent fields (TPL-VAL-051)', () => {
      const template = validTemplate();
      template.versions[0].content = {
        ar: { body: 'مرحبا', subject: 'عنوان' },
        en: { body: 'Hello' },
      };
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_051)).toBe(true);
    });

    it('reports warning when locales have inconsistent variables (TPL-VAL-052)', () => {
      const template = validTemplate();
      template.versions[0].content = {
        ar: { body: 'مرحبا {{name}} {{title}}' },
        en: { body: 'Hello {{name}}' },
      };
      template.versions[0].variable_definitions = [
        { code: 'name', name_ar: 'اسم', name_en: 'Name', type: 'string', source_type: 'manual', required: false, is_active: true },
        { code: 'title', name_ar: 'لقب', name_en: 'Title', type: 'string', source_type: 'manual', required: false, is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_052)).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // Version Transition (TPL-VAL-060)
  // ─────────────────────────────────────────────────────────────────

  describe('validateVersionTransition', () => {
    it('passes without transition warnings if no errors', () => {
      const result = service.validateTemplate(validTemplate());
      expect(result.warnings.some(e => e.code === C.TPL_VAL_060)).toBe(false);
    });

    it('reports warning when attempting REVIEW with errors', () => {
      const template = validTemplate();
      template.versions[0].status = 'REVIEW';
      template.versions[0].content = { en: { body: '{{#invalid' } };
      const result = service.validateTemplate(template);
      expect(result.warnings.some(e => e.code === C.TPL_VAL_060)).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // Partial Validation
  // ─────────────────────────────────────────────────────────────────

  describe('validatePartials', () => {
    it('passes valid partials', () => {
      const template = validTemplate({
        partials: [
          {
            code: 'footer_standard',
            name_ar: 'تذييل',
            name_en: 'Footer',
            engine: 'handlebars',
            content: '--- شكرا {{name}} ---',
            is_active: true,
          },
        ],
        versions: [{
          ...validTemplate().versions[0],
          content: { ar: { body: 'مرحبا {{> footer_standard}}' }, en: { body: 'Hello {{> footer_standard}}' } },
        }],
      });
      const result = service.validateTemplate(template);
      expect(result.isValid).toBe(true);
    });

    it('reports error for duplicate partial codes (TPL-VAL-005)', () => {
      const template = validTemplate({
        partials: [
          { code: 'dup', name_ar: 'أ', name_en: 'A', content: 'x', is_active: true },
          { code: 'dup', name_ar: 'ب', name_en: 'B', content: 'y', is_active: true },
        ],
      });
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_005)).toBe(true);
    });

    it('reports error for partial with empty content (TPL-VAL-001)', () => {
      const template = validTemplate({
        partials: [
          { code: 'empty_partial', name_ar: 'فارغ', name_en: 'Empty', content: '', is_active: true },
        ],
      });
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_001)).toBe(true);
    });

    it('reports error for partial with malformed Handlebars (TPL-VAL-022)', () => {
      const template = validTemplate({
        partials: [
          { code: 'bad_partial', name_ar: 'سيء', name_en: 'Bad', content: '{{#invalid', is_active: true },
        ],
      });
      const result = service.validateTemplate(template);
      expect(result.errors.some(e => e.code === C.TPL_VAL_022)).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // validateVersion standalone
  // ─────────────────────────────────────────────────────────────────

  describe('validateVersion', () => {
    it('validates a standalone version object', () => {
      const version = {
        version: '1.0.0',
        status: 'DRAFT',
        content: {
          ar: { body: 'مرحبا {{name}}' },
          en: { body: 'Hello {{name}}' },
        },
        variable_definitions: [
          { code: 'name', name_ar: 'اسم', name_en: 'Name', type: 'string', source_type: 'manual', required: false, is_active: true },
        ],
      };
      const result = service.validateVersion(version);
      expect(result.isValid).toBe(true);
    });

    it('reports error for invalid status in version', () => {
      const version = {
        version: '1.0.0',
        status: 'INVALID_STATUS',
        content: { en: { body: 'Hello' } },
      };
      const result = service.validateVersion(version);
      expect(result.errors.some(e => e.code === C.TPL_VAL_003)).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // validateContent standalone
  // ─────────────────────────────────────────────────────────────────

  describe('validateContent', () => {
    it('passes valid Handlebars content', () => {
      const result = service.validateContent('Hello {{name}}');
      expect(result.isValid).toBe(true);
    });

    it('reports error for invalid Handlebars syntax', () => {
      const result = service.validateContent('Hello {{#invalid');
      expect(result.errors.some(e => e.code === C.TPL_VAL_022)).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // validateVariable standalone
  // ─────────────────────────────────────────────────────────────────

  describe('validateVariable', () => {
    it('passes valid variable definition', () => {
      const result = service.validateVariable({
        code: 'test',
        name_ar: 'اختبار',
        name_en: 'Test',
        type: 'string',
        source_type: 'manual',
        required: false,
      });
      expect(result.isValid).toBe(true);
    });

    it('reports error for unsupported type', () => {
      const result = service.validateVariable({
        code: 'test',
        name_ar: 'اختبار',
        name_en: 'Test',
        type: 'unsupported',
        source_type: 'manual',
        required: false,
      });
      expect(result.errors.some(e => e.code === C.TPL_VAL_011)).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // Error Catalog
  // ─────────────────────────────────────────────────────────────────

  describe('getErrorCatalog', () => {
    it('returns a non-empty catalog of error codes', () => {
      const catalog = TemplateValidationService.getErrorCatalog();
      expect(catalog.length).toBeGreaterThan(20);
      const codes = catalog.map(c => c.code);
      expect(codes).toContain(C.TPL_VAL_001);
      expect(codes).toContain(C.TPL_VAL_024);
      expect(codes).toContain(C.TPL_VAL_053);
      expect(codes).toContain(C.TPL_VAL_060);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // Integration: Full real-world template validation
  // ─────────────────────────────────────────────────────────────────

  describe('real-world template validation', () => {
    it('validates a realistic protocol approval template', () => {
      const template = {
        category_id: 1,
        code: 'PROTOCOL_APPROVAL_LETTER',
        name_ar: 'خطاب الموافقة على البروتوكول',
        name_en: 'Protocol Approval Letter',
        engine: 'handlebars',
        default_locale: 'ar',
        default_output_format: 'PDF',
        tags: ['protocol', 'approval'],
        versions: [
          {
            version: '1.0.0',
            status: 'DRAFT',
            content: {
              ar: {
                subject: 'موافقة على البروتوكول رقم {{protocol_number}}',
                body: '{{> header_standard}}\n\nسعادة {{applicant_name}} المحترم،\n\nنفيدكم بموافقة اللجنة على البروتوكول رقم {{protocol_number}} بتاريخ {{approval_date}}.\n\n{{> footer_standard}}',
              },
              en: {
                subject: 'Protocol Approval No. {{protocol_number}}',
                body: '{{> header_standard}}\n\nDear {{applicant_name}},\n\nWe are pleased to inform you that the committee has approved Protocol No. {{protocol_number}} dated {{approval_date}}.\n\n{{> footer_standard}}',
              },
            },
            variable_definitions: [
              { code: 'applicant_name', name_ar: 'اسم المتقدم', name_en: 'Applicant Name', type: 'string', source_type: 'entity', resolver_path: 'Application.repository.getApplicantName', required: true, is_active: true },
              { code: 'protocol_number', name_ar: 'رقم البروتوكول', name_en: 'Protocol Number', type: 'string', source_type: 'entity', resolver_path: 'Application.repository.getProtocolNumber', required: true, is_active: true },
              { code: 'approval_date', name_ar: 'تاريخ الموافقة', name_en: 'Approval Date', type: 'date', source_type: 'computed', resolver_path: 'Application.repository.getApprovalDate', required: true, is_active: true },
            ],
          },
        ],
        partials: [
          { code: 'header_standard', name_ar: 'رأس قياسي', name_en: 'Standard Header', engine: 'handlebars', content: '--- رأس الخطاب الرسمي ---', is_active: true },
          { code: 'footer_standard', name_ar: 'تذييل قياسي', name_en: 'Standard Footer', engine: 'handlebars', content: '--- نهاية الخطاب ---', is_active: true },
        ],
      };

      const result = service.validateTemplate(template);
      // Should be valid because partials are defined
      expect(result.isValid).toBe(true);
    });

    it('validates an email notification template with conditional block', () => {
      const template = {
        category_id: 2,
        code: 'SUBMISSION_CONFIRMATION',
        name_ar: 'تأكيد تقديم الطلب',
        name_en: 'Submission Confirmation',
        engine: 'handlebars',
        default_locale: 'ar',
        default_output_format: 'EMAIL',
        tags: ['notification'],
        versions: [
          {
            version: '1.0.0',
            status: 'DRAFT',
            content: {
              ar: {
                subject: 'تأكيد تقديم الطلب رقم {{application_id}}',
                body: 'عزيزي {{applicant_name}}،\n\nتم استلام طلبك رقم {{application_id}} بنجاح.\n{{#if needs_review}}\nسيتم مراجعة طلبك من قبل اللجنة.\n{{/if}}',
              },
              en: {
                subject: 'Submission Confirmation #{{application_id}}',
                body: 'Dear {{applicant_name}},\n\nYour application #{{application_id}} has been received successfully.\n{{#if needs_review}}\nYour application will be reviewed by the committee.\n{{/if}}',
              },
            },
            variable_definitions: [
              { code: 'applicant_name', name_ar: 'اسم', name_en: 'Name', type: 'string', source_type: 'manual', required: true, is_active: true },
              { code: 'application_id', name_ar: 'رقم', name_en: 'ID', type: 'number', source_type: 'manual', required: true, is_active: true },
              { code: 'needs_review', name_ar: 'بحاجة مراجعة', name_en: 'Needs Review', type: 'boolean', source_type: 'manual', required: false, is_active: true },
            ],
          },
        ],
        partials: [],
      };

      const result = service.validateTemplate(template);
      expect(result.isValid).toBe(true);
    });

    it('rejects template with forbidden helper', () => {
      const template = validTemplate();
      template.versions[0].content = {
        en: { body: '{{exec "rm -rf /"}}' },
      };
      const result = service.validateTemplate(template);
      expect(result.isValid).toBe(false);
      expect(result.errors.some(e => e.code === C.TPL_VAL_024)).toBe(true);
    });

    it('rejects template with multiple errors', () => {
      const template = validTemplate({
        code: '',
        name_ar: '',
        default_output_format: 'XML',
        versions: [
          {
            version: '1.0.0',
            status: 'INVALID',
            content: { en: { body: '{{#bad' } },
            variable_definitions: [
              { code: 'dup', name_ar: 'أ', name_en: 'A', type: 'string', source_type: 'manual', required: false, is_active: true },
              { code: 'dup', name_ar: 'ب', name_en: 'B', type: 'string', source_type: 'manual', required: false, is_active: true },
              { code: 'bad_type', name_ar: 'ج', name_en: 'C', type: 'unsupported', source_type: 'manual', required: false, is_active: true },
            ],
          },
        ],
      });
      const result = service.validateTemplate(template);
      expect(result.errors.length).toBeGreaterThanOrEqual(4);
      expect(result.errors.some(e => e.code === C.TPL_VAL_001)).toBe(true);
      expect(result.errors.some(e => e.code === C.TPL_VAL_006)).toBe(true);
      expect(result.errors.some(e => e.code === C.TPL_VAL_003)).toBe(true);
      expect(result.errors.some(e => e.code === C.TPL_VAL_022)).toBe(true);
      expect(result.errors.some(e => e.code === C.TPL_VAL_010)).toBe(true);
      expect(result.errors.some(e => e.code === C.TPL_VAL_011)).toBe(true);
    });
  });

  // ─────────────────────────────────────────────────────────────────
  // Handlebars AST: if/unless/each block helpers should not trigger errors
  // ─────────────────────────────────────────────────────────────────

  describe('Handlebars built-in helpers', () => {
    it('passes with if/unless/each/with blocks', () => {
      const template = validTemplate();
      template.versions[0].content = {
        ar: {
          body: '{{#if flag}}نشط{{/if}}{{#unless flag}}غير نشط{{/unless}}{{#each items}}{{this}}{{/each}}{{#with context}}{{name}}{{/with}}',
        },
        en: {
          body: '{{#if flag}}Active{{/if}}{{#unless flag}}Inactive{{/unless}}{{#each items}}{{this}}{{/each}}{{#with context}}{{name}}{{/with}}',
        },
      };
      template.versions[0].variable_definitions = [
        { code: 'flag', name_ar: 'علامة', name_en: 'Flag', type: 'boolean', source_type: 'manual', required: false, is_active: true },
        { code: 'items', name_ar: 'عناصر', name_en: 'Items', type: 'array', source_type: 'manual', required: false, is_active: true },
        { code: 'context', name_ar: 'سياق', name_en: 'Context', type: 'object', source_type: 'manual', required: false, is_active: true },
        { code: 'name', name_ar: 'اسم', name_en: 'Name', type: 'string', source_type: 'manual', required: false, is_active: true },
      ];
      const result = service.validateTemplate(template);
      expect(result.isValid).toBe(true);
    });
  });
});
