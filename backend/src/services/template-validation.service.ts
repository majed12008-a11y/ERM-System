import Handlebars from 'handlebars';
import {
  ValidationCode,
  ValidationItem,
  ValidationResult,
  ValidationSeverity,
  TEMPLATE_VALIDATION_CODES as C,
  SUPPORTED_VARIABLE_TYPES,
  SUPPORTED_OUTPUT_FORMATS,
  VALID_VERSION_STATUSES,
  SUPPORTED_LOCALES,
} from '../shared/template-validation.types';
import { FunctionRegistry, VALID_ENTITY_ROOTS } from '../shared/template-function-registry';

interface TemplateInput {
  id?: number;
  category_id: number;
  code: string;
  name_ar: string;
  name_en: string;
  description?: string;
  engine?: string;
  default_locale?: string;
  default_output_format?: string;
  variable_sources?: any;
  tags?: string[];
  is_active?: boolean;
  versions?: TemplateVersionInput[];
  partials?: PartialInput[];
}

interface TemplateVersionInput {
  id?: number;
  template_id?: number;
  version: string;
  status: string;
  content: Record<string, Record<string, string>>;
  content_hash?: string;
  variable_definitions?: VariableDefInput[];
  change_summary?: string;
  effective_from?: string;
  effective_until?: string;
  created_by?: number;
}

interface VariableDefInput {
  code: string;
  name_ar: string;
  name_en: string;
  type: string;
  enum_values?: string[];
  source_type: string;
  resolver_path?: string;
  resolver_function?: string;
  resolver_function_args?: any;
  entity_whitelist_root?: string;
  default_value?: any;
  description_ar?: string;
  description_en?: string;
  required?: boolean;
  validation_rules?: any;
  is_active?: boolean;
}

interface PartialInput {
  code: string;
  name_ar: string;
  name_en: string;
  engine?: string;
  content: string;
  content_hash?: string;
  version?: number;
  depends_on?: string[];
  is_active?: boolean;
}

interface ParsedVariable {
  name: string;
  parts: string[];
  isHelper: boolean;
  helperName?: string;
}

interface ContentAnalysis {
  variableNames: Set<string>;
  helperNames: Set<string>;
  partialNames: Set<string>;
  syntaxError?: string;
}

export class TemplateValidationService {
  private items: ValidationItem[] = [];

  private addItem(
    code: ValidationCode,
    severity: ValidationSeverity,
    message: string,
    affectedField: string,
    suggestedResolution: string,
  ): void {
    this.items.push({ code, severity, message, affectedField, suggestedResolution });
  }

  private error(code: ValidationCode, message: string, affectedField: string, suggestedResolution: string): void {
    this.addItem(code, 'ERROR', message, affectedField, suggestedResolution);
  }

  private warning(code: ValidationCode, message: string, affectedField: string, suggestedResolution: string): void {
    this.addItem(code, 'WARNING', message, affectedField, suggestedResolution);
  }

  private info(code: ValidationCode, message: string, affectedField: string, suggestedResolution: string): void {
    this.addItem(code, 'INFO', message, affectedField, suggestedResolution);
  }

  private buildResult(templateCode?: string, templateVersion?: string): ValidationResult {
    const errors = this.items.filter(i => i.severity === 'ERROR');
    const warnings = this.items.filter(i => i.severity === 'WARNING');
    const infos = this.items.filter(i => i.severity === 'INFO');
    return {
      isValid: errors.length === 0,
      items: this.items,
      errors,
      warnings,
      infos,
      templateCode,
      templateVersion,
      validatedAt: new Date(),
    };
  }

