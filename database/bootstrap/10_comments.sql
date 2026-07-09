-- =========================================================================
-- 10_comments.sql — Database object comments
-- Auto-generated from canonical extraction (570 comments)
-- =========================================================================

-- =========================================================================
-- committee — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: COLUMN agenda_items.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.agenda_items.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN agenda_items.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.agenda_items.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN agenda_items.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.agenda_items.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN agenda_items.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.agenda_items.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN agenda_items.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.agenda_items.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN agenda_items.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.agenda_items.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE application_conditions; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON TABLE committee.application_conditions IS 'شروط الموافقة المشروطة للطلبات — ترتبط بحالة AWAITING_CONDITIONS في سير العمل';


--

-- Name: COLUMN application_conditions.severity; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.application_conditions.severity IS 'خطورة الشرط: MINOR (طفيف), MAJOR (رئيسي), CRITICAL (حاسم)';


--

-- Name: COLUMN application_conditions.category; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.application_conditions.category IS 'تصنيف الشرط: GENERAL (عام), SCIENTIFIC (علمي), ETHICAL (أخلاقي), ADMINISTRATIVE (إداري), SAFETY (سلامة)';


--

-- Name: COLUMN application_conditions.status; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.application_conditions.status IS 'حالة الشرط: OPEN (مفتوح), MET (مستوفى), NOT_MET (غير مستوفى), WAIVED (متنازل عنه)';


--

-- Name: COLUMN attendance_logs.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.attendance_logs.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN attendance_logs.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.attendance_logs.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN attendance_logs.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.attendance_logs.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN attendance_logs.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.attendance_logs.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN attendance_logs.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.attendance_logs.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN attendance_logs.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.attendance_logs.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN committee_meetings.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.committee_meetings.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN committee_meetings.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.committee_meetings.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN committee_meetings.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.committee_meetings.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN committee_meetings.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.committee_meetings.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN committee_meetings.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.committee_meetings.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN committee_meetings.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.committee_meetings.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN committees.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.committees.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN committees.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.committees.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN committees.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.committees.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN committees.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.committees.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN committees.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.committees.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN committees.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.committees.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE consent_review_comments; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON TABLE committee.consent_review_comments IS 'سجلات مراجعة الموافقات المستنيرة (القرار + التعليق)';


--

-- Name: COLUMN consent_review_comments.decision; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.consent_review_comments.decision IS 'APPROVED, MINOR_REVISION, MAJOR_REVISION, REJECTED';


--

-- Name: TABLE consent_template_versions; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON TABLE committee.consent_template_versions IS 'إصدارات نماذج الموافقة (لقطة مجمدة غير قابلة للتعديل بعد الاعتماد)';


--

-- Name: COLUMN consent_template_versions.language; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.consent_template_versions.language IS 'ar, en';


--

-- Name: COLUMN consent_template_versions.status; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.consent_template_versions.status IS 'DRAFT, UNDER_REVIEW, APPROVED, RETIRED';


--

-- Name: TABLE consent_templates; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON TABLE committee.consent_templates IS 'نماذج الموافقة المستنيرة (الأنواع المنطقية)';


--

-- Name: COLUMN consent_templates.consent_type; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.consent_templates.consent_type IS 'WRITTEN, ELECTRONIC, VERBAL, GUARDIAN, ASSENT, WAIVER, DEFERRED';


--

-- Name: COLUMN ethics_reviews.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.ethics_reviews.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN ethics_reviews.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.ethics_reviews.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN ethics_reviews.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.ethics_reviews.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN ethics_reviews.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.ethics_reviews.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN ethics_reviews.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.ethics_reviews.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN ethics_reviews.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.ethics_reviews.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE ethics_risk_assessments; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON TABLE committee.ethics_risk_assessments IS 'تقييم المخاطر الأخلاقية القبلي (جزء من المراجعة الأخلاقية)';


--

-- Name: COLUMN ethics_risk_assessments.overall_risk_level; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.ethics_risk_assessments.overall_risk_level IS 'LOW, MEDIUM, HIGH, CRITICAL';


--

