-- =========================================================================
-- monitoring — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: COLUMN compliance_reviews.created_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.compliance_reviews.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN compliance_reviews.created_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.compliance_reviews.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN compliance_reviews.updated_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.compliance_reviews.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN compliance_reviews.updated_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.compliance_reviews.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN compliance_reviews.deleted_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.compliance_reviews.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN compliance_reviews.deleted_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.compliance_reviews.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN deviations.created_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.deviations.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN deviations.created_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.deviations.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN deviations.updated_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.deviations.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN deviations.updated_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.deviations.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN deviations.deleted_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.deviations.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN deviations.deleted_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.deviations.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN inspection_reports.created_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.inspection_reports.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN inspection_reports.created_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.inspection_reports.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN inspection_reports.updated_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.inspection_reports.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN inspection_reports.updated_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.inspection_reports.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN inspection_reports.deleted_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.inspection_reports.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN inspection_reports.deleted_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.inspection_reports.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN inspections.created_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.inspections.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN inspections.created_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.inspections.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN inspections.updated_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.inspections.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN inspections.updated_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.inspections.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN inspections.deleted_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.inspections.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN inspections.deleted_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.inspections.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN monitoring_findings.created_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_findings.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN monitoring_findings.created_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_findings.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN monitoring_findings.updated_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_findings.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN monitoring_findings.updated_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_findings.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN monitoring_findings.deleted_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_findings.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN monitoring_findings.deleted_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_findings.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN monitoring_plans.created_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_plans.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN monitoring_plans.created_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_plans.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN monitoring_plans.updated_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_plans.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN monitoring_plans.updated_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_plans.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN monitoring_plans.deleted_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_plans.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN monitoring_plans.deleted_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_plans.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN monitoring_visits.created_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_visits.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN monitoring_visits.created_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_visits.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN monitoring_visits.updated_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_visits.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN monitoring_visits.updated_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_visits.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN monitoring_visits.deleted_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_visits.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN monitoring_visits.deleted_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.monitoring_visits.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN preventive_actions.created_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.preventive_actions.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN preventive_actions.created_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.preventive_actions.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN preventive_actions.updated_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.preventive_actions.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN preventive_actions.updated_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.preventive_actions.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN preventive_actions.deleted_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.preventive_actions.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN preventive_actions.deleted_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.preventive_actions.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN protocol_violations.created_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.protocol_violations.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN protocol_violations.created_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.protocol_violations.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN protocol_violations.updated_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.protocol_violations.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN protocol_violations.updated_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.protocol_violations.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN protocol_violations.deleted_at; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.protocol_violations.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN protocol_violations.deleted_by; Type: COMMENT; Schema: monitoring; Owner: -
--

COMMENT ON COLUMN monitoring.protocol_violations.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--