  private parseTemplateContent(content: string): ContentAnalysis {
    const variableNames = new Set<string>();
    const helperNames = new Set<string>();
    const partialNames = new Set<string>();

    try {
      const ast = Handlebars.parse(content);

      const walk = (node: any): void => {
        if (!node || typeof node !== 'object') return;

        if (node.type === 'MustacheStatement' || node.type === 'EscapedMustacheStatement' || node.type === 'UnescapedMustacheStatement') {
          if (node.path) {
            if (node.path.type === 'PathExpression') {
              const parts = node.path.parts || node.path.deepParts || [];
              if (parts.length > 0) {
                const first = parts[0];
                if (node.path.data === true) {
                  return;
                }
                if (node.params && node.params.length > 0) {
                  helperNames.add(first);
                  node.params.forEach(walk);
                } else {
                  variableNames.add(node.path.original || first);
                  if (parts.length > 1) {
                    variableNames.add(parts[0]);
                  }
                }
              }
            }
            if (node.path.type === 'SubExpression') {
              if (node.path.path) {
                const subName = typeof node.path.path === 'string' ? node.path.path : node.path.path.original;
                if (subName) helperNames.add(subName);
              }
              (node.path.params || []).forEach(walk);
            }
          }
          if (node.hash) {
            (node.hash.pairs || []).forEach((p: any) => walk(p.value));
          }
        }

        if (node.type === 'BlockStatement' || node.type === 'DecoratorBlock') {
          if (node.path) {
            if (node.path.type === 'PathExpression') {
              const name = node.path.original || (node.path.parts && node.path.parts[0]) || '';
              if (name.startsWith('#')) {
                helperNames.add(name.slice(1));
              } else {
                helperNames.add(name);
              }
            }
          }
          (node.params || []).forEach(walk);
          if (node.hash) {
            (node.hash.pairs || []).forEach((p: any) => walk(p.value));
          }
          if (node.program) {
            (node.program.body || []).forEach(walk);
          }
          if (node.inverse) {
            (node.inverse.body || []).forEach(walk);
          }
        }

        if (node.type === 'PartialStatement' || node.type === 'UnescapedPartialStatement' || node.type === 'PartialBlockStatement') {
          if (node.name) {
            const partialName = typeof node.name === 'string' ? node.name : node.name.original;
            if (partialName) partialNames.add(partialName);
          }
        }

        if (node.type === 'SubExpression') {
          if (node.path) {
            const subName = typeof node.path === 'string' ? node.path : node.path.original;
            if (subName && subName !== 'lookup') helperNames.add(subName);
          }
          (node.params || []).forEach(walk);
        }

        if (Array.isArray(node.body)) {
          node.body.forEach(walk);
        }
      };

      if (ast && ast.body) {
        ast.body.forEach(walk);
      }
    } catch (err: any) {
      return { variableNames, helperNames, partialNames, syntaxError: err.message };
    }

    return { variableNames, helperNames, partialNames };
  }

  private analyzeContent(versionContent: Record<string, Record<string, string>>): Map<string, ContentAnalysis> {
    const localeAnalyses = new Map<string, ContentAnalysis>();

    for (const [locale, fields] of Object.entries(versionContent)) {
      if (!fields || typeof fields !== 'object') continue;
      const combinedNames = new Set<string>();
      const combinedHelpers = new Set<string>();
      const combinedPartials = new Set<string>();
      let globalSyntaxError: string | undefined;

      for (const [fieldName, fieldContent] of Object.entries(fields)) {
        if (typeof fieldContent !== 'string' || !fieldContent.trim()) continue;
        const analysis = this.parseTemplateContent(fieldContent);
        if (analysis.syntaxError) {
          globalSyntaxError = `${fieldName}: ${analysis.syntaxError}`;
        }
        analysis.variableNames.forEach(v => combinedNames.add(v));
        analysis.helperNames.forEach(h => combinedHelpers.add(h));
        analysis.partialNames.forEach(p => combinedPartials.add(p));
      }

      localeAnalyses.set(locale, {
        variableNames: combinedNames,
        helperNames: combinedHelpers,
        partialNames: combinedPartials,
        syntaxError: globalSyntaxError,
      });
    }

    return localeAnalyses;
  }

  private extractRequiredVariables(variableDefinitions: VariableDefInput[]): string[] {
    return variableDefinitions.filter(v => v.required).map(v => v.code);
  }

  private extractVariableCodes(variableDefinitions: VariableDefInput[]): string[] {
    return variableDefinitions.filter(v => v.is_active !== false).map(v => v.code);
  }

