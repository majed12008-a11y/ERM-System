-- =========================================================================
-- documents — FUNCTION
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: fn_get_certificate_verification(character varying); Type: FUNCTION; Schema: documents; Owner: -
--

CREATE FUNCTION documents.fn_get_certificate_verification(p_serial_number character varying) RETURNS TABLE(serial_number character varying, status character varying, certificate_type character varying, issuing_authority character varying, issuing_authority_en character varying, committee_name character varying, committee_name_en character varying, researcher_name character varying, project_title character varying, application_number character varying, institution_name character varying, issued_at timestamp with time zone, revoked_at timestamp with time zone, revocation_reason text, superseded_by_serial character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
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


--