-- Name: COLUMN ethics_risk_assessments.recommendation; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.ethics_risk_assessments.recommendation IS 'APPROVE, APPROVE_WITH_MONITORING, CONDITIONAL, REJECT';


--

-- Name: TABLE ethics_risk_items; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON TABLE committee.ethics_risk_items IS 'بنود تقييم المخاطر الفردية';


--

-- Name: COLUMN meeting_agendas.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.meeting_agendas.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN meeting_agendas.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.meeting_agendas.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN meeting_agendas.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.meeting_agendas.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN meeting_agendas.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.meeting_agendas.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN meeting_agendas.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.meeting_agendas.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN meeting_agendas.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.meeting_agendas.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN meeting_minutes.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.meeting_minutes.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN meeting_minutes.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.meeting_minutes.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN meeting_minutes.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.meeting_minutes.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN meeting_minutes.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.meeting_minutes.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN meeting_minutes.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.meeting_minutes.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN meeting_minutes.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.meeting_minutes.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE member_conflicts; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON TABLE committee.member_conflicts IS 'تضارب مصالح الأعضاء (مستقل عن المراجعات) / Member Conflicts';


--

-- Name: COLUMN member_conflicts.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_conflicts.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN member_conflicts.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_conflicts.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN member_conflicts.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_conflicts.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN member_conflicts.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_conflicts.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN member_conflicts.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_conflicts.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN member_conflicts.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_conflicts.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE member_qualifications; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON TABLE committee.member_qualifications IS 'مؤهلات أعضاء اللجنة / Member Qualifications';


--

-- Name: COLUMN member_qualifications.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_qualifications.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN member_qualifications.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_qualifications.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN member_qualifications.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_qualifications.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN member_qualifications.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_qualifications.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN member_qualifications.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_qualifications.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN member_qualifications.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_qualifications.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE member_terms; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON TABLE committee.member_terms IS 'فترات عضوية اللجنة / Member Terms';


--

-- Name: COLUMN member_terms.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_terms.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN member_terms.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_terms.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN member_terms.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_terms.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN member_terms.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_terms.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN member_terms.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_terms.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN member_terms.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.member_terms.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN quorum_logs.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.quorum_logs.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN quorum_logs.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.quorum_logs.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN quorum_logs.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.quorum_logs.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN quorum_logs.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.quorum_logs.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN quorum_logs.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.quorum_logs.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN quorum_logs.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.quorum_logs.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN review_assignments.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_assignments.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN review_assignments.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_assignments.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN review_assignments.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_assignments.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN review_assignments.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_assignments.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN review_assignments.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_assignments.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN review_assignments.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_assignments.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN review_comments.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_comments.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN review_comments.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_comments.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN review_comments.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_comments.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN review_comments.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_comments.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN review_comments.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_comments.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN review_comments.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_comments.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN review_conflicts.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_conflicts.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN review_conflicts.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_conflicts.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN review_conflicts.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_conflicts.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN review_conflicts.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_conflicts.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN review_conflicts.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_conflicts.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN review_conflicts.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_conflicts.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN review_forms.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_forms.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN review_forms.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_forms.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN review_forms.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_forms.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN review_forms.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_forms.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN review_forms.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_forms.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN review_forms.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_forms.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN review_questions.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_questions.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN review_questions.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_questions.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN review_questions.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_questions.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN review_questions.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_questions.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN review_questions.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_questions.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN review_questions.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_questions.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN review_recommendations.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_recommendations.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN review_recommendations.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_recommendations.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN review_recommendations.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_recommendations.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN review_recommendations.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_recommendations.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN review_recommendations.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_recommendations.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN review_recommendations.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_recommendations.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN review_scores.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_scores.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN review_scores.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_scores.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN review_scores.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_scores.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN review_scores.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_scores.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN review_scores.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_scores.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN review_scores.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.review_scores.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN scientific_reviews.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.scientific_reviews.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN scientific_reviews.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.scientific_reviews.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN scientific_reviews.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.scientific_reviews.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN scientific_reviews.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.scientific_reviews.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN scientific_reviews.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.scientific_reviews.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN scientific_reviews.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.scientific_reviews.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN votes.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.votes.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN votes.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.votes.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN votes.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.votes.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN votes.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.votes.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN votes.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.votes.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN votes.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.votes.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN voting_sessions.created_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.voting_sessions.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN voting_sessions.created_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.voting_sessions.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN voting_sessions.updated_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.voting_sessions.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN voting_sessions.updated_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.voting_sessions.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN voting_sessions.deleted_at; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.voting_sessions.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN voting_sessions.deleted_by; Type: COMMENT; Schema: committee; Owner: -
--