  private getPartialsForVersion(versionContent: Record<string, Record<string, string>>, partials: PartialInput[]): PartialInput[] {
    const referencedPartialNames = new Set<string>();
    for (const fields of Object.values(versionContent)) {
      for (const content of Object.values(fields)) {
        if (typeof content === 'string') {
          const analysis = this.parseTemplateContent(content);
          analysis.partialNames.forEach(p => referencedPartialNames.add(p));
        }
      }
    }
    return partials.filter(p => referencedPartialNames.has(p.code));
  }

  // ─── Template Structure Validator ──────────────────────────────────

  private validateStructure(template: TemplateInput): void {
    if (!template.code || !template.code.trim()) {
      this.error(C.TPL_VAL_001, 'Template code is required', 'code', 'Provide a unique UPPER_SNAKE_CASE code');
    }
    if (!template.name_ar || !template.name_ar.trim()) {
      this.error(C.TPL_VAL_001, 'Arabic name is required', 'name_ar', 'Provide the template name in Arabic');
    }
    if (!template.name_en || !template.name_en.trim()) {
      this.error(C.TPL_VAL_001, 'English name is required', 'name_en', 'Provide the template name in English');
    }
    if (!template.category_id || template.category_id <= 0) {
      this.error(C.TPL_VAL_002, 'Category ID is required and must be positive', 'category_id', 'Assign a valid category ID from the template_categories table');
    }

    if (template.default_output_format && !SUPPORTED_OUTPUT_FORMATS.includes(template.default_output_format as any)) {
      this.error(C.TPL_VAL_006, `Unsupported output format: ${template.default_output_format}`, 'default_output_format', `Must be one of: ${SUPPORTED_OUTPUT_FORMATS.join(', ')}`);
    }

    if (template.engine && !['handlebars'].includes(template.engine)) {
      this.warning(C.TPL_VAL_003, `Unsupported template engine: ${template.engine}`, 'engine', 'Only handlebars engine is currently supported');
    }

    if (!template.versions || template.versions.length === 0) {
      this.warning(C.TPL_VAL_003, 'Template has no versions', 'versions', 'Add at least one template version with DRAFT status');
    }
  }

  // ─── Version Status Validator ──────────────────────────────────────

  private validateVersionStatuses(versions: TemplateVersionInput[]): void {
    for (const v of versions) {
      if (!VALID_VERSION_STATUSES.includes(v.status as any)) {
        this.error(C.TPL_VAL_003, `Invalid version status "${v.status}" for version ${v.version}`, `versions[${v.version}].status`, `Must be one of: ${VALID_VERSION_STATUSES.join(', ')}`);
      }
    }

    const duplicateVersions = new Set<string>();
    const seen = new Set<string>();
    for (const v of versions) {
      if (seen.has(v.version)) {
        duplicateVersions.add(v.version);
      }
      seen.add(v.version);
    }
    for (const dup of duplicateVersions) {
      this.error(C.TPL_VAL_005, `Duplicate version identifier: ${dup}`, 'versions', 'Each version must have a unique semver identifier');
    }
  }

  // ─── Variable Definitions Validator ────────────────────────────────

  private validateVariableDefinitions(variableDefinitions: VariableDefInput[]): void {
    const seenCodes = new Set<string>();
    const duplicateCodes = new Set<string>();

    for (const v of variableDefinitions) {
      if (seenCodes.has(v.code)) {
        duplicateCodes.add(v.code);
      }
      seenCodes.add(v.code);
    }

    for (const dup of duplicateCodes) {
      this.error(C.TPL_VAL_010, `Duplicate variable code: "${dup}"`, 'variable_definitions', 'Each variable code must be unique within the template version');
    }

    for (const v of variableDefinitions) {
      if (!SUPPORTED_VARIABLE_TYPES.includes(v.type as any)) {
        this.error(C.TPL_VAL_011, `Unsupported variable type "${v.type}" for "${v.code}"`, `variable_definitions[${v.code}].type`, `Must be one of: ${SUPPORTED_VARIABLE_TYPES.join(', ')}`);
      }

      if (v.required && !v.resolver_path && v.default_value === undefined && v.source_type !== 'manual') {
        this.warning(C.TPL_VAL_012, `Required variable "${v.code}" has no resolver path or default value`, `variable_definitions[${v.code}]`, 'Provide a resolver_path or default_value for required variables');
      }

      if ((v.source_type === 'entity' || v.source_type === 'computed') && (!v.resolver_path || !v.resolver_path.trim())) {
        this.error(C.TPL_VAL_013, `Variable "${v.code}" has source_type "${v.source_type}" but no resolver_path`, `variable_definitions[${v.code}].resolver_path`, 'Provide a resolver_path for entity/computed variables');
      }

      if (v.entity_whitelist_root && !VALID_ENTITY_ROOTS.includes(v.entity_whitelist_root)) {
        this.warning(C.TPL_VAL_014, `Variable "${v.code}" references unknown entity root "${v.entity_whitelist_root}"`, `variable_definitions[${v.code}].entity_whitelist_root`, `Valid roots: ${VALID_ENTITY_ROOTS.join(', ')}`);
      }
    }
  }

