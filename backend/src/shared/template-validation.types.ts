export const TEMPLATE_VALIDATION_CODES = {
  // Structure (001-009)
  TPL_VAL_001: 'TPL-VAL-001',
  TPL_VAL_002: 'TPL-VAL-002',
  TPL_VAL_003: 'TPL-VAL-003',
  TPL_VAL_004: 'TPL-VAL-004',
  TPL_VAL_005: 'TPL-VAL-005',
  TPL_VAL_006: 'TPL-VAL-006',

  // Variables (010-019)
  TPL_VAL_010: 'TPL-VAL-010',
  TPL_VAL_011: 'TPL-VAL-011',
  TPL_VAL_012: 'TPL-VAL-012',
  TPL_VAL_013: 'TPL-VAL-013',
  TPL_VAL_014: 'TPL-VAL-014',
  TPL_VAL_015: 'TPL-VAL-015',

  // Content (020-029)
  TPL_VAL_020: 'TPL-VAL-020',
  TPL_VAL_021: 'TPL-VAL-021',
  TPL_VAL_022: 'TPL-VAL-022',
  TPL_VAL_023: 'TPL-VAL-023',
  TPL_VAL_024: 'TPL-VAL-024',
  TPL_VAL_025: 'TPL-VAL-025',

  // Resolver references (030-039)
  TPL_VAL_030: 'TPL-VAL-030',
  TPL_VAL_031: 'TPL-VAL-031',
  TPL_VAL_032: 'TPL-VAL-032',
  TPL_VAL_033: 'TPL-VAL-033',

  // Function registry (040-049)
  TPL_VAL_040: 'TPL-VAL-040',
  TPL_VAL_041: 'TPL-VAL-041',
  TPL_VAL_042: 'TPL-VAL-042',

  // Localization (050-059)
  TPL_VAL_050: 'TPL-VAL-050',
  TPL_VAL_051: 'TPL-VAL-051',
  TPL_VAL_052: 'TPL-VAL-052',
  TPL_VAL_053: 'TPL-VAL-053',

  // Version transitions (060-069)
  TPL_VAL_060: 'TPL-VAL-060',
  TPL_VAL_061: 'TPL-VAL-061',

  // Lifecycle validation (062-069)
  TPL_VAL_062: 'TPL-VAL-062',
  TPL_VAL_063: 'TPL-VAL-063',
  TPL_VAL_064: 'TPL-VAL-064',
  TPL_VAL_065: 'TPL-VAL-065',
  TPL_VAL_066: 'TPL-VAL-066',
  TPL_VAL_067: 'TPL-VAL-067',
  TPL_VAL_068: 'TPL-VAL-068',
} as const;

export type ValidationCode = (typeof TEMPLATE_VALIDATION_CODES)[keyof typeof TEMPLATE_VALIDATION_CODES];

export type ValidationSeverity = 'ERROR' | 'WARNING' | 'INFO';

export interface ValidationItem {
  code: ValidationCode;
  severity: ValidationSeverity;
  message: string;
  affectedField: string;
  suggestedResolution: string;
}

export interface ValidationResult {
  isValid: boolean;
  items: ValidationItem[];
  errors: ValidationItem[];
  warnings: ValidationItem[];
  infos: ValidationItem[];
  templateCode?: string;
  templateVersion?: string;
  validatedAt: Date;
}

export const SUPPORTED_VARIABLE_TYPES = ['string', 'number', 'date', 'boolean', 'array', 'object', 'enum'] as const;
export type VariableType = (typeof SUPPORTED_VARIABLE_TYPES)[number];

export const SUPPORTED_SOURCE_TYPES = ['manual', 'entity', 'computed', 'context'] as const;
export type SourceType = (typeof SUPPORTED_SOURCE_TYPES)[number];

export const SUPPORTED_OUTPUT_FORMATS = ['PDF', 'EMAIL', 'HTML', 'DOCX'] as const;
export type OutputFormat = (typeof SUPPORTED_OUTPUT_FORMATS)[number];

export const VALID_VERSION_STATUSES = ['DRAFT', 'REVIEW', 'APPROVED', 'DEPRECATED', 'ARCHIVED'] as const;
export type VersionStatus = (typeof VALID_VERSION_STATUSES)[number];

export const SUPPORTED_LOCALES = ['ar', 'en'] as const;
export type Locale = (typeof SUPPORTED_LOCALES)[number];

export const SUPPORTED_ENGINES = ['handlebars'] as const;
export type TemplateEngine = (typeof SUPPORTED_ENGINES)[number];