COMMENT ON COLUMN committee.voting_sessions.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--



-- =========================================================================
-- communication — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: COLUMN announcements.created_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.announcements.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN announcements.created_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.announcements.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN announcements.updated_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.announcements.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN announcements.updated_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.announcements.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN announcements.deleted_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.announcements.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN announcements.deleted_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.announcements.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN message_attachments.created_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_attachments.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN message_attachments.created_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_attachments.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN message_attachments.updated_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_attachments.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN message_attachments.updated_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_attachments.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN message_attachments.deleted_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_attachments.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN message_attachments.deleted_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_attachments.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN message_recipients.created_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_recipients.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN message_recipients.created_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_recipients.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN message_recipients.updated_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_recipients.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN message_recipients.updated_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_recipients.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN message_recipients.deleted_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_recipients.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN message_recipients.deleted_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_recipients.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN messages.created_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.messages.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN messages.created_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.messages.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN messages.updated_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.messages.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN messages.updated_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.messages.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN messages.deleted_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.messages.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN messages.deleted_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.messages.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN notifications.created_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN notifications.created_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN notifications.updated_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN notifications.updated_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN notifications.deleted_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN notifications.deleted_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN notifications.source_entity_type; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.source_entity_type IS 'نوع الكيان المصدر (Application, Condition, Certificate)';


--

-- Name: COLUMN notifications.source_entity_id; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.source_entity_id IS 'معرف الكيان المصدر';


--

-- Name: TABLE user_notification_preferences; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON TABLE communication.user_notification_preferences IS 'تفضيلات المستخدم لكل نوع إشعار وقناة توصيل';


--

-- Name: COLUMN user_notification_preferences.user_id; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.user_notification_preferences.user_id IS 'معرف المستخدم';


--

-- Name: COLUMN user_notification_preferences.notification_type; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.user_notification_preferences.notification_type IS 'نوع الإشعار (مثل APPLICATION_APPROVED)';


--

-- Name: COLUMN user_notification_preferences.channel; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.user_notification_preferences.channel IS 'قناة التوصيل (IN_APP, EMAIL, SMS, PUSH)';


--

-- Name: COLUMN user_notification_preferences.is_enabled; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.user_notification_preferences.is_enabled IS 'تفعيل الإشعار عبر هذه القناة لهذا النوع';


--

-- Name: POLICY notification_logs_insert ON notification_logs; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON POLICY notification_logs_insert ON communication.notification_logs IS 'يسمح للمسؤولين والمستخدمين والتطبيق بإدراج سجلات التوصيل';


--



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



-- =========================================================================
-- documents — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: FUNCTION fn_get_certificate_verification(p_serial_number character varying); Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON FUNCTION documents.fn_get_certificate_verification(p_serial_number character varying) IS 'Returns public verification data for a certificate. SECURITY DEFINER to bypass RLS (public endpoint has no session user).';


--

-- Name: TABLE approval_certificate_documents; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON TABLE documents.approval_certificate_documents IS 'ربط الشهادات بملفات PDF المخزنة';


--

-- Name: COLUMN approval_certificate_documents.is_original; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.approval_certificate_documents.is_original IS 'true للإصدار الأصلي، false إذا أعيد توليد PDF';


--

-- Name: TABLE approval_certificates; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON TABLE documents.approval_certificates IS 'شهادات الاعتماد الصادرة للطلبات المعتمدة';


--

-- Name: COLUMN approval_certificates.serial_number; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.approval_certificates.serial_number IS 'الرقم التسلسلي للشهادة (مشتق من رقم الطلب)';