  // ─── Resolver Reference Validator ──────────────────────────────────

  private validateResolverReferences(variableDefinitions: VariableDefInput[]): void {
    for (const v of variableDefinitions) {
      if (v.resolver_path && v.resolver_path.trim()) {
        const parts = v.resolver_path.split('.');
        const root = parts[0];
        if (root && !VALID_ENTITY_ROOTS.includes(root)) {
          this.warning(C.TPL_VAL_030, `Resolver path "${v.resolver_path}" for "${v.code}" references unknown entity root "${root}"`, `variable_definitions[${v.code}].resolver_path`, `Root must be one of: ${VALID_ENTITY_ROOTS.join(', ')}`);
        }

        if (parts.length < 2) {
          this.warning(C.TPL_VAL_032, `Resolver path "${v.resolver_path}" for "${v.code}" should include repository context`, `variable_definitions[${v.code}].resolver_path`, 'Use format: EntityRoot.repository.method');
        }
      }

      if (v.resolver_function && v.resolver_function.trim()) {
        const funcName = v.resolver_function.includes('.') ? v.resolver_function.split('.').pop()! : v.resolver_function;
        if (!FunctionRegistry.isRegistered(funcName) && !FunctionRegistry.isRegistered(v.resolver_function)) {
          this.warning(C.TPL_VAL_031, `Resolver function "${v.resolver_function}" for "${v.code}" is not in the function registry`, `variable_definitions[${v.code}].resolver_function`, 'Register the function in TemplateFunctionRegistry or use a known helper');
        }
      }
    }
  }

  // ─── Template Content Validator ────────────────────────────────────

