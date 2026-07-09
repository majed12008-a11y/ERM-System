/*
 * 47-public-verify-function.sql
 * ==============================
 *
 * إنشاء دالة SECURITY DEFINER للتحقق العام من الشهادات
 * (تجاوز RLS لأن نقطة التحقق العامة لا تحتوي على app.user_id).
 */

CREATE OR REPLACE FUNCTION documents.fn_get_certificate_verification(
    p_serial_number VARCHAR
)
RETURNS TABLE(
    serial_number VARCHAR,
    status VARCHAR,
    certificate_type VARCHAR,
    issuing_authority VARCHAR,
    issuing_authority_en VARCHAR,
    committee_name VARCHAR,
    committee_name_en VARCHAR,
    researcher_name VARCHAR,
    project_title VARCHAR,
    application_number VARCHAR,
    institution_name VARCHAR,
    issued_at TIMESTAMPTZ,
    revoked_at TIMESTAMPTZ,
    revocation_reason TEXT,
    superseded_by_serial VARCHAR
)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT
        c.serial_number::VARCHAR,
        c.status::VARCHAR,
        'ETHICS_APPROVAL'::VARCHAR AS certificate_type,
        'اللجنة الوطنية للأخلاقيات'::VARCHAR AS issuing_authority,
        'National Committee for Ethics'::VARCHAR AS issuing_authority_en,
        com.committee_name_ar::VARCHAR AS committee_name,
        com.committee_name_en::VARCHAR AS committee_name_en,
        u.username::VARCHAR AS researcher_name,
        p.title_ar::VARCHAR AS project_title,
        a.application_number::VARCHAR,
        inst.name_ar::VARCHAR AS institution_name,
        c.issued_at,
        c.revoked_at,
        c.revocation_reason,
        cs.serial_number::VARCHAR AS superseded_by_serial
    FROM documents.approval_certificates c
    JOIN core.applications a ON a.id = c.application_id
    JOIN core.projects p ON p.id = a.project_id
    JOIN security.users u ON u.id = c.issued_to_user_id
    JOIN committee.committees com ON com.id = a.target_committee_id
    JOIN security.institutions inst ON inst.id = p.institution_id
    LEFT JOIN documents.approval_certificates cs ON cs.id = c.superseded_by
    WHERE c.serial_number = p_serial_number;
$$;

COMMENT ON FUNCTION documents.fn_get_certificate_verification(VARCHAR) IS
  'Returns public verification data for a certificate. SECURITY DEFINER to bypass RLS (public endpoint has no session user).';
