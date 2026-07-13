-- =========================================================================
-- templates — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: templates; Type: SCHEMA; Schema: -; Owner: -
--

COMMENT ON SCHEMA templates IS 'Template Engine — unified template management, versioning, rendering, and audit';


--

-- Name: categories; Type: TABLE; Schema: templates; Owner: -
--

COMMENT ON TABLE templates.categories IS 'تصنيفات القوالب — Template classifications defining business purpose, required variables, and output defaults';
COMMENT ON COLUMN templates.categories.code IS 'Machine-readable category code (e.g. CONSENT_ADULT, DECISION_APPROVAL)';
COMMENT ON COLUMN templates.categories.required_variables IS 'Structured variable schema: [{"name": "studyTitle", "type": "string", "required": true, "description": "..."}]';
COMMENT ON COLUMN templates.categories.default_output_format IS 'Default output format: PDF, DOCX, HTML, XLSX, TXT, EMAIL';
COMMENT ON COLUMN templates.categories.parent_category_id IS 'Self-referencing parent for hierarchical grouping';


--

COMMENT ON TABLE templates.templates IS 'القوالب — Named, versioned template definitions with content body and variable configuration';
COMMENT ON COLUMN templates.templates.code IS 'Stable business code (e.g. PROTOCOL_CROSS_SECTIONAL)';
COMMENT ON COLUMN templates.templates.engine IS 'Rendering engine: handlebars (extensible via TemplateService)';
COMMENT ON COLUMN templates.templates.variable_sources IS 'Auto-resolve configuration using path notation: [{"key": "studyTitle", "path": "application.project.title_en", "type": "string"}] — NO SQL';


--

COMMENT ON TABLE templates.template_versions IS 'نسخ القوالب — Immutable version snapshots. Content locked after REVIEW.';
COMMENT ON COLUMN templates.template_versions.version IS 'Semantic version: MAJOR.MINOR.PATCH';
COMMENT ON COLUMN templates.template_versions.status IS 'DRAFT, REVIEW, APPROVED, DEPRECATED, ARCHIVED';
COMMENT ON COLUMN templates.template_versions.content IS 'Structured JSONB: { body, blocks, metadata }';
COMMENT ON COLUMN templates.template_versions.content_hash IS 'SHA-256 of content for integrity verification';
COMMENT ON COLUMN templates.template_versions.variable_definitions IS 'Structured variable schema with resolver paths and validation rules';
COMMENT ON COLUMN templates.template_versions.effective_from IS 'When this version becomes active for generation';
COMMENT ON COLUMN templates.template_versions.effective_until IS 'When this version ceases to be active (set on supersede/rollback)';


--

COMMENT ON TABLE templates.template_localizations IS 'ترجمات القوالب — Translations of approved version content per locale';
COMMENT ON COLUMN templates.template_localizations.locale IS 'ar, en, or future fr, so';
COMMENT ON COLUMN templates.template_localizations.is_verified IS 'Whether a human verified the translation';


--

COMMENT ON TABLE templates.template_variables IS 'متغيرات القوالب — Registry of all variables across all templates. Enables cross-template validation.';
COMMENT ON COLUMN templates.template_variables.code IS 'Variable code used in templates: studyTitle, piName';
COMMENT ON COLUMN templates.template_variables.type IS 'string, number, date, boolean, array, object, enum';
COMMENT ON COLUMN templates.template_variables.source_type IS 'manual, entity, computed, context';
COMMENT ON COLUMN templates.template_variables.resolver_path IS 'Path notation ONLY — NO SQL. Must start with an allowed Entity Whitelist root.';
COMMENT ON COLUMN templates.template_variables.resolver_function IS 'If computed: must reference a registered Function Registry function. No eval.';
COMMENT ON COLUMN templates.template_variables.entity_whitelist_root IS 'Allowed root entity — must be in Entity Whitelist';


--

COMMENT ON TABLE templates.template_partials IS 'أجزاء قابلة لإعادة الاستخدام — Reusable template fragments shared across templates';
COMMENT ON COLUMN templates.template_partials.code IS 'Machine code: HEADER, FOOTER, SIGNATURE_BLOCK, COMMITTEE_MEMBERS';
COMMENT ON COLUMN templates.template_partials.content IS 'Handlebars template fragment';
COMMENT ON COLUMN templates.template_partials.depends_on IS 'List of partial codes this partial references via {{> partialCode}}';


--

COMMENT ON TABLE templates.template_packages IS 'حزم القوالب — Logical grouping of templates that execute together as one business action';
COMMENT ON TABLE templates.template_package_members IS 'أعضاء الحزمة — Ordered template slots within a package, each with format and dependency';


--

COMMENT ON TABLE templates.template_outputs IS 'مخرجات القوالب — Every generated output record with full audit snapshot';
COMMENT ON COLUMN templates.template_outputs.checksum_sha256 IS 'SHA-256 of the final generated output file';
COMMENT ON COLUMN templates.template_outputs.variables_hash IS 'SHA-256 of the variables JSON (privacy-safe audit)';
COMMENT ON COLUMN templates.template_outputs.rendered_html_hash IS 'SHA-256 of the intermediate rendered HTML';
COMMENT ON COLUMN templates.template_outputs.digital_signature_ref IS 'Extension point for future digital signature integration (not implemented)';


--

COMMENT ON TABLE templates.template_render_jobs IS 'وظائف التوليد — Queue-based rendering for asynchronous or batch generation';


--

COMMENT ON TABLE templates.template_render_history IS 'سجل التوليد — Append-only log of all rendering operations. Never deleted.';
COMMENT ON COLUMN templates.template_render_history.template_version_id IS 'Denormalized (no FK — survives template deletion)';
COMMENT ON COLUMN templates.template_render_history.template_code IS 'Denormalized';
COMMENT ON COLUMN templates.template_render_history.generated_by IS 'Denormalized';


--

COMMENT ON TABLE templates.template_approval_workflow IS 'موافقات القوالب — Records the approval chain for each version. Supports multi-step approvals.';


--

COMMENT ON TABLE templates.template_usage_statistics IS 'إحصائيات الاستخدام — Aggregated usage data for analytics. Updated asynchronously.';


--

COMMENT ON TABLE templates.template_version_audit IS 'تدقيق الإصدارات — Append-only audit of every version lifecycle transition.';


--

COMMENT ON TABLE templates.template_validation_tests IS 'اختبارات القوالب — Automated template testing. Runs on every version promotion.';


--

COMMENT ON TABLE templates.event_template_mapping IS 'ربط الأحداث — Maps domain events to template codes for event-driven generation (§4.7)';
