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


