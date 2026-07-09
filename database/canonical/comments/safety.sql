-- =========================================================================
-- safety — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: COLUMN adverse_events.created_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.adverse_events.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN adverse_events.created_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.adverse_events.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN adverse_events.updated_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.adverse_events.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN adverse_events.updated_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.adverse_events.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN adverse_events.deleted_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.adverse_events.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN adverse_events.deleted_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.adverse_events.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE corrective_actions; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON TABLE safety.corrective_actions IS 'الإجراءات التصحيحية / Corrective Actions';


--

-- Name: COLUMN corrective_actions.created_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.corrective_actions.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN corrective_actions.updated_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.corrective_actions.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN corrective_actions.created_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.corrective_actions.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN corrective_actions.updated_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.corrective_actions.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN corrective_actions.deleted_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.corrective_actions.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN corrective_actions.deleted_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.corrective_actions.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN mitigation_actions.created_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.mitigation_actions.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN mitigation_actions.created_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.mitigation_actions.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN mitigation_actions.updated_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.mitigation_actions.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN mitigation_actions.updated_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.mitigation_actions.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN mitigation_actions.deleted_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.mitigation_actions.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN mitigation_actions.deleted_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.mitigation_actions.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN risk_assessments.created_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_assessments.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN risk_assessments.created_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_assessments.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN risk_assessments.updated_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_assessments.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN risk_assessments.updated_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_assessments.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN risk_assessments.deleted_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_assessments.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN risk_assessments.deleted_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_assessments.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE risk_incidents; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON TABLE safety.risk_incidents IS 'سجل الحوادث / Risk Incidents';


--

-- Name: COLUMN risk_incidents.created_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_incidents.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN risk_incidents.updated_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_incidents.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN risk_incidents.created_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_incidents.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN risk_incidents.updated_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_incidents.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN risk_incidents.deleted_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_incidents.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN risk_incidents.deleted_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_incidents.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE risk_mitigations; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON TABLE safety.risk_mitigations IS 'إجراءات معالجة المخاطر / Risk Mitigations';


--

-- Name: COLUMN risk_mitigations.created_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_mitigations.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN risk_mitigations.updated_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_mitigations.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN risk_mitigations.created_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_mitigations.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN risk_mitigations.updated_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_mitigations.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN risk_mitigations.deleted_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_mitigations.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN risk_mitigations.deleted_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_mitigations.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE risk_register; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON TABLE safety.risk_register IS 'سجل المخاطر المؤسسي / Enterprise Risk Register';


--

-- Name: COLUMN risk_register.created_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_register.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN risk_register.updated_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_register.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN risk_register.created_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_register.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN risk_register.updated_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_register.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN risk_register.deleted_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_register.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN risk_register.deleted_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.risk_register.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN safety_committee_reviews.created_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_committee_reviews.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN safety_committee_reviews.created_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_committee_reviews.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN safety_committee_reviews.updated_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_committee_reviews.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN safety_committee_reviews.updated_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_committee_reviews.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN safety_committee_reviews.deleted_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_committee_reviews.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN safety_committee_reviews.deleted_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_committee_reviews.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN safety_followups.created_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_followups.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN safety_followups.created_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_followups.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN safety_followups.updated_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_followups.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN safety_followups.updated_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_followups.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN safety_followups.deleted_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_followups.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN safety_followups.deleted_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_followups.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN safety_reports.created_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_reports.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN safety_reports.created_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_reports.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN safety_reports.updated_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_reports.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN safety_reports.updated_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_reports.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN safety_reports.deleted_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_reports.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN safety_reports.deleted_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.safety_reports.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN serious_adverse_events.created_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.serious_adverse_events.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN serious_adverse_events.created_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.serious_adverse_events.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN serious_adverse_events.updated_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.serious_adverse_events.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN serious_adverse_events.updated_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.serious_adverse_events.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN serious_adverse_events.deleted_at; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.serious_adverse_events.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN serious_adverse_events.deleted_by; Type: COMMENT; Schema: safety; Owner: -
--

COMMENT ON COLUMN safety.serious_adverse_events.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--