--

-- Name: COLUMN approval_certificates.version_no; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.approval_certificates.version_no IS 'رقم الإصدار (يزداد مع إعادة الإصدار)';


--

-- Name: COLUMN approval_certificates.status; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.approval_certificates.status IS 'حالة الشهادة: DRAFT, GENERATING, ISSUED, REVOKED, SUPERSEDED, FAILED';


--

-- Name: COLUMN approval_certificates.generation_error; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.approval_certificates.generation_error IS 'تفاصيل خطأ التوليد في حالة FAILED';


--

-- Name: TABLE certificate_verification_log; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON TABLE documents.certificate_verification_log IS 'سجل عمليات التحقق العامة من الشهادات';


--

-- Name: COLUMN document_access.created_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_access.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN document_access.created_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_access.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN document_access.updated_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_access.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN document_access.updated_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_access.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN document_access.deleted_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_access.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN document_access.deleted_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_access.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN document_approvals.created_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_approvals.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN document_approvals.created_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_approvals.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN document_approvals.updated_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_approvals.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN document_approvals.updated_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_approvals.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN document_approvals.deleted_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_approvals.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN document_approvals.deleted_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_approvals.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE document_classifications; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON TABLE documents.document_classifications IS 'تصنيفات المستندات / Document Classifications';


--

-- Name: TABLE document_disposal_logs; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON TABLE documents.document_disposal_logs IS 'سجل إتلاف المستندات / Document Disposal Logs';


--

-- Name: TABLE document_retention_rules; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON TABLE documents.document_retention_rules IS 'قواعد الاحتفاظ بالمستندات / Document Retention Rules';


--

-- Name: COLUMN document_signatures.created_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_signatures.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN document_signatures.created_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_signatures.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN document_signatures.updated_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_signatures.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN document_signatures.updated_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_signatures.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN document_signatures.deleted_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_signatures.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN document_signatures.deleted_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_signatures.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN document_versions.created_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_versions.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN document_versions.created_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_versions.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN document_versions.updated_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_versions.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN document_versions.updated_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_versions.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN document_versions.deleted_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_versions.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN document_versions.deleted_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.document_versions.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN documents.created_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.documents.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN documents.created_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.documents.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN documents.updated_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.documents.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN documents.updated_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.documents.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN documents.deleted_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.documents.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN documents.deleted_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.documents.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN generated_documents.created_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.generated_documents.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN generated_documents.created_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.generated_documents.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN generated_documents.updated_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.generated_documents.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN generated_documents.updated_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.generated_documents.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN generated_documents.deleted_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.generated_documents.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN generated_documents.deleted_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.generated_documents.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN templates.created_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.templates.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN templates.created_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.templates.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN templates.updated_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.templates.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN templates.updated_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.templates.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN templates.deleted_at; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.templates.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN templates.deleted_by; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON COLUMN documents.templates.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: POLICY cert_doc_select ON approval_certificate_documents; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON POLICY cert_doc_select ON documents.approval_certificate_documents IS 'Allows SELECT by admin, applicant, or active committee member (derived through linked certificate)';


--

-- Name: POLICY cert_select ON approval_certificates; Type: COMMENT; Schema: documents; Owner: -
--

COMMENT ON POLICY cert_select ON documents.approval_certificates IS 'Allows SELECT by admin, applicant (issued_to), or active committee member of the linked application';


--



-- =========================================================================
--  — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--

-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--

-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--



-- =========================================================================
-- integration — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: TABLE data_sync_jobs; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON TABLE integration.data_sync_jobs IS 'وظائف مزامنة البيانات / Data Sync Jobs';


--