  private validateTemplateContent(
    version: TemplateVersionInput,
    allPartials: PartialInput[],
  ): void {
    const content = version.content;
    if (!content || typeof content !== 'object') {
      this.error(C.TPL_VAL_022, 'Version content is empty or invalid', 'content', 'Provide content as a locale-keyed object (e.g. { ar: { body: "..." }, en: { body: "..." } })');
      return;
    }

    const definedVariables = this.extractVariableCodes(version.variable_definitions || []);
    const definedVariableSet = new Set(definedVariables);
    const requiredVariables = this.extractRequiredVariables(version.variable_definitions || []);
    const localeAnalyses = this.analyzeContent(content);

    for (const [locale, analysis] of localeAnalyses) {
      if (analysis.syntaxError) {
        this.error(C.TPL_VAL_022, `${locale}: Malformed Handlebars syntax - ${analysis.syntaxError}`, `content.${locale}`, 'Fix the Handlebars syntax error');
      }

      for (const varName of analysis.variableNames) {
        const cleanName = varName.replace(/^@/, '');
        if (cleanName.startsWith('this') || cleanName.startsWith('@')) {
          continue;
        }
        if (!definedVariableSet.has(cleanName) && !analysis.helperNames.has(cleanName)) {
          this.warning(C.TPL_VAL_020, `${locale}: Variable "{{${varName}}}" is used but not defined in variable_definitions`, `content.${locale}`, `Add a variable definition for "${varName}" or remove the placeholder from the content`);
        }
      }

      for (const requiredVar of requiredVariables) {
        let found = false;
        for (const analysis of localeAnalyses.values()) {
          for (const vn of analysis.variableNames) {
            if (vn === requiredVar || vn.startsWith(requiredVar + '.')) {
              found = true;
              break;
            }
          }
          if (found) break;
        }
        if (!found) {
          this.warning(C.TPL_VAL_025, `Required variable "${requiredVar}" is not used in any locale content`, 'variable_definitions', `Either use "${requiredVar}" in the content or mark it as not required`);
        }
      }

      for (const helperName of analysis.helperNames) {
        if (!FunctionRegistry.isRegistered(helperName)) {
          this.error(C.TPL_VAL_023, `${locale}: Unknown helper "{{${helperName}}}" is not in the function registry`, `content.${locale}`, `Register the helper "${helperName}" or use a known helper`);
        } else if (FunctionRegistry.isForbidden(helperName)) {
          this.error(C.TPL_VAL_024, `${locale}: Forbidden helper "{{${helperName}}}" is not allowed in templates`, `content.${locale}`, `Remove usage of the forbidden helper "${helperName}"`);
        } else if (!FunctionRegistry.isEnabled(helperName)) {
          this.error(C.TPL_VAL_041, `${locale}: Helper "{{${helperName}}}" exists but is disabled`, `content.${locale}`, `Enable the helper "${helperName}" or use an alternative`);
        }
      }

      for (const partialName of analysis.partialNames) {
        const matchingPartial = allPartials.find(p => p.code === partialName);
        if (!matchingPartial) {
          this.warning(C.TPL_VAL_020, `${locale}: Partial "{{> ${partialName}}}" is used but not defined`, `content.${locale}`, `Define a partial with code "${partialName}" or remove the reference`);
        }
      }
    }

    for (const locale of Object.keys(content)) {
      if (!SUPPORTED_LOCALES.includes(locale as any)) {
        this.info(C.TPL_VAL_050, `Content has unsupported locale "${locale}"`, `content.${locale}`, `Supported locales: ${SUPPORTED_LOCALES.join(', ')}`);
      }
    }

    if (!content.ar && !content.en) {
      this.error(C.TPL_VAL_004, 'Template content must include at least the default locale (ar)', 'content', 'Add Arabic (ar) locale content');
    }
  }

  // ─── Localization Validator ────────────────────────────────────────

  private validateLocalization(
    content: Record<string, Record<string, string>>,
    defaultLocale: string,
  ): void {
    const locales = Object.keys(content);

    if (locales.length === 0) {
      this.error(C.TPL_VAL_004, 'No locale content provided', 'content', 'Add at least the default locale content');
      return;
    }

    if (!content[defaultLocale]) {
      this.error(C.TPL_VAL_053, `Default locale "${defaultLocale}" content is missing`, 'content', `Provide content for the default locale "${defaultLocale}"`);
    }

    for (const locale of locales) {
      const fields = content[locale];
      if (!fields || Object.keys(fields).length === 0) {
        this.error(C.TPL_VAL_050, `Locale "${locale}" has empty content`, `content.${locale}`, `Provide content for the "${locale}" locale`);
      }
    }

    if (locales.includes('ar') && locales.includes('en')) {
      const arFields = Object.keys(content.ar || {});
      const enFields = Object.keys(content.en || {});
      const arOnly = arFields.filter(f => !enFields.includes(f));
      const enOnly = enFields.filter(f => !arFields.includes(f));
      if (arOnly.length > 0) {
        this.warning(C.TPL_VAL_051, `Fields [${arOnly.join(', ')}] present in Arabic but missing in English`, 'content.en', 'Ensure all locale sections have the same structure');
      }
      if (enOnly.length > 0) {
        this.warning(C.TPL_VAL_051, `Fields [${enOnly.join(', ')}] present in English but missing in Arabic`, 'content.ar', 'Ensure all locale sections have the same structure');
      }
    }

    if (locales.length >= 2) {
      let referenceVariables: Set<string> | undefined;
      for (const locale of locales) {
        const fields = content[locale];
        if (!fields) continue;
        for (const fieldContent of Object.values(fields)) {
          if (typeof fieldContent !== 'string') continue;
          const analysis = this.parseTemplateContent(fieldContent);
          if (!referenceVariables) {
            referenceVariables = new Set(analysis.variableNames);
          } else {
            const missing = [...referenceVariables].filter(v => !analysis.variableNames.has(v));
            if (missing.length > 0) {
              this.warning(C.TPL_VAL_052, `Locale "${locale}" is missing variables used in other locales: ${missing.join(', ')}`, `content.${locale}`, 'Ensure consistent variable usage across all locales');
            }
          }
        }
      }
    }
  }

