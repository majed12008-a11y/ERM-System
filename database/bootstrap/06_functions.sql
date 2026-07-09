-- =========================================================================
-- 06_functions.sql — User-defined functions (excludes extension functions)
-- Auto-generated from canonical extraction (30 functions)
-- =========================================================================

-- =========================================================================
-- committee — FUNCTION
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: fn_cycle_created_by(bigint); Type: FUNCTION; Schema: committee; Owner: -
--

CREATE FUNCTION committee.fn_cycle_created_by(p_cycle_id bigint) RETURNS bigint
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT created_by FROM committee.accreditation_cycles WHERE id = p_cycle_id;
$$;


--

-- Name: fn_get_cycle_committee_id(bigint); Type: FUNCTION; Schema: committee; Owner: -
--

CREATE FUNCTION committee.fn_get_cycle_committee_id(p_cycle_id bigint) RETURNS bigint
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT committee_id FROM committee.accreditation_cycles WHERE id = p_cycle_id;
$$;


--

-- Name: fn_is_admin_or_cycle_creator_or_committee_admin(bigint, bigint); Type: FUNCTION; Schema: committee; Owner: -
--

CREATE FUNCTION committee.fn_is_admin_or_cycle_creator_or_committee_admin(p_user_id bigint, p_cycle_id bigint) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_committee_id BIGINT;
  v_created_by BIGINT;
BEGIN
  IF system.fn_is_admin(p_user_id) THEN
    RETURN true;
  END IF;
  SELECT committee_id, created_by INTO v_committee_id, v_created_by
  FROM committee.accreditation_cycles WHERE id = p_cycle_id;
  IF v_created_by = p_user_id THEN
    RETURN true;
  END IF;
  IF committee.fn_is_committee_admin(p_user_id, v_committee_id) THEN
    RETURN true;
  END IF;
  RETURN false;
END;
$$;


--

-- Name: fn_is_assessor_for_cycle(bigint, bigint); Type: FUNCTION; Schema: committee; Owner: -
--

CREATE FUNCTION committee.fn_is_assessor_for_cycle(p_user_id bigint, p_cycle_id bigint) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM committee.accreditation_assessments
    WHERE cycle_id = p_cycle_id AND assessed_by = p_user_id
  );
$$;


--

-- Name: fn_is_committee_admin(bigint, bigint); Type: FUNCTION; Schema: committee; Owner: -
--

CREATE FUNCTION committee.fn_is_committee_admin(p_user_id bigint, p_committee_id bigint) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM committee.committee_members cm
    JOIN committee.committee_roles cr ON cr.id = cm.role_id
    WHERE cm.user_id = p_user_id
      AND cm.committee_id = p_committee_id
      AND cm.is_active = true
      AND cr.role_code IN ('CHAIR', 'SECRETARY', 'COORDINATOR')
  );
END;
$$;


--

-- Name: fn_user_can_access_assessment(bigint, bigint); Type: FUNCTION; Schema: committee; Owner: -
--

CREATE FUNCTION committee.fn_user_can_access_assessment(p_user_id bigint, p_assessment_cycle_id bigint) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
BEGIN
  IF system.fn_is_admin(p_user_id) THEN
    RETURN true;
  END IF;
  IF committee.fn_is_committee_admin(p_user_id, committee.fn_get_cycle_committee_id(p_assessment_cycle_id)) THEN
    RETURN true;
  END IF;
  RETURN false;
END;
$$;


--

-- Name: fn_user_can_access_cycle(bigint, bigint); Type: FUNCTION; Schema: committee; Owner: -
--

CREATE FUNCTION committee.fn_user_can_access_cycle(p_user_id bigint, p_cycle_id bigint) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
BEGIN
  IF system.fn_is_admin(p_user_id) THEN
    RETURN true;
  END IF;
  IF EXISTS (
    SELECT 1 FROM committee.accreditation_cycles
    WHERE id = p_cycle_id AND created_by = p_user_id
  ) THEN
    RETURN true;
  END IF;
  IF committee.fn_is_committee_admin(p_user_id, committee.fn_get_cycle_committee_id(p_cycle_id)) THEN
    RETURN true;
  END IF;
  IF committee.fn_is_assessor_for_cycle(p_user_id, p_cycle_id) THEN
    RETURN true;
  END IF;
  RETURN false;
END;
$$;


--



