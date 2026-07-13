export type HelperCategory = 'builtin' | 'formatting' | 'conditional' | 'math' | 'date' | 'localization' | 'string' | 'array' | 'deprecated' | 'forbidden';

export interface RegistryEntry {
  name: string;
  category: HelperCategory;
  enabled: boolean;
  description: string;
  signature?: string;
}

const BUILTIN_HELPERS: RegistryEntry[] = [
  { name: 'if', category: 'builtin', enabled: true, description: 'Conditional block helper', signature: '{{#if condition}}...{{/if}}' },
  { name: 'unless', category: 'builtin', enabled: true, description: 'Negated conditional block', signature: '{{#unless condition}}...{{/unless}}' },
  { name: 'each', category: 'builtin', enabled: true, description: 'Iterator block helper', signature: '{{#each array}}...{{/each}}' },
  { name: 'with', category: 'builtin', enabled: true, description: 'Context block helper', signature: '{{#with context}}...{{/with}}' },
  { name: 'lookup', category: 'builtin', enabled: true, description: 'Dynamic property access', signature: '{{lookup obj key}}' },
  { name: 'log', category: 'builtin', enabled: true, description: 'Debug logging helper', signature: '{{log value}}' },
];

const CUSTOM_HELPERS: RegistryEntry[] = [
  { name: 'formatDate', category: 'date', enabled: true, description: 'Format a date value', signature: '{{formatDate date "YYYY-MM-DD"}}' },
  { name: 'formatNumber', category: 'math', enabled: true, description: 'Format a number with locale', signature: '{{formatNumber value decimals}}' },
  { name: 'localize', category: 'localization', enabled: true, description: 'Localize a string key', signature: '{{localize key locale}}' },
  { name: 'upper', category: 'string', enabled: true, description: 'Uppercase a string', signature: '{{upper str}}' },
  { name: 'lower', category: 'string', enabled: true, description: 'Lowercase a string', signature: '{{lower str}}' },
  { name: 'capitalize', category: 'string', enabled: true, description: 'Capitalize first letter', signature: '{{capitalize str}}' },
  { name: 'concat', category: 'string', enabled: true, description: 'Concatenate strings', signature: '{{concat a b}}' },
  { name: 'default', category: 'formatting', enabled: true, description: 'Default value if falsy', signature: '{{default value fallback}}' },
  { name: 'eq', category: 'conditional', enabled: true, description: 'Equality comparison', signature: '{{#if (eq a b)}}...{{/if}}' },
  { name: 'neq', category: 'conditional', enabled: true, description: 'Inequality comparison', signature: '{{#if (neq a b)}}...{{/if}}' },
  { name: 'gt', category: 'conditional', enabled: true, description: 'Greater than', signature: '{{#if (gt a b)}}...{{/if}}' },
  { name: 'gte', category: 'conditional', enabled: true, description: 'Greater than or equal', signature: '{{#if (gte a b)}}...{{/if}}' },
  { name: 'lt', category: 'conditional', enabled: true, description: 'Less than', signature: '{{#if (lt a b)}}...{{/if}}' },
  { name: 'lte', category: 'conditional', enabled: true, description: 'Less than or equal', signature: '{{#if (lte a b)}}...{{/if}}' },
  { name: 'and', category: 'conditional', enabled: true, description: 'Logical AND', signature: '{{#if (and a b)}}...{{/if}}' },
  { name: 'or', category: 'conditional', enabled: true, description: 'Logical OR', signature: '{{#if (or a b)}}...{{/if}}' },
  { name: 'not', category: 'conditional', enabled: true, description: 'Logical NOT', signature: '{{#if (not x)}}...{{/if}}' },
  { name: 'math', category: 'math', enabled: true, description: 'Math operation', signature: '{{math a "+" b}}' },
  { name: 'array', category: 'array', enabled: true, description: 'Create array', signature: '{{array a b c}}' },
  { name: 'first', category: 'array', enabled: true, description: 'First element', signature: '{{first array}}' },
  { name: 'last', category: 'array', enabled: true, description: 'Last element', signature: '{{last array}}' },
  { name: 'join', category: 'array', enabled: true, description: 'Join array into string', signature: '{{join array ","}}' },
  { name: 'length', category: 'array', enabled: true, description: 'Array length', signature: '{{length array}}' },
  { name: 'slice', category: 'array', enabled: true, description: 'Slice array', signature: '{{slice array start end}}' },
  { name: 'truncate', category: 'string', enabled: true, description: 'Truncate string', signature: '{{truncate str maxLength}}' },
  { name: 'nl2br', category: 'formatting', enabled: true, description: 'Newlines to <br>', signature: '{{nl2br str}}' },
  { name: 'safeHtml', category: 'formatting', enabled: true, description: 'Mark string as safe HTML', signature: '{{safeHtml str}}' },
];