  // ─── Function Registry Validator ──────────────────────────────────

  private validateFunctionRegistry(variableDefinitions: VariableDefInput[], helperNames: Set<string>): void {
    const enabledHelpers = FunctionRegistry.getEnabledHelperNames();
    const forbiddenHelpers = FunctionRegistry.getForbiddenHelperNames();

    for (const h of helperNames) {
      if (enabledHelpers.has(h) || h === 'lookup') continue;
      if (forbiddenHelpers.has(h)) {
        this.error(C.TPL_VAL_024, `Forbidden helper "{{${h}}}" referenced in variable definitions`, 'variable_definitions', 'Remove all references to forbidden helpers');
      } else if (!FunctionRegistry.isRegistered(h)) {
        this.error(C.TPL_VAL_040, `Unknown helper "{{${h}}}" referenced - not in function registry`, 'variable_definitions', `Register the helper "${h}" in FunctionRegistry or use an alternative`);
      }
    }

    for (const v of variableDefinitions) {
      if (v.resolver_function && v.resolver_function.trim()) {
        const funcName = v.resolver_function.includes('.') ? v.resolver_function.split('.').pop()! : v.resolver_function;
        if (forbiddenHelpers.has(funcName)) {
          this.error(C.TPL_VAL_042, `Variable "${v.code}" references forbidden runtime function "${v.resolver_function}"`, `variable_definitions[${v.code}].resolver_function`, 'Runtime function names cannot be referenced in template definitions');
        }
      }
    }
  }

  // ─── Partial Validator ─────────────────────────────────────────────

  private validatePartials(partials: PartialInput[]): void {
    const seenCodes = new Set<string>();

    for (const p of partials) {
      if (seenCodes.has(p.code)) {
        this.error(C.TPL_VAL_005, `Duplicate partial code: "${p.code}"`, 'partials', 'Partial codes must be unique');
      }
      seenCodes.add(p.code);

      if (!p.content || !p.content.trim()) {
        this.error(C.TPL_VAL_001, `Partial "${p.code}" has empty content`, `partials[${p.code}]`, 'Provide template content for the partial');
      } else {
        const analysis = this.parseTemplateContent(p.content);
        if (analysis.syntaxError) {
          this.error(C.TPL_VAL_022, `Partial "${p.code}" has malformed Handlebars syntax`, `partials[${p.code}]`, analysis.syntaxError);
        }
      }
    }
  }

  // ─── Version Transition Validator ─────────────────────────────────

  private validateVersionTransition(version: TemplateVersionInput, allItems: ValidationItem[]): void {
    const errors = allItems.filter(i => i.severity === 'ERROR');
    if (version.status === 'REVIEW' && errors.length > 0) {
      this.warning(C.TPL_VAL_060, `Cannot promote version ${version.version} to REVIEW: ${errors.length} unresolved error(s)`, `versions[${version.version}].status`, 'Resolve all errors before promoting to REVIEW');
    }
  }

  // ─── Public API ────────────────────────────────────────────────────

