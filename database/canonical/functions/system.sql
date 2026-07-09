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