const DEPRECATED_HELPERS: RegistryEntry[] = [
  { name: 'debug', category: 'deprecated', enabled: false, description: 'Debug helper (deprecated)' },
  { name: 'evalExpr', category: 'deprecated', enabled: false, description: 'Evaluate expression (deprecated)' },
];

const FORBIDDEN_HELPERS: RegistryEntry[] = [
  { name: 'eval', category: 'forbidden', enabled: false, description: 'Arbitrary code execution' },
  { name: 'require', category: 'forbidden', enabled: false, description: 'Module require' },
  { name: 'import', category: 'forbidden', enabled: false, description: 'Module import' },
  { name: 'fetch', category: 'forbidden', enabled: false, description: 'HTTP fetch' },
  { name: 'readFile', category: 'forbidden', enabled: false, description: 'File system read' },
  { name: 'writeFile', category: 'forbidden', enabled: false, description: 'File system write' },
  { name: 'exec', category: 'forbidden', enabled: false, description: 'Command execution' },
  { name: 'spawn', category: 'forbidden', enabled: false, description: 'Process spawn' },
  { name: 'process', category: 'forbidden', enabled: false, description: 'Process access' },
];

const ALL_REGISTRY_ENTRIES: RegistryEntry[] = [
  ...BUILTIN_HELPERS,
  ...CUSTOM_HELPERS,
  ...DEPRECATED_HELPERS,
  ...FORBIDDEN_HELPERS,
];

const REGISTRY_MAP = new Map<string, RegistryEntry>(ALL_REGISTRY_ENTRIES.map(e => [e.name, e]));

export class FunctionRegistry {
  static get(name: string): RegistryEntry | undefined {
    return REGISTRY_MAP.get(name);
  }

  static isEnabled(name: string): boolean {
    const entry = REGISTRY_MAP.get(name);
    return !!entry?.enabled;
  }

  static isForbidden(name: string): boolean {
    const entry = REGISTRY_MAP.get(name);
    return entry?.category === 'forbidden';
  }

  static isRegistered(name: string): boolean {
    return REGISTRY_MAP.has(name);
  }

  static getAllEnabled(): RegistryEntry[] {
    return ALL_REGISTRY_ENTRIES.filter(e => e.enabled);
  }

  static getAllKnown(): RegistryEntry[] {
    return ALL_REGISTRY_ENTRIES;
  }

  static getAllHelpersByCategory(category: HelperCategory): RegistryEntry[] {
    return ALL_REGISTRY_ENTRIES.filter(e => e.category === category);
  }

  static getEnabledHelperNames(): Set<string> {
    return new Set(ALL_REGISTRY_ENTRIES.filter(e => e.enabled).map(e => e.name));
  }

  static getForbiddenHelperNames(): Set<string> {
    return new Set(FORBIDDEN_HELPERS.map(e => e.name));
  }
}

export const VALID_ENTITY_ROOTS = [
  'Application',
  'Condition',
  'User',
  'Committee',
  'Institution',
  'Notification',
  'Document',
  'Meeting',
  'Review',
  'Report',
  'Communication',
  'SafetyReport',
];