  validateTemplate(template: TemplateInput): ValidationResult {
    this.items = [];

    this.validateStructure(template);

    if (template.versions && template.versions.length > 0) {
      this.validateVersionStatuses(template.versions);

      for (const version of template.versions) {
        this.validateTemplateContent(version, template.partials || []);
        this.validateLocalization(version.content, template.default_locale || 'ar');

        if (version.variable_definitions && version.variable_definitions.length > 0) {
          this.validateVariableDefinitions(version.variable_definitions);
          this.validateResolverReferences(version.variable_definitions);
        }
      }

      const allHelperNames = new Set<string>();
      for (const version of template.versions) {
        if (version.content) {
          const analyses = this.analyzeContent(version.content);
          for (const analysis of analyses.values()) {
            analysis.helperNames.forEach(h => allHelperNames.add(h));
          }
        }
      }
      this.validateFunctionRegistry(
        template.versions.flatMap(v => v.variable_definitions || []),
        allHelperNames,
      );
    }

    if (template.partials && template.partials.length > 0) {
      this.validatePartials(template.partials);
    }

    for (const version of (template.versions || [])) {
      this.validateVersionTransition(version, this.items);
    }

    return this.buildResult(template.code, template.versions?.[0]?.version);
  }

  validateVersion(version: TemplateVersionInput, partials: PartialInput[] = []): ValidationResult {
    this.items = [];

    if (!VALID_VERSION_STATUSES.includes(version.status as any)) {
      this.error(C.TPL_VAL_003, `Invalid version status "${version.status}"`, 'status', `Must be one of: ${VALID_VERSION_STATUSES.join(', ')}`);
    }

    this.validateTemplateContent(version, partials);
    this.validateLocalization(version.content, 'ar');

    if (version.variable_definitions && version.variable_definitions.length > 0) {
      this.validateVariableDefinitions(version.variable_definitions);
      this.validateResolverReferences(version.variable_definitions);
    }

    const allHelperNames = new Set<string>();
    const analyses = this.analyzeContent(version.content);
    for (const analysis of analyses.values()) {
      analysis.helperNames.forEach(h => allHelperNames.add(h));
    }
    this.validateFunctionRegistry(version.variable_definitions || [], allHelperNames);

    this.validateVersionTransition(version, this.items);

    return this.buildResult('', version.version);
  }

  validateContent(content: string, templateCode?: string): ValidationResult {
    this.items = [];

    const analysis = this.parseTemplateContent(content);
    if (analysis.syntaxError) {
      this.error(C.TPL_VAL_022, 'Malformed Handlebars syntax', 'content', analysis.syntaxError);
    }

    return this.buildResult(templateCode);
  }

  validateVariable(varDef: VariableDefInput): ValidationResult {
    this.items = [];

    if (!SUPPORTED_VARIABLE_TYPES.includes(varDef.type as any)) {
      this.error(C.TPL_VAL_011, `Unsupported variable type "${varDef.type}"`, 'type', `Must be one of: ${SUPPORTED_VARIABLE_TYPES.join(', ')}`);
    }

    if (varDef.required && !varDef.resolver_path && varDef.default_value === undefined && varDef.source_type !== 'manual') {
      this.warning(C.TPL_VAL_012, 'Required variable has no resolver path or default value', 'resolver_path', 'Provide a resolver path or default value');
    }

    return this.buildResult();
  }