-- Name: COLUMN data_sync_jobs.created_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.data_sync_jobs.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN data_sync_jobs.created_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.data_sync_jobs.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN data_sync_jobs.updated_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.data_sync_jobs.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN data_sync_jobs.updated_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.data_sync_jobs.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN data_sync_jobs.deleted_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.data_sync_jobs.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN data_sync_jobs.deleted_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.data_sync_jobs.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN event_outbox.created_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.event_outbox.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN event_outbox.created_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.event_outbox.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN event_outbox.updated_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.event_outbox.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN event_outbox.updated_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.event_outbox.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN event_outbox.deleted_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.event_outbox.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN event_outbox.deleted_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.event_outbox.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE external_systems; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON TABLE integration.external_systems IS 'الأنظمة الخارجية المتصلة / External Systems';


--

-- Name: TABLE integration_credentials; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON TABLE integration.integration_credentials IS 'بيانات اعتماد التكامل / Integration Credentials';


--

-- Name: TABLE integration_failures; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON TABLE integration.integration_failures IS 'سجل فشل التكامل / Integration Failures';


--

-- Name: COLUMN retry_queue.created_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.retry_queue.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN retry_queue.created_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.retry_queue.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN retry_queue.updated_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.retry_queue.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN retry_queue.updated_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.retry_queue.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN retry_queue.deleted_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.retry_queue.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN retry_queue.deleted_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.retry_queue.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN webhooks.created_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.webhooks.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN webhooks.created_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.webhooks.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN webhooks.updated_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.webhooks.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN webhooks.updated_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.webhooks.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN webhooks.deleted_at; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.webhooks.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN webhooks.deleted_by; Type: COMMENT; Schema: integration; Owner: -
--

COMMENT ON COLUMN integration.webhooks.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--



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



-- =========================================================================
-- reference — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: TABLE academic_titles; Type: COMMENT; Schema: reference; Owner: -
--

COMMENT ON TABLE reference.academic_titles IS 'الألقاب الأكاديمية / Academic Titles';


--

-- Name: COLUMN academic_titles.code; Type: COMMENT; Schema: reference; Owner: -
--

COMMENT ON COLUMN reference.academic_titles.code IS 'رمز اللقب (مثال: PROF, ASSOC_PROF)';


--

-- Name: COLUMN academic_titles.name_ar; Type: COMMENT; Schema: reference; Owner: -
--

COMMENT ON COLUMN reference.academic_titles.name_ar IS 'الاسم بالعربية';


--

-- Name: COLUMN academic_titles.name_en; Type: COMMENT; Schema: reference; Owner: -
--

COMMENT ON COLUMN reference.academic_titles.name_en IS 'الاسم بالإنجليزية';


--

-- Name: TABLE institutions_registry; Type: COMMENT; Schema: reference; Owner: -
--

COMMENT ON TABLE reference.institutions_registry IS 'سجل المؤسسات الوطني / National Institutions Registry';


--

-- Name: TABLE licenses_registry; Type: COMMENT; Schema: reference; Owner: -
--

COMMENT ON TABLE reference.licenses_registry IS 'سجل التراخيص المهنية / Professional Licenses Registry';


--

-- Name: TABLE professions_registry; Type: COMMENT; Schema: reference; Owner: -
--

COMMENT ON TABLE reference.professions_registry IS 'سجل المهن الوطني / National Professions Registry';


--



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



-- =========================================================================
-- security — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: TABLE responsibility_types; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON TABLE security.responsibility_types IS 'أنواع المسؤوليات / Responsibility Types';


--

-- Name: COLUMN responsibility_types.code; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON COLUMN security.responsibility_types.code IS 'الكود (Reviewer, Approver, Signer, Observer, Coordinator, Secretary)';


--

-- Name: COLUMN user_profiles.gender; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON COLUMN security.user_profiles.gender IS 'ذكر / أنثى';


--

-- Name: COLUMN user_profiles.academic_title; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON COLUMN security.user_profiles.academic_title IS 'اللقب الأكاديمي';


--

-- Name: COLUMN user_profiles.academic_title_id; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON COLUMN security.user_profiles.academic_title_id IS 'اللقب الأكاديمي (مرجع)';


--

-- Name: TABLE user_responsibilities; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON TABLE security.user_responsibilities IS 'مسؤوليات المستخدمين / User Responsibilities';


--

-- Name: COLUMN user_responsibilities.entity_type; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON COLUMN security.user_responsibilities.entity_type IS 'نوع الكيان (application, project, committee)';