-- =========================================================================
-- communication — FUNCTION
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: fn_current_user_id(); Type: FUNCTION; Schema: communication; Owner: -
--

CREATE FUNCTION communication.fn_current_user_id() RETURNS bigint
    LANGUAGE sql STABLE
    AS $$ SELECT (current_setting('app.user_id', true))::BIGINT; $$;


--



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



-- =========================================================================
-- public — FUNCTION
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: sys_audit_triggers(boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.sys_audit_triggers(enable boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE r RECORD;
BEGIN
    FOR r IN
        SELECT event_object_schema, event_object_table
        FROM information_schema.triggers
        WHERE trigger_name LIKE 'trigger_audit%'
        GROUP BY event_object_schema, event_object_table
    LOOP
        IF enable THEN
            EXECUTE format('ALTER TABLE %I.%I ENABLE TRIGGER ALL', r.event_object_schema, r.event_object_table);
        ELSE
            EXECUTE format('ALTER TABLE %I.%I DISABLE TRIGGER ALL', r.event_object_schema, r.event_object_table);
        END IF;
    END LOOP;
END;
$$;


--

-- Name: sys_rls(boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.sys_rls(enable boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE r RECORD;
BEGIN
    FOR r IN
        SELECT schemaname, tablename FROM pg_tables WHERE rowsecurity
    LOOP
        IF enable THEN
            EXECUTE format('ALTER TABLE %I.%I ENABLE ROW LEVEL SECURITY', r.schemaname, r.tablename);
        ELSE
            EXECUTE format('ALTER TABLE %I.%I DISABLE ROW LEVEL SECURITY', r.schemaname, r.tablename);
        END IF;
    END LOOP;
END;
$$;


--



-- =========================================================================
-- security — FUNCTION
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: fn_authenticate(text); Type: FUNCTION; Schema: security; Owner: -
--

CREATE FUNCTION security.fn_authenticate(p_username text) RETURNS TABLE(v_id bigint, v_password_hash text, v_status character varying, v_is_locked boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT u.id, u.password_hash, u.status, u.is_locked
  FROM security.users u
  WHERE u.username = p_username OR u.email = p_username;
END;
$$;


--

-- Name: fn_register_user(integer, integer, public.citext, public.citext, text, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: security; Owner: -
--

CREATE FUNCTION security.fn_register_user(p_institution_id integer, p_department_id integer, p_username public.citext, p_email public.citext, p_password_hash text, p_first_name_ar character varying, p_last_name_ar character varying, p_first_name_en character varying, p_last_name_en character varying, p_mobile character varying) RETURNS TABLE(id bigint, uuid uuid, username public.citext, email public.citext)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    INSERT INTO security.users
        (institution_id, department_id, username, email, password_hash,
         first_name_ar, last_name_ar, first_name_en, last_name_en, mobile)
    VALUES
        (p_institution_id, p_department_id, p_username, p_email, p_password_hash,
         p_first_name_ar, p_last_name_ar, p_first_name_en, p_last_name_en, p_mobile)
    -- ملاحظة: نستخدم security.users.id بدلاً من id فقط
    -- لتجنب تعارض الأسماء مع أعمدة RETURN TABLE في PL/pgSQL
    RETURNING security.users.id, security.users.uuid,
              security.users.username, security.users.email;
END;
$$;


--

-- Name: fn_reset_password(text, text); Type: FUNCTION; Schema: security; Owner: -
--

CREATE FUNCTION security.fn_reset_password(p_token_hash text, p_password_hash text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_user_id BIGINT;
  v_token_id BIGINT;
BEGIN
  SELECT id, user_id INTO v_token_id, v_user_id
  FROM security.password_reset_tokens
  WHERE token_hash = p_token_hash
    AND used_at IS NULL
    AND expires_at > now();

  IF v_user_id IS NULL THEN
    RETURN FALSE;
  END IF;

  UPDATE security.users
  SET password_hash = p_password_hash
  WHERE id = v_user_id;

  UPDATE security.password_reset_tokens
  SET used_at = now()
  WHERE id = v_token_id;

  UPDATE security.sessions
  SET revoked_at = now()
  WHERE user_id = v_user_id AND revoked_at IS NULL;

  RETURN TRUE;
END;
$$;


--

-- Name: fn_verify_email(bigint); Type: FUNCTION; Schema: security; Owner: -
--

CREATE FUNCTION security.fn_verify_email(p_user_id bigint) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'security', 'public'
    AS $$
BEGIN
  UPDATE security.users SET is_email_verified = true WHERE id = p_user_id;
  RETURN FOUND;
END;
$$;


--



-- =========================================================================
-- system — FUNCTION
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: fn_apply_audit_triggers(); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_apply_audit_triggers() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Applications audit
    DROP TRIGGER IF EXISTS trigger_audit_applications ON core.applications;
    CREATE TRIGGER trigger_audit_applications
    AFTER INSERT OR UPDATE OR DELETE ON core.applications
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();

    -- Projects audit
    DROP TRIGGER IF EXISTS trigger_audit_projects ON core.projects;
    CREATE TRIGGER trigger_audit_projects
    AFTER INSERT OR UPDATE OR DELETE ON core.projects
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();

    -- Users audit
    DROP TRIGGER IF EXISTS trigger_audit_users ON security.users;
    CREATE TRIGGER trigger_audit_users
    AFTER INSERT OR UPDATE OR DELETE ON security.users
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();

    -- Committee members audit
    DROP TRIGGER IF EXISTS trigger_audit_committee_members ON committee.committee_members;
    CREATE TRIGGER trigger_audit_committee_members
    AFTER INSERT OR UPDATE OR DELETE ON committee.committee_members
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();

    -- Workflow instances audit
    DROP TRIGGER IF EXISTS trigger_audit_workflow ON workflow.workflow_instances;
    CREATE TRIGGER trigger_audit_workflow
    AFTER INSERT OR UPDATE OR DELETE ON workflow.workflow_instances
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();

    -- Documents audit
    DROP TRIGGER IF EXISTS trigger_audit_documents ON documents.documents;
    CREATE TRIGGER trigger_audit_documents
    AFTER INSERT OR UPDATE OR DELETE ON documents.documents
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();

    -- Adverse events audit
    DROP TRIGGER IF EXISTS trigger_audit_adverse_events ON safety.adverse_events;
    CREATE TRIGGER trigger_audit_adverse_events
    AFTER INSERT OR UPDATE OR DELETE ON safety.adverse_events
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
END;
$$;


--

-- Name: fn_calculate_quorum(bigint); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_calculate_quorum(p_meeting_id bigint) RETURNS TABLE(total_members integer, present_members integer, quorum_required integer, quorum_achieved boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_total INTEGER;
    v_present INTEGER;
    v_required INTEGER;
    v_achieved BOOLEAN;
BEGIN
    -- Count total active members for the committee of this meeting
    SELECT COUNT(*) INTO v_total
    FROM committee.committee_members cm
    JOIN committee.committee_meetings mtg ON cm.committee_id = mtg.committee_id
    WHERE mtg.id = p_meeting_id AND cm.is_active = TRUE;

    -- Count members who attended
    SELECT COUNT(*) INTO v_present
    FROM committee.attendance_logs
    WHERE meeting_id = p_meeting_id AND attendance_status IN ('PRESENT', 'REMOTE');

    -- Quorum required: 50% + 1 of total members
    v_required := (v_total / 2) + 1;

    -- Check if quorum is achieved
    v_achieved := (v_present >= v_required);

    -- Log quorum
    INSERT INTO committee.quorum_logs (meeting_id, total_members, present_members, quorum_required, quorum_achieved)
    VALUES (p_meeting_id, v_total, v_present, v_required, v_achieved);

    RETURN QUERY SELECT v_total, v_present, v_required, v_achieved;
END;
$$;


--

-- Name: fn_check_sla(); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_check_sla() RETURNS TABLE(workflow_id bigint, workflow_name character varying, instance_id bigint, task_id bigint, task_code character varying, assigned_to bigint, sla_hours integer, elapsed_hours numeric, is_violated boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        w.id,
        w.workflow_name,
        wi.id,
        wt.id,
        wt.task_code,
        wt.assigned_to,
        wsla.max_duration_hours,
        EXTRACT(EPOCH FROM (now() - wt.due_date)) / 3600 AS elapsed_hours,
        CASE WHEN wt.due_date < now() AND wt.completed_at IS NULL THEN TRUE ELSE FALSE END
    FROM workflow.workflow_tasks wt
    JOIN workflow.workflow_instances wi ON wt.workflow_instance_id = wi.id
    JOIN workflow.workflows w ON wi.workflow_id = w.id
    JOIN workflow.workflow_sla wsla ON w.id = wsla.workflow_id AND wi.current_state_id = wsla.state_id
    WHERE wt.task_status = 'OPEN'
    AND wt.due_date IS NOT NULL
    AND wt.due_date < now();
END;
$$;


--

-- Name: fn_create_snapshot(); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_create_snapshot() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_snapshot JSONB;
BEGIN
    IF TG_TABLE_NAME = 'applications' THEN
        v_snapshot := row_to_json(NEW)::JSONB;
        INSERT INTO core.application_versions (application_id, version_no, snapshot_data, created_by)
        VALUES (
            NEW.id,
            COALESCE((SELECT MAX(version_no) FROM core.application_versions WHERE application_id = NEW.id), 0) + 1,
            v_snapshot,
            COALESCE(current_setting('app.user_id', TRUE)::BIGINT, NEW.submitted_by)
        );
    ELSIF TG_TABLE_NAME = 'projects' THEN
        v_snapshot := row_to_json(NEW)::JSONB;
        INSERT INTO core.project_versions (project_id, version_no, snapshot_data, created_by)
        VALUES (
            NEW.id,
            COALESCE((SELECT MAX(version_no) FROM core.project_versions WHERE project_id = NEW.id), 0) + 1,
            v_snapshot,
            COALESCE(current_setting('app.user_id', TRUE)::BIGINT, NEW.principal_investigator_id)
        );
    END IF;

    RETURN NEW;
END;
$$;


--

-- Name: fn_current_user_id(); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_current_user_id() RETURNS bigint
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT current_setting('app.user_id')::bigint;
$$;


--

-- Name: fn_generate_application_number(); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_generate_application_number() RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_year TEXT;
    v_seq INTEGER;
    v_number VARCHAR(100);
BEGIN
    v_year := to_char(now(), 'YYYY');
    v_seq := nextval('core.applications_id_seq'::regclass);
    v_number := 'APP-' || v_year || '-' || LPAD(v_seq::TEXT, 6, '0');
    RETURN v_number;
END;
$$;


--

-- Name: fn_generate_project_code(); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_generate_project_code() RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_year TEXT;
    v_seq INTEGER;
    v_code VARCHAR(100);
BEGIN
    v_year := to_char(now(), 'YY');
    v_seq := nextval('core.projects_id_seq'::regclass);
    v_code := 'PRJ-' || v_year || '-' || LPAD(v_seq::TEXT, 6, '0');
    RETURN v_code;
END;
$$;


--

-- Name: fn_init_workflow(character varying, character varying, bigint); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_init_workflow(p_workflow_code character varying, p_entity_type character varying, p_entity_id bigint) RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_workflow_id   BIGINT;
    v_initial_state BIGINT;
    v_instance_id   BIGINT;
BEGIN
    SELECT id INTO v_workflow_id
    FROM workflow.workflows
    WHERE workflow_code = p_workflow_code AND is_active = TRUE;

    SELECT id INTO v_initial_state
    FROM workflow.workflow_states
    WHERE workflow_id = v_workflow_id AND is_initial = TRUE;

    INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id)
    VALUES (v_workflow_id, p_entity_type, p_entity_id, v_initial_state)
    ON CONFLICT (entity_type, entity_id) WHERE status_code = 'ACTIVE' AND deleted_at IS NULL
    DO NOTHING
    RETURNING id INTO v_instance_id;

    RETURN v_instance_id;
END;
$$;


--

-- Name: fn_is_admin(); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_is_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM security.user_roles ur
    JOIN security.roles r ON ur.role_id = r.id
    WHERE ur.user_id = current_setting('app.user_id')::bigint
      AND r.code IN ('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN')
  );
$$;


--

-- Name: fn_is_admin(bigint); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_is_admin(p_user_id bigint) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM security.user_roles ur
    JOIN security.roles r ON ur.role_id = r.id
    WHERE ur.user_id = p_user_id
      AND r.code IN ('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN')
  );
$$;


--

-- Name: fn_is_committee_member_for_application(bigint, bigint); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_is_committee_member_for_application(p_user_id bigint, p_application_id bigint) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM core.applications a
    JOIN committee.committee_members cm
      ON cm.committee_id = a.target_committee_id
    WHERE a.id = p_application_id
      AND cm.user_id = p_user_id
      AND cm.is_active = true
  );
$$;


--

-- Name: fn_log_audit(); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_log_audit() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_audit_log_id BIGINT;
    v_user_id BIGINT;
    v_operation VARCHAR(50);
    v_source_ip INET;
    v_old_json JSONB;
    v_new_json JSONB;
    v_key TEXT;
    v_old_val TEXT;
    v_new_val TEXT;
BEGIN
    -- Operation type
    IF TG_OP = 'INSERT' THEN v_operation := 'CREATE';
    ELSIF TG_OP = 'UPDATE' THEN v_operation := 'UPDATE';
    ELSIF TG_OP = 'DELETE' THEN v_operation := 'DELETE';
    END IF;

    -- User ID from session
    BEGIN
        v_user_id := current_setting('app.user_id')::BIGINT;
        IF v_user_id = 0 THEN v_user_id := NULL;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        v_user_id := NULL;
    END;

    -- Source IP from session (set by backend per-query)
    BEGIN
        v_source_ip := current_setting('app.source_ip')::INET;
        IF v_source_ip = '0.0.0.0'::INET THEN v_source_ip := NULL;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        v_source_ip := NULL;
    END;

    -- Build old/new JSONB snapshots
    IF TG_OP = 'DELETE' OR TG_OP = 'UPDATE' THEN
        v_old_json := to_jsonb(OLD);
    END IF;
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        v_new_json := to_jsonb(NEW);
    END IF;

    -- Insert main audit log
    BEGIN
        INSERT INTO audit.audit_logs (user_id, entity_name, entity_id, operation_type, source_ip, old_values, new_values)
        VALUES (
            v_user_id,
            TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
            CASE WHEN TG_OP = 'INSERT' THEN NEW.id WHEN TG_OP = 'UPDATE' THEN NEW.id ELSE OLD.id END,
            v_operation,
            v_source_ip,
            v_old_json,
            v_new_json
        )
        RETURNING id INTO v_audit_log_id;
    EXCEPTION WHEN foreign_key_violation THEN
        INSERT INTO audit.audit_logs (user_id, entity_name, entity_id, operation_type, source_ip, old_values, new_values)
        VALUES (
            NULL,
            TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
            CASE WHEN TG_OP = 'INSERT' THEN NEW.id WHEN TG_OP = 'UPDATE' THEN NEW.id ELSE OLD.id END,
            v_operation,
            v_source_ip,
            v_old_json,
            v_new_json
        )
        RETURNING id INTO v_audit_log_id;
    END;

    -- Field-level details for UPDATE (only changed columns)
    IF TG_OP = 'UPDATE' THEN
        FOR v_key IN SELECT jsonb_object_keys(v_old_json) INTERSECT SELECT jsonb_object_keys(v_new_json)
        LOOP
            v_old_val := v_old_json->>v_key;
            v_new_val := v_new_json->>v_key;
            IF v_old_val IS DISTINCT FROM v_new_val THEN
                INSERT INTO audit.audit_details (audit_log_id, field_name, old_value, new_value)
                VALUES (v_audit_log_id, v_key, v_old_val, v_new_val);
            END IF;
        END LOOP;
    END IF;

    RETURN NEW;
END;
$$;


--

-- Name: fn_notify_status_change(); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_notify_status_change() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_user_id BIGINT;
    v_message TEXT;
BEGIN
    IF TG_TABLE_NAME = 'applications' AND OLD.current_status IS DISTINCT FROM NEW.current_status THEN
        v_user_id := NEW.submitted_by;
        v_message := 'تم تغيير حالة الطلب ' || NEW.application_number || ' إلى ' || NEW.current_status;

        INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, priority_level)
        VALUES (v_user_id, 'STATUS_CHANGE', 'تحديث حالة الطلب', v_message, 'NORMAL');

        -- Outbox event
        INSERT INTO integration.event_outbox (event_type, aggregate_type, aggregate_id, event_data)
        VALUES (
            'APPLICATION_STATUS_CHANGED',
            'Application',
            NEW.id,
            jsonb_build_object('application_number', NEW.application_number, 'old_status', OLD.current_status, 'new_status', NEW.current_status)
        );
    END IF;

    RETURN NEW;
END;
$$;


--

-- Name: fn_update_updated_at(); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_update_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--

-- Name: is_active_row(timestamp with time zone); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.is_active_row(p_deleted_at timestamp with time zone) RETURNS boolean
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $$
SELECT p_deleted_at IS NULL;
$$;


--