  static getErrorCatalog(): Array<{ code: string; severity: string; title: string; description: string }> {
    return [
      { code: C.TPL_VAL_001, severity: 'ERROR', title: 'Missing required metadata', description: 'A required field (code, name_ar, name_en) is missing or empty.' },
      { code: C.TPL_VAL_002, severity: 'ERROR', title: 'Invalid category', description: 'Category ID is missing, zero, or negative.' },
      { code: C.TPL_VAL_003, severity: 'ERROR', title: 'Invalid version status', description: 'Version status is not a valid enum value.' },
      { code: C.TPL_VAL_004, severity: 'ERROR', title: 'Missing localization', description: 'Required locale content (at least ar) is missing.' },
      { code: C.TPL_VAL_005, severity: 'ERROR', title: 'Duplicate identifier', description: 'Duplicate template/version/partial code found.' },
      { code: C.TPL_VAL_006, severity: 'ERROR', title: 'Unsupported output format', description: 'Output format is not in the supported list.' },
      { code: C.TPL_VAL_010, severity: 'ERROR', title: 'Duplicate variable code', description: 'Variable code is not unique within the template version.' },
      { code: C.TPL_VAL_011, severity: 'ERROR', title: 'Unsupported variable type', description: 'Variable type is not in the supported types list.' },
      { code: C.TPL_VAL_012, severity: 'WARNING', title: 'Required/default consistency', description: 'Required variable has no resolver path or default value.' },
      { code: C.TPL_VAL_013, severity: 'ERROR', title: 'Missing resolver path', description: 'Entity/computed variable lacks a resolver_path.' },
      { code: C.TPL_VAL_014, severity: 'WARNING', title: 'Invalid entity whitelist root', description: 'entity_whitelist_root is not a known entity.' },
      { code: C.TPL_VAL_015, severity: 'ERROR', title: 'Variable schema error', description: 'Variable definition fails overall schema validation.' },
      { code: C.TPL_VAL_020, severity: 'WARNING', title: 'Unknown placeholder', description: 'A variable used in content is not defined in variable_definitions.' },
      { code: C.TPL_VAL_022, severity: 'ERROR', title: 'Malformed Handlebars syntax', description: 'Content contains invalid Handlebars syntax.' },
      { code: C.TPL_VAL_023, severity: 'ERROR', title: 'Unsupported helper', description: 'A helper used in content is not in the function registry.' },
      { code: C.TPL_VAL_024, severity: 'ERROR', title: 'Forbidden helper', description: 'A forbidden helper (eval, exec, etc.) is used in content.' },
      { code: C.TPL_VAL_025, severity: 'WARNING', title: 'Missing required variable', description: 'A required variable is not used in any locale content.' },
      { code: C.TPL_VAL_030, severity: 'WARNING', title: 'Entity root not whitelisted', description: 'Resolver path references an unknown entity root.' },
      { code: C.TPL_VAL_031, severity: 'WARNING', title: 'Resolver not found', description: 'Resolver function is not in the function registry.' },
      { code: C.TPL_VAL_032, severity: 'WARNING', title: 'Repository mapping missing', description: 'Resolver path lacks repository context in its path structure.' },
      { code: C.TPL_VAL_040, severity: 'ERROR', title: 'Unknown helper reference', description: 'A helper ref is not in the function registry at all.' },
      { code: C.TPL_VAL_041, severity: 'ERROR', title: 'Disabled helper reference', description: 'A helper exists in the registry but is disabled.' },
      { code: C.TPL_VAL_042, severity: 'ERROR', title: 'Runtime function name', description: 'A forbidden runtime function name is referenced.' },
      { code: C.TPL_VAL_050, severity: 'WARNING', title: 'Missing translation', description: 'A locale has empty or missing content.' },
      { code: C.TPL_VAL_051, severity: 'WARNING', title: 'Missing localized block', description: 'A locale is missing fields present in another locale.' },
      { code: C.TPL_VAL_052, severity: 'WARNING', title: 'Inconsistent variables', description: 'Variables used in locales are inconsistent.' },
      { code: C.TPL_VAL_053, severity: 'ERROR', title: 'Missing fallback locale', description: 'Default locale content is missing.' },
      { code: C.TPL_VAL_060, severity: 'WARNING', title: 'Validation errors block transition', description: 'Errors found in template prevent promotion to REVIEW.' },
      { code: C.TPL_VAL_062, severity: 'ERROR', title: 'Invalid lifecycle transition', description: 'The requested status transition is not allowed by the state machine.' },
      { code: C.TPL_VAL_063, severity: 'ERROR', title: 'Unauthorized lifecycle action', description: 'The user does not have permission to perform this lifecycle action.' },
      { code: C.TPL_VAL_064, severity: 'ERROR', title: 'Missing transition reason', description: 'The transition requires a reason but none was provided.' },
      { code: C.TPL_VAL_065, severity: 'ERROR', title: 'Invalid effective date range', description: 'Effective_until must be after effective_from when both are set.' },
      { code: C.TPL_VAL_066, severity: 'ERROR', title: 'Approval workflow incomplete', description: 'All approval steps must be completed before approving.' },
      { code: C.TPL_VAL_067, severity: 'ERROR', title: 'Version not in expected status', description: 'The version is not in the expected status for this operation.' },
      { code: C.TPL_VAL_068, severity: 'ERROR', title: 'Structural validation failed', description: 'Template version structure or content failed validation.' },
    ];
  }
}
