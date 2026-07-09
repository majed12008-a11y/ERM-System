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


