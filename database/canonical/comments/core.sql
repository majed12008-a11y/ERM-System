-- =========================================================================
-- core — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: COLUMN amendment_requests.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.amendment_requests.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN amendment_requests.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.amendment_requests.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN amendment_requests.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.amendment_requests.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN amendment_requests.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.amendment_requests.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN amendment_requests.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.amendment_requests.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN amendment_requests.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.amendment_requests.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN application_amendments.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_amendments.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN application_amendments.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_amendments.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN application_amendments.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_amendments.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN application_amendments.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_amendments.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN application_amendments.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_amendments.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN application_amendments.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_amendments.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN application_checklists.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_checklists.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN application_checklists.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_checklists.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN application_checklists.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_checklists.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN application_checklists.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_checklists.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN application_checklists.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_checklists.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN application_checklists.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_checklists.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE application_consents; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.application_consents IS 'ربط الموافقات المستنيرة بالطلبات (طبقة الربط بين التطبيق والإصدار)';


--

-- Name: COLUMN application_consents.is_required; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_consents.is_required IS 'true=إلزامي, false=اختياري';


--

-- Name: COLUMN application_consents.status; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_consents.status IS 'PENDING, APPROVED, MINOR_REVISION, MAJOR_REVISION, REJECTED';


--

-- Name: COLUMN application_sections.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_sections.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN application_sections.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_sections.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN application_sections.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_sections.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN application_sections.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_sections.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN application_sections.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_sections.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN application_sections.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_sections.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN application_validations.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_validations.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN application_validations.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_validations.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN application_validations.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_validations.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN application_validations.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_validations.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN application_validations.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_validations.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN application_validations.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.application_validations.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN applications.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.applications.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN applications.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.applications.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN applications.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.applications.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN applications.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.applications.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN applications.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.applications.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN applications.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.applications.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN closure_requests.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.closure_requests.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN closure_requests.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.closure_requests.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN closure_requests.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.closure_requests.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN closure_requests.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.closure_requests.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN closure_requests.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.closure_requests.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN closure_requests.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.closure_requests.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN project_attachments.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_attachments.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN project_attachments.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_attachments.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN project_attachments.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_attachments.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN project_attachments.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_attachments.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN project_attachments.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_attachments.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN project_attachments.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_attachments.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN project_funding_sources.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_funding_sources.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN project_funding_sources.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_funding_sources.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN project_funding_sources.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_funding_sources.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN project_funding_sources.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_funding_sources.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN project_funding_sources.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_funding_sources.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN project_funding_sources.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_funding_sources.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN project_keywords.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_keywords.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN project_keywords.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_keywords.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN project_keywords.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_keywords.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN project_keywords.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_keywords.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN project_keywords.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_keywords.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN project_keywords.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_keywords.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN project_site_investigators.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_site_investigators.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN project_site_investigators.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_site_investigators.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN project_site_investigators.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_site_investigators.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN project_site_investigators.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_site_investigators.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN project_site_investigators.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_site_investigators.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN project_site_investigators.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_site_investigators.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN project_sites.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_sites.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN project_sites.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_sites.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN project_sites.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_sites.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN project_sites.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_sites.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN project_sites.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_sites.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN project_sites.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_sites.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN project_tags.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_tags.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN project_tags.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_tags.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN project_tags.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_tags.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN project_tags.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_tags.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN project_tags.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_tags.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN project_tags.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_tags.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN project_team_members.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_team_members.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN project_team_members.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_team_members.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN project_team_members.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_team_members.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN project_team_members.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_team_members.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN project_team_members.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_team_members.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN project_team_members.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.project_team_members.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN projects.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.projects.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN projects.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.projects.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN projects.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.projects.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN projects.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.projects.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN projects.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.projects.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN projects.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.projects.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN renewal_requests.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.renewal_requests.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN renewal_requests.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.renewal_requests.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN renewal_requests.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.renewal_requests.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN renewal_requests.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.renewal_requests.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN renewal_requests.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.renewal_requests.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN renewal_requests.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.renewal_requests.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE research_categories; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.research_categories IS 'تصنيفات البحث العلمي / Research Categories';


--

-- Name: COLUMN research_categories.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.research_categories.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN research_categories.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.research_categories.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN research_categories.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.research_categories.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN research_categories.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.research_categories.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN research_categories.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.research_categories.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN research_categories.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.research_categories.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE research_population_links; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.research_population_links IS 'ربط المشاريع بالفئات الحساسة / Research-Population Links';


--

-- Name: COLUMN research_population_links.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.research_population_links.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN research_population_links.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.research_population_links.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN research_population_links.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.research_population_links.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN research_population_links.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.research_population_links.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN research_population_links.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.research_population_links.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN research_population_links.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.research_population_links.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE risk_classifications; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.risk_classifications IS 'تصنيفات المخاطر / Risk Classifications';


--

-- Name: COLUMN risk_classifications.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.risk_classifications.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN risk_classifications.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.risk_classifications.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN risk_classifications.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.risk_classifications.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN risk_classifications.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.risk_classifications.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN risk_classifications.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.risk_classifications.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN risk_classifications.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.risk_classifications.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE vulnerable_populations; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.vulnerable_populations IS 'الفئات الحساسة في الأبحاث / Vulnerable Populations';


--

-- Name: COLUMN vulnerable_populations.created_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.vulnerable_populations.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN vulnerable_populations.updated_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.vulnerable_populations.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN vulnerable_populations.created_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.vulnerable_populations.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN vulnerable_populations.updated_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.vulnerable_populations.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN vulnerable_populations.deleted_at; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.vulnerable_populations.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN vulnerable_populations.deleted_by; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON COLUMN core.vulnerable_populations.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--