--

-- Name: COLUMN user_responsibilities.entity_id; Type: COMMENT; Schema: security; Owner: -
--

COMMENT ON COLUMN security.user_responsibilities.entity_id IS 'معرف الكيان';


--



-- =========================================================================
-- system — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: FUNCTION fn_is_admin(p_user_id bigint); Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON FUNCTION system.fn_is_admin(p_user_id bigint) IS 'Returns true if the user holds any administrative role. SECURITY DEFINER to bypass RLS on user_roles.';


--

-- Name: FUNCTION fn_is_committee_member_for_application(p_user_id bigint, p_application_id bigint); Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON FUNCTION system.fn_is_committee_member_for_application(p_user_id bigint, p_application_id bigint) IS 'Returns true if p_user_id is an active committee member of the committee reviewing p_application_id. SECURITY DEFINER to bypass RLS.';


--

-- Name: FUNCTION is_active_row(p_deleted_at timestamp with time zone); Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON FUNCTION system.is_active_row(p_deleted_at timestamp with time zone) IS 'Returns true if the row is not soft-deleted. Used in RLS policies.';


SET default_table_access_method = heap;

--

-- Name: TABLE push_config; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.push_config IS 'إعدادات الإشعارات الفورية / Push Notification Config';


--

-- Name: COLUMN push_config.config_name; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON COLUMN system.push_config.config_name IS 'اسم الإعداد';


--

-- Name: COLUMN push_config.provider; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON COLUMN system.push_config.provider IS 'المزود (FCM, APNs, ...)';


--

-- Name: COLUMN push_config.server_key; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON COLUMN system.push_config.server_key IS 'مفتاح الخادم';


--

-- Name: COLUMN push_config.app_id; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON COLUMN system.push_config.app_id IS 'معرف التطبيق';


--

-- Name: TABLE rule_actions; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.rule_actions IS 'إجراءات قواعد الأعمال / Rule Actions';


--

-- Name: TABLE rule_conditions; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.rule_conditions IS 'شروط قواعد الأعمال / Rule Conditions';


--

-- Name: TABLE rule_executions; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.rule_executions IS 'سجل تنفيذ قواعد الأعمال / Rule Executions';


--

-- Name: TABLE saved_searches; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.saved_searches IS 'عمليات البحث المحفوظة / Saved Searches';


--

-- Name: TABLE search_audit; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.search_audit IS 'سجل عمليات البحث / Search Audit Log';


--

-- Name: TABLE search_indexes; Type: COMMENT; Schema: system; Owner: -
--

COMMENT ON TABLE system.search_indexes IS 'فهارس البحث النصي / Search Indexes';


--



-- =========================================================================
-- workflow — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: COLUMN workflow_instances.created_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_instances.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN workflow_instances.created_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_instances.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN workflow_instances.updated_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_instances.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN workflow_instances.updated_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_instances.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN workflow_instances.deleted_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_instances.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN workflow_instances.deleted_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_instances.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN workflow_tasks.created_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_tasks.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN workflow_tasks.created_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_tasks.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN workflow_tasks.updated_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_tasks.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN workflow_tasks.updated_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_tasks.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN workflow_tasks.deleted_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_tasks.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN workflow_tasks.deleted_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflow_tasks.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: TABLE workflow_events; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON TABLE workflow.workflow_events IS 'أحداث سير العمل / Workflow Events';


--

-- Name: TABLE workflow_schedulers; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON TABLE workflow.workflow_schedulers IS 'مجَدولات سير العمل / Workflow Schedulers';


--

-- Name: TABLE workflow_triggers; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON TABLE workflow.workflow_triggers IS 'مشغلات سير العمل / Workflow Triggers';


--

-- Name: COLUMN workflows.created_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflows.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN workflows.created_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflows.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN workflows.updated_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflows.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN workflows.updated_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflows.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN workflows.deleted_at; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflows.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN workflows.deleted_by; Type: COMMENT; Schema: workflow; Owner: -
--

COMMENT ON COLUMN workflow.workflows.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--




