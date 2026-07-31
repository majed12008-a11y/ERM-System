import { z } from 'zod';
import {
  SUPPORTED_VARIABLE_TYPES,
  SUPPORTED_SOURCE_TYPES,
  SUPPORTED_OUTPUT_FORMATS,
  VALID_VERSION_STATUSES,
  SUPPORTED_LOCALES,
  SUPPORTED_ENGINES,
} from './template-validation.types';

export const templateVariableSchema = z.object({
  code: z.string().min(1).max(100).regex(/^[a-z][a-z0-9_]*$/, 'Variable code must be snake_case starting with a letter'),
  name_ar: z.string().min(1).max(200),
  name_en: z.string().min(1).max(200),
  type: z.enum(SUPPORTED_VARIABLE_TYPES),
  enum_values: z.array(z.string()).optional().default([]),
  source_type: z.enum(SUPPORTED_SOURCE_TYPES).default('manual'),
  resolver_path: z.string().max(500).optional().default(''),
  resolver_function: z.string().max(200).optional().default(''),
  resolver_function_args: z.any().optional(),
  entity_whitelist_root: z.string().max(100).optional().default(''),
  default_value: z.any().optional(),
  description_ar: z.string().max(500).optional().default(''),
  description_en: z.string().max(500).optional().default(''),
  required: z.boolean().default(false),
  validation_rules: z.any().optional().default({}),
  is_active: z.boolean().default(true),
});

export const templatePartialSchema = z.object({
  code: z.string().min(1).max(100),
  name_ar: z.string().min(1).max(200),
  name_en: z.string().min(1).max(200),
  engine: z.enum(SUPPORTED_ENGINES).default('handlebars'),
  content: z.string().min(1),
  content_hash: z.string().optional().default(''),
  version: z.number().int().positive().default(1),
  depends_on: z.array(z.string()).default([]),
  is_active: z.boolean().default(true),
});

export const templateVersionSchema = z.object({
  template_id: z.number().int().positive(),
  version: z.string().regex(/^\d+\.\d+\.\d+$/, 'Version must be semver (e.g. 1.0.0)'),
  status: z.enum(VALID_VERSION_STATUSES),
  content: z.record(z.enum(SUPPORTED_LOCALES), z.record(z.string(), z.string())),
  content_hash: z.string().optional().default(''),
  variable_definitions: z.array(templateVariableSchema).default([]),
  change_summary: z.string().max(1000).optional().default(''),
  effective_from: z.string().datetime().optional(),
  effective_until: z.string().datetime().optional(),
  created_by: z.number().int().positive(),
});

export const templateSchema = z.object({
  category_id: z.number().int().positive('Category is required'),
  code: z.string().min(1).max(100).regex(/^[A-Z][A-Z0-9_]*$/, 'Template code must be UPPER_SNAKE_CASE'),
  name_ar: z.string().min(1, 'Arabic name is required').max(200),
  name_en: z.string().min(1, 'English name is required').max(200),
  description: z.string().max(1000).optional().default(''),
  engine: z.enum(SUPPORTED_ENGINES).default('handlebars'),
  default_locale: z.enum(SUPPORTED_LOCALES).default('ar'),
  default_output_format: z.enum(SUPPORTED_OUTPUT_FORMATS).default('PDF'),
  variable_sources: z.any().optional().default({}),
  tags: z.array(z.string()).default([]),
  versions: z.array(templateVersionSchema).default([]),
  partials: z.array(templatePartialSchema).default([]),
  is_active: z.boolean().default(true),
});

export const localeContentSchema = z.object({
  subject: z.string().optional(),
  body: z.string().min(1, 'Body is required'),
  footer: z.string().optional(),
  header: z.string().optional(),
});

export const templateContentSchema = z.object({
  ar: localeContentSchema,
  en: localeContentSchema,
});

export const templateUpdateSchema = templateSchema.partial().omit({ code: true });

export type TemplateVariableInput = z.infer<typeof templateVariableSchema>;
export type TemplateInput = z.infer<typeof templateSchema>;
export type TemplateVersionInput = z.infer<typeof templateVersionSchema>;
export type TemplatePartialInput = z.infer<typeof templatePartialSchema>;
