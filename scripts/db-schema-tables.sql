--
-- PostgreSQL database dump
--

\restrict J1bMektdHyK22rHWR2HxpX1Dbrb4IFQojz2vffa9xqTykAximIaE55w1mhvupTk

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: audit; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA audit;


--
-- Name: committee; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA committee;


--
-- Name: communication; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA communication;


--
-- Name: core; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA core;


--
-- Name: documents; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA documents;


--
-- Name: integration; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA integration;


--
-- Name: monitoring; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA monitoring;


--
-- Name: reference; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA reference;


--
-- Name: reporting; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA reporting;


--
-- Name: safety; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA safety;


--
-- Name: security; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA security;


--
-- Name: system; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA system;


--
-- Name: workflow; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA workflow;


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: fn_current_user_id(); Type: FUNCTION; Schema: communication; Owner: -
--

CREATE FUNCTION communication.fn_current_user_id() RETURNS bigint
    LANGUAGE sql STABLE
    AS $$ SELECT (current_setting('app.user_id', true))::BIGINT; $$;


--
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
-- Name: fn_auto_transition(character varying, bigint, bigint, text); Type: FUNCTION; Schema: system; Owner: -
--

CREATE FUNCTION system.fn_auto_transition(p_entity_type character varying, p_entity_id bigint, p_action_by bigint, p_comment text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_instance_id       BIGINT;
    v_workflow_id       BIGINT;
    v_current_state_id  BIGINT;
    v_target_state_id   BIGINT;
    v_transition_id     BIGINT;
    v_result            JSONB;
BEGIN
    -- Get workflow instance
    SELECT id, workflow_id, current_state_id INTO v_instance_id, v_workflow_id, v_current_state_id
    FROM workflow.workflow_instances
    WHERE entity_type = p_entity_type AND entity_id = p_entity_id AND status_code = 'ACTIVE';

    IF NOT FOUND THEN
        RETURN jsonb_build_object('success', FALSE, 'error', 'No active workflow instance found');
    END IF;

    -- Get the transition (auto-transition: from current to next state where from_state = current)
    -- For now, we find the single next state after the current one
    SELECT t.id, t.to_state_id INTO v_transition_id, v_target_state_id
    FROM workflow.workflow_transitions t
    WHERE t.workflow_id = v_workflow_id
    AND t.from_state_id = v_current_state_id
    ORDER BY t.id
    LIMIT 1;

    IF NOT FOUND THEN
        RETURN jsonb_build_object('success', FALSE, 'error', 'No valid transition found from current state');
    END IF;

    -- Record the action
    INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment)
    VALUES (v_instance_id, v_transition_id, p_action_by, p_comment);

    -- Record history
    INSERT INTO workflow.workflow_history (workflow_instance_id, from_state_id, to_state_id, transition_id, action_by, comments)
    VALUES (v_instance_id, v_current_state_id, v_target_state_id, v_transition_id, p_action_by, p_comment);

    -- Update instance
    UPDATE workflow.workflow_instances
    SET current_state_id = v_target_state_id
    WHERE id = v_instance_id;

    -- Log to outbox
    INSERT INTO integration.event_outbox (event_type, aggregate_type, aggregate_id, event_data)
    VALUES (
        'WORKFLOW_TRANSITION',
        p_entity_type,
        p_entity_id,
        jsonb_build_object(
            'workflow_instance_id', v_instance_id,
            'from_state', v_current_state_id,
            'to_state', v_target_state_id,
            'transition_id', v_transition_id,
            'action_by', p_action_by
        )
    );

    v_result := jsonb_build_object(
        'success', TRUE,
        'instance_id', v_instance_id,
        'from_state', v_current_state_id,
        'to_state', v_target_state_id
    );

    RETURN v_result;
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
    -- Get workflow definition
    SELECT id INTO v_workflow_id
    FROM workflow.workflows
    WHERE workflow_code = p_workflow_code AND is_active = TRUE;

    -- Get initial state
    SELECT id INTO v_initial_state
    FROM workflow.workflow_states
    WHERE workflow_id = v_workflow_id AND is_initial = TRUE;

    -- Create instance
    INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id)
    VALUES (v_workflow_id, p_entity_type, p_entity_id, v_initial_state)
    RETURNING id INTO v_instance_id;

    RETURN v_instance_id;
END;
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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_details; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.audit_details (
    id bigint NOT NULL,
    audit_log_id bigint NOT NULL,
    field_name character varying(200) NOT NULL,
    old_value text,
    new_value text
);


--
-- Name: audit_details_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

ALTER TABLE audit.audit_details ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME audit.audit_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: audit_logs; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.audit_logs (
    id bigint NOT NULL,
    user_id bigint,
    entity_name character varying(200) NOT NULL,
    entity_id bigint,
    operation_type character varying(50) NOT NULL,
    source_ip inet,
    event_timestamp timestamp with time zone DEFAULT now() NOT NULL,
    old_values jsonb,
    new_values jsonb
);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

ALTER TABLE audit.audit_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME audit.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: entity_changes; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.entity_changes (
    id bigint NOT NULL,
    entity_name character varying(200) NOT NULL,
    entity_id bigint NOT NULL,
    change_type character varying(50) NOT NULL,
    changed_by bigint,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    details jsonb
);


--
-- Name: entity_changes_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

ALTER TABLE audit.entity_changes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME audit.entity_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hash_ledger; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.hash_ledger (
    id bigint NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    previous_hash character varying(256),
    current_hash character varying(256) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: hash_ledger_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.hash_ledger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hash_ledger_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.hash_ledger_id_seq OWNED BY audit.hash_ledger.id;


--
-- Name: agenda_items; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.agenda_items (
    id bigint NOT NULL,
    agenda_id bigint NOT NULL,
    application_id bigint,
    item_order integer NOT NULL,
    title character varying(500) NOT NULL,
    discussion_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_agenda_items_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: agenda_items_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.agenda_items ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.agenda_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: attendance_logs; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.attendance_logs (
    id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    user_id bigint NOT NULL,
    attendance_status character varying(50) NOT NULL,
    check_in_time timestamp with time zone,
    remarks text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_attendance_logs_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: attendance_logs_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.attendance_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.attendance_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: committee_meetings; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.committee_meetings (
    id bigint NOT NULL,
    committee_id bigint NOT NULL,
    meeting_number character varying(100) NOT NULL,
    meeting_date timestamp with time zone NOT NULL,
    location character varying(500),
    meeting_status character varying(50) DEFAULT 'SCHEDULED'::character varying NOT NULL,
    chairperson_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_committee_meetings_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: committee_meetings_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.committee_meetings ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.committee_meetings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: committee_member_roles; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.committee_member_roles (
    id bigint NOT NULL,
    member_id bigint NOT NULL,
    role_id bigint NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    assigned_by bigint
);


--
-- Name: committee_member_roles_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.committee_member_roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.committee_member_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: committee_members; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.committee_members (
    id bigint NOT NULL,
    committee_id bigint NOT NULL,
    user_id bigint NOT NULL,
    membership_start_date date NOT NULL,
    membership_end_date date,
    is_active boolean DEFAULT true NOT NULL,
    role_id bigint,
    created_by bigint,
    created_at timestamp with time zone DEFAULT now(),
    updated_by bigint,
    updated_at timestamp with time zone
);


--
-- Name: committee_members_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.committee_members ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.committee_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: committee_roles; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.committee_roles (
    id bigint NOT NULL,
    role_code character varying(100) NOT NULL,
    role_name character varying(200) NOT NULL,
    description text
);


--
-- Name: committee_roles_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.committee_roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.committee_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: committee_types; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.committee_types (
    id bigint NOT NULL,
    type_code character varying(100) NOT NULL,
    type_name character varying(300) NOT NULL,
    description text
);


--
-- Name: committee_types_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.committee_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.committee_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: committees; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.committees (
    id bigint NOT NULL,
    institution_id bigint NOT NULL,
    committee_code character varying(100) NOT NULL,
    committee_name_ar character varying(500) NOT NULL,
    committee_name_en character varying(500),
    committee_type_id bigint,
    establishment_date date,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_committees_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: committees_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.committees ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.committees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ethics_reviews; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.ethics_reviews (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    review_status character varying(50) DEFAULT 'ASSIGNED'::character varying NOT NULL,
    recommendation character varying(100),
    ethical_risk_assessment text,
    summary text,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_ethics_reviews_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: ethics_reviews_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.ethics_reviews ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.ethics_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: meeting_agendas; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.meeting_agendas (
    id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    title character varying(500) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_meeting_agendas_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: meeting_agendas_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.meeting_agendas ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.meeting_agendas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: meeting_minutes; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.meeting_minutes (
    id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    minutes_text text NOT NULL,
    approved_by bigint,
    approved_at timestamp with time zone,
    created_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_meeting_minutes_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: meeting_minutes_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.meeting_minutes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.meeting_minutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: member_conflicts; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.member_conflicts (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    member_id bigint NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id bigint NOT NULL,
    conflict_type character varying(50) NOT NULL,
    description text,
    declared_at timestamp with time zone DEFAULT now() NOT NULL,
    resolved_at timestamp with time zone,
    resolution_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_member_conflicts_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: member_conflicts_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.member_conflicts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.member_conflicts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: member_qualifications; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.member_qualifications (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    member_id bigint NOT NULL,
    specialization character varying(200) NOT NULL,
    academic_degree character varying(100) NOT NULL,
    institution_name character varying(300),
    experience_years integer,
    certificate_url text,
    is_verified boolean DEFAULT false NOT NULL,
    verified_by bigint,
    verified_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_member_qualifications_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: member_qualifications_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.member_qualifications ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.member_qualifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: member_terms; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.member_terms (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    member_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date,
    appointment_decision_no character varying(100),
    appointment_decision_date date,
    termination_decision_no character varying(100),
    termination_decision_date date,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_member_terms_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: member_terms_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.member_terms ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.member_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: quorum_logs; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.quorum_logs (
    id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    total_members integer NOT NULL,
    present_members integer NOT NULL,
    quorum_required integer NOT NULL,
    quorum_achieved boolean NOT NULL,
    calculated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_quorum_logs_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: quorum_logs_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.quorum_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.quorum_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: review_answers; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_answers (
    id bigint NOT NULL,
    review_id bigint NOT NULL,
    review_type character varying(50) NOT NULL,
    question_id bigint NOT NULL,
    answer_text text,
    answer_score numeric(10,2),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: review_answers_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_answers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: review_assignments; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_assignments (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    review_type character varying(50) NOT NULL,
    assigned_by bigint,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    due_date timestamp with time zone,
    status_code character varying(50) DEFAULT 'ASSIGNED'::character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_review_assignments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: review_assignments_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_assignments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: review_comments; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_comments (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    comment_text text NOT NULL,
    is_internal boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_review_comments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: review_comments_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_comments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: review_conflicts; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_conflicts (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    conflict_type character varying(100) NOT NULL,
    description text,
    declared_at timestamp with time zone DEFAULT now() NOT NULL,
    approved_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_review_conflicts_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: review_conflicts_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_conflicts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_conflicts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: review_forms; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_forms (
    id bigint NOT NULL,
    form_code character varying(100) NOT NULL,
    form_name character varying(300) NOT NULL,
    review_type character varying(50) NOT NULL,
    version_no integer DEFAULT 1 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_review_forms_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: review_forms_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_forms ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: review_questions; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_questions (
    id bigint NOT NULL,
    form_id bigint NOT NULL,
    question_code character varying(100) NOT NULL,
    question_text text NOT NULL,
    question_type character varying(50) NOT NULL,
    display_order integer NOT NULL,
    is_required boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    question_options text,
    CONSTRAINT chk_committee_review_questions_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: review_questions_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_questions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: review_recommendations; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_recommendations (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    recommendation_type character varying(100) NOT NULL,
    justification text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_review_recommendations_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: review_recommendations_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_recommendations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_recommendations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: review_scores; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.review_scores (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    review_type character varying(50) NOT NULL,
    score numeric(10,2) NOT NULL,
    calculated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_review_scores_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: review_scores_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.review_scores ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.review_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: scientific_reviews; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.scientific_reviews (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    review_status character varying(50) DEFAULT 'ASSIGNED'::character varying NOT NULL,
    recommendation character varying(100),
    summary text,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_scientific_reviews_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: scientific_reviews_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.scientific_reviews ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.scientific_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: votes; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.votes (
    id bigint NOT NULL,
    voting_session_id bigint NOT NULL,
    voter_id bigint NOT NULL,
    vote_value character varying(50) NOT NULL,
    vote_time timestamp with time zone DEFAULT now() NOT NULL,
    comments text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_votes_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.votes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: voting_sessions; Type: TABLE; Schema: committee; Owner: -
--

CREATE TABLE committee.voting_sessions (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    voting_type character varying(50) NOT NULL,
    voting_start timestamp with time zone,
    voting_end timestamp with time zone,
    status_code character varying(50) DEFAULT 'OPEN'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_committee_voting_sessions_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: voting_sessions_id_seq; Type: SEQUENCE; Schema: committee; Owner: -
--

ALTER TABLE committee.voting_sessions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME committee.voting_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: announcements; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.announcements (
    id bigint NOT NULL,
    title character varying(500) NOT NULL,
    announcement_body text NOT NULL,
    start_date date,
    end_date date,
    is_active boolean DEFAULT true NOT NULL,
    created_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_communication_announcements_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

ALTER TABLE communication.announcements ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME communication.announcements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: message_attachments; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.message_attachments (
    id bigint NOT NULL,
    message_id bigint NOT NULL,
    file_name character varying(500) NOT NULL,
    file_path character varying(1000) NOT NULL,
    file_size integer,
    mime_type character varying(100),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_communication_message_attachments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: message_attachments_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

CREATE SEQUENCE communication.message_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: message_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: communication; Owner: -
--

ALTER SEQUENCE communication.message_attachments_id_seq OWNED BY communication.message_attachments.id;


--
-- Name: message_recipients; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.message_recipients (
    id bigint NOT NULL,
    message_id bigint NOT NULL,
    recipient_id bigint NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    read_at timestamp with time zone,
    is_deleted boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_communication_message_recipients_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: message_recipients_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

CREATE SEQUENCE communication.message_recipients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: message_recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: communication; Owner: -
--

ALTER SEQUENCE communication.message_recipients_id_seq OWNED BY communication.message_recipients.id;


--
-- Name: messages; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.messages (
    id bigint NOT NULL,
    sender_id bigint NOT NULL,
    subject character varying(500) NOT NULL,
    message_body text,
    related_entity_type character varying(50),
    related_entity_id bigint,
    is_deleted boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_communication_messages_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

CREATE SEQUENCE communication.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: communication; Owner: -
--

ALTER SEQUENCE communication.messages_id_seq OWNED BY communication.messages.id;


--
-- Name: notification_channels; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.notification_channels (
    id bigint NOT NULL,
    channel_code character varying(50) NOT NULL,
    channel_name character varying(200) NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: notification_channels_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_channels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME communication.notification_channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: notification_logs; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.notification_logs (
    id bigint NOT NULL,
    notification_id bigint NOT NULL,
    delivery_status character varying(50) NOT NULL,
    provider_reference character varying(500),
    error_message text,
    logged_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: notification_logs_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME communication.notification_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: notification_templates; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.notification_templates (
    id bigint NOT NULL,
    template_code character varying(100) NOT NULL,
    template_name character varying(300) NOT NULL,
    channel_type character varying(50) NOT NULL,
    subject_template text,
    body_template text NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: notification_templates_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_templates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME communication.notification_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: notifications; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.notifications (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    notification_type character varying(100) NOT NULL,
    channel_id bigint,
    subject character varying(500),
    message_body text NOT NULL,
    priority_level character varying(50) DEFAULT 'NORMAL'::character varying,
    is_read boolean DEFAULT false NOT NULL,
    sent_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_communication_notifications_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

ALTER TABLE communication.notifications ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME communication.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: amendment_requests; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.amendment_requests (
    id bigint NOT NULL,
    amendment_id bigint NOT NULL,
    request_date timestamp with time zone DEFAULT now() NOT NULL,
    request_status character varying(50) NOT NULL,
    decision_date timestamp with time zone,
    comments text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_amendment_requests_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: amendment_requests_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.amendment_requests ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.amendment_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: application_amendments; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_amendments (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    amendment_number character varying(100) NOT NULL,
    amendment_reason text NOT NULL,
    amendment_description text,
    submitted_by bigint,
    submitted_at timestamp with time zone,
    status_code character varying(50) DEFAULT 'DRAFT'::character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_application_amendments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: application_amendments_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_amendments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_amendments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: application_checklists; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_checklists (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    checklist_item character varying(500) NOT NULL,
    is_completed boolean DEFAULT false NOT NULL,
    completed_at timestamp with time zone,
    completed_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_application_checklists_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: application_checklists_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_checklists ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_checklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: application_history; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_history (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    action_type character varying(100) NOT NULL,
    old_value text,
    new_value text,
    action_by bigint,
    action_at timestamp with time zone DEFAULT now() NOT NULL,
    remarks text
);


--
-- Name: application_history_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: application_sections; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_sections (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    section_code character varying(100) NOT NULL,
    section_name character varying(300) NOT NULL,
    completion_percentage numeric(5,2) DEFAULT 0,
    status_code character varying(50) DEFAULT 'INCOMPLETE'::character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_application_sections_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: application_sections_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_sections ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: application_validations; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_validations (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    validation_rule character varying(300) NOT NULL,
    validation_result boolean NOT NULL,
    validation_message text,
    validated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_application_validations_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: application_validations_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_validations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_validations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: application_versions; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.application_versions (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    version_no integer NOT NULL,
    snapshot_data jsonb NOT NULL,
    created_by bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: application_versions_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.application_versions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.application_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: applications; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.applications (
    id bigint NOT NULL,
    application_number character varying(100) NOT NULL,
    project_id bigint NOT NULL,
    application_type character varying(50) NOT NULL,
    current_status character varying(50) DEFAULT 'DRAFT'::character varying NOT NULL,
    submission_date timestamp with time zone,
    submitted_by bigint,
    priority_level character varying(50),
    target_committee_id bigint,
    remarks text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_applications_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: applications_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.applications ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: closure_requests; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.closure_requests (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    closure_reason text NOT NULL,
    closure_summary text,
    submitted_at timestamp with time zone,
    status_code character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_closure_requests_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: closure_requests_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.closure_requests ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.closure_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: project_attachments; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_attachments (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    document_name character varying(500) NOT NULL,
    file_path text NOT NULL,
    file_size bigint,
    mime_type character varying(200),
    uploaded_by bigint,
    uploaded_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_attachments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: project_attachments_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_attachments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: project_funding_sources; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_funding_sources (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    funding_source_name character varying(500) NOT NULL,
    funding_type character varying(100),
    amount numeric(18,2),
    currency_code character varying(10),
    funding_reference character varying(200),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_funding_sources_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: project_funding_sources_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_funding_sources ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_funding_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: project_keywords; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_keywords (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    keyword character varying(200) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_keywords_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: project_keywords_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_keywords ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_keywords_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: project_site_investigators; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_site_investigators (
    id bigint NOT NULL,
    site_id bigint NOT NULL,
    investigator_id bigint NOT NULL,
    is_site_lead boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_site_investigators_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: project_site_investigators_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_site_investigators ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_site_investigators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: project_sites; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_sites (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    site_name character varying(500) NOT NULL,
    governorate character varying(100),
    address text,
    expected_participants integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_sites_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: project_sites_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_sites ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: project_status_history; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_status_history (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    old_status character varying(50),
    new_status character varying(50) NOT NULL,
    changed_by bigint,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    remarks text
);


--
-- Name: project_status_history_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_status_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_status_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: project_tags; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_tags (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    tag_name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_tags_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: project_tags_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_tags ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: project_team_members; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_team_members (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_name character varying(200) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_project_team_members_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: project_team_members_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_team_members ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_team_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: project_versions; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.project_versions (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    version_no integer NOT NULL,
    version_notes text,
    snapshot_data jsonb NOT NULL,
    created_by bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: project_versions_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.project_versions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.project_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: projects; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.projects (
    id bigint NOT NULL,
    institution_id bigint NOT NULL,
    project_code character varying(100) NOT NULL,
    title_ar character varying(1000) NOT NULL,
    title_en character varying(1000),
    abstract_ar text,
    abstract_en text,
    objectives text,
    principal_investigator_id bigint NOT NULL,
    research_category character varying(100),
    risk_level character varying(50),
    status_code character varying(50) DEFAULT 'DRAFT'::character varying NOT NULL,
    start_date date,
    expected_end_date date,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_projects_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.projects ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: renewal_requests; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.renewal_requests (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    renewal_period_months integer,
    justification text,
    submitted_at timestamp with time zone,
    status_code character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_renewal_requests_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: renewal_requests_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.renewal_requests ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.renewal_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: research_categories; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.research_categories (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_research_categories_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: research_categories_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.research_categories ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.research_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: research_population_links; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.research_population_links (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id bigint NOT NULL,
    vulnerable_population_id bigint NOT NULL,
    safeguard_measures text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_research_population_links_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: research_population_links_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.research_population_links ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.research_population_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: risk_classifications; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.risk_classifications (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    severity_level integer DEFAULT 1 NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_risk_classifications_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: risk_classifications_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.risk_classifications ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.risk_classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: vulnerable_populations; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.vulnerable_populations (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    description text,
    safeguards_required text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_core_vulnerable_populations_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: vulnerable_populations_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.vulnerable_populations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.vulnerable_populations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document_access; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_access (
    id bigint NOT NULL,
    document_id bigint NOT NULL,
    user_id bigint,
    role_id bigint,
    access_type character varying(50) NOT NULL,
    granted_by bigint,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_document_access_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: document_access_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_access ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document_approvals; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_approvals (
    id bigint NOT NULL,
    document_id bigint NOT NULL,
    approver_id bigint NOT NULL,
    approval_status character varying(50) NOT NULL,
    approval_comments text,
    approved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_document_approvals_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: document_approvals_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_approvals ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_approvals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document_audit; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_audit (
    id bigint NOT NULL,
    document_id bigint NOT NULL,
    action_type character varying(100) NOT NULL,
    action_by bigint,
    action_timestamp timestamp with time zone DEFAULT now() NOT NULL,
    source_ip inet,
    details jsonb
);


--
-- Name: document_audit_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_audit ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document_classifications; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_classifications (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    description text,
    clearance_required character varying(50),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: document_classifications_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_classifications ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document_disposal_logs; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_disposal_logs (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    document_id bigint NOT NULL,
    disposed_at timestamp with time zone DEFAULT now() NOT NULL,
    disposed_by bigint NOT NULL,
    disposal_method character varying(50) NOT NULL,
    authorization_ref character varying(100),
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: document_disposal_logs_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_disposal_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_disposal_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document_retention_rules; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_retention_rules (
    id bigint NOT NULL,
    document_type_id bigint NOT NULL,
    retention_period_days integer NOT NULL,
    disposition_action character varying(50) DEFAULT 'ARCHIVE'::character varying NOT NULL,
    legal_basis text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: document_retention_rules_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_retention_rules ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_retention_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document_signatures; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_signatures (
    id bigint NOT NULL,
    document_id bigint NOT NULL,
    signer_id bigint NOT NULL,
    signature_type character varying(100) NOT NULL,
    signature_hash text,
    signed_at timestamp with time zone NOT NULL,
    certificate_serial character varying(500),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_document_signatures_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: document_signatures_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_signatures ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_signatures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document_types; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_types (
    id bigint NOT NULL,
    type_code character varying(100) NOT NULL,
    type_name_ar character varying(300) NOT NULL,
    type_name_en character varying(300),
    description text,
    is_required boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: document_types_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document_versions; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.document_versions (
    id bigint NOT NULL,
    document_id bigint NOT NULL,
    version_no integer NOT NULL,
    file_name character varying(1000) NOT NULL,
    storage_path text NOT NULL,
    checksum_sha256 character varying(128),
    uploaded_by bigint NOT NULL,
    uploaded_at timestamp with time zone DEFAULT now() NOT NULL,
    version_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_document_versions_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: document_versions_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.document_versions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.document_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: documents; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.documents (
    id bigint NOT NULL,
    document_type_id bigint NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    document_title character varying(1000) NOT NULL,
    file_name character varying(1000) NOT NULL,
    original_file_name character varying(1000),
    mime_type character varying(255),
    file_size_bytes bigint,
    storage_provider character varying(100),
    storage_path text NOT NULL,
    checksum_sha256 character varying(128),
    uploaded_by bigint NOT NULL,
    uploaded_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_documents_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.documents ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: generated_documents; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.generated_documents (
    id bigint NOT NULL,
    template_id bigint NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    generated_document_id bigint,
    generated_by bigint NOT NULL,
    generated_at timestamp with time zone DEFAULT now() NOT NULL,
    generation_parameters jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_generated_documents_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: generated_documents_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.generated_documents ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.generated_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: templates; Type: TABLE; Schema: documents; Owner: -
--

CREATE TABLE documents.templates (
    id bigint NOT NULL,
    template_code character varying(100) NOT NULL,
    template_name character varying(500) NOT NULL,
    template_type character varying(100) NOT NULL,
    template_content text NOT NULL,
    version_no integer DEFAULT 1 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_documents_templates_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: templates_id_seq; Type: SEQUENCE; Schema: documents; Owner: -
--

ALTER TABLE documents.templates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME documents.templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: data_sync_jobs; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.data_sync_jobs (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    external_system_id bigint NOT NULL,
    sync_direction character varying(10) DEFAULT 'BIDIRECTIONAL'::character varying NOT NULL,
    entity_type character varying(100) NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    records_processed integer DEFAULT 0,
    records_failed integer DEFAULT 0,
    status character varying(30) DEFAULT 'RUNNING'::character varying NOT NULL,
    error_log text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_integration_data_sync_jobs_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: data_sync_jobs_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.data_sync_jobs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.data_sync_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: event_bus_config; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.event_bus_config (
    id bigint NOT NULL,
    config_key character varying(200) NOT NULL,
    config_value text NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: event_bus_config_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.event_bus_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.event_bus_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: event_outbox; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.event_outbox (
    id bigint NOT NULL,
    event_id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_type character varying(200) NOT NULL,
    aggregate_type character varying(100) NOT NULL,
    aggregate_id bigint NOT NULL,
    event_data jsonb NOT NULL,
    metadata jsonb,
    status character varying(50) DEFAULT 'PENDING'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    processed_at timestamp with time zone,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_event_outbox_status CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'PROCESSING'::character varying, 'COMPLETED'::character varying, 'FAILED'::character varying])::text[]))),
    CONSTRAINT chk_integration_event_outbox_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: event_outbox_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.event_outbox ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.event_outbox_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: event_subscriptions; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.event_subscriptions (
    id bigint NOT NULL,
    subscription_name character varying(300) NOT NULL,
    event_type character varying(200) NOT NULL,
    endpoint_url text,
    handler_class character varying(500),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: event_subscriptions_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.event_subscriptions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.event_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: external_systems; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.external_systems (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    system_type character varying(100) NOT NULL,
    base_url character varying(500),
    is_active boolean DEFAULT true NOT NULL,
    supports_webhook boolean DEFAULT false NOT NULL,
    supports_api boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: external_systems_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.external_systems ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.external_systems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: integration_credentials; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.integration_credentials (
    id bigint NOT NULL,
    external_system_id bigint NOT NULL,
    credential_type character varying(50) DEFAULT 'API_KEY'::character varying NOT NULL,
    credential_key character varying(200) NOT NULL,
    credential_value text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    expires_at timestamp with time zone,
    last_used_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: integration_credentials_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.integration_credentials ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.integration_credentials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: integration_failures; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.integration_failures (
    id bigint NOT NULL,
    external_system_id bigint,
    endpoint character varying(500) NOT NULL,
    error_message text NOT NULL,
    error_code character varying(100),
    request_payload text,
    response_payload text,
    retry_count integer DEFAULT 0 NOT NULL,
    max_retries integer DEFAULT 3 NOT NULL,
    status character varying(30) DEFAULT 'NEW'::character varying NOT NULL,
    resolved_at timestamp with time zone,
    resolved_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: integration_failures_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.integration_failures ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.integration_failures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: integration_logs; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.integration_logs (
    id bigint NOT NULL,
    integration_type character varying(100) NOT NULL,
    direction character varying(10) NOT NULL,
    status character varying(50) NOT NULL,
    request_url text,
    request_body text,
    response_code integer,
    response_body text,
    error_message text,
    duration_ms integer,
    created_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: integration_logs_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.integration_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.integration_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: retry_queue; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.retry_queue (
    id bigint NOT NULL,
    source character varying(100) NOT NULL,
    payload jsonb NOT NULL,
    error_message text,
    retry_count integer DEFAULT 0 NOT NULL,
    max_retries integer DEFAULT 5 NOT NULL,
    next_retry_at timestamp with time zone,
    status character varying(50) DEFAULT 'PENDING'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    last_attempt_at timestamp with time zone,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_integration_retry_queue_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL))),
    CONSTRAINT chk_retry_queue_status CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'IN_PROGRESS'::character varying, 'COMPLETED'::character varying, 'FAILED'::character varying])::text[])))
);


--
-- Name: retry_queue_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.retry_queue ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.retry_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: webhooks; Type: TABLE; Schema: integration; Owner: -
--

CREATE TABLE integration.webhooks (
    id bigint NOT NULL,
    webhook_name character varying(300) NOT NULL,
    webhook_url text NOT NULL,
    secret_key text,
    events text[] NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    timeout_seconds integer DEFAULT 30 NOT NULL,
    retry_count integer DEFAULT 3 NOT NULL,
    last_called_at timestamp with time zone,
    last_status character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_integration_webhooks_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: webhooks_id_seq; Type: SEQUENCE; Schema: integration; Owner: -
--

ALTER TABLE integration.webhooks ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME integration.webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: compliance_reviews; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.compliance_reviews (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    review_date date NOT NULL,
    compliance_score numeric(5,2),
    summary text,
    status_code character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_compliance_reviews_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: compliance_reviews_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.compliance_reviews ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.compliance_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: corrective_actions; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.corrective_actions (
    id bigint NOT NULL,
    finding_id bigint NOT NULL,
    action_description text NOT NULL,
    responsible_user_id bigint,
    target_completion_date date,
    completion_date date,
    status_code character varying(50) DEFAULT 'OPEN'::character varying NOT NULL
);


--
-- Name: corrective_actions_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.corrective_actions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.corrective_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: deviations; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.deviations (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    deviation_code character varying(100),
    deviation_date date NOT NULL,
    deviation_type character varying(100),
    description text NOT NULL,
    reported_by bigint,
    reported_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_deviations_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: deviations_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.deviations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.deviations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: inspection_reports; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.inspection_reports (
    id bigint NOT NULL,
    inspection_id bigint NOT NULL,
    report_number character varying(100),
    findings_summary text,
    recommendations text,
    submitted_at timestamp with time zone,
    approved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_inspection_reports_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: inspection_reports_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.inspection_reports ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.inspection_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: inspections; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.inspections (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    inspection_type character varying(100) NOT NULL,
    inspection_date date NOT NULL,
    inspector_id bigint,
    status_code character varying(50),
    summary text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_inspections_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: inspections_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.inspections ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.inspections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: monitoring_findings; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.monitoring_findings (
    id bigint NOT NULL,
    monitoring_visit_id bigint NOT NULL,
    finding_type character varying(100) NOT NULL,
    severity character varying(50) NOT NULL,
    description text NOT NULL,
    recommendation text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_monitoring_findings_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: monitoring_findings_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.monitoring_findings ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.monitoring_findings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: monitoring_plans; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.monitoring_plans (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    plan_code character varying(100) NOT NULL,
    monitoring_type character varying(100) NOT NULL,
    frequency_type character varying(100),
    planned_start_date date,
    planned_end_date date,
    status_code character varying(50) DEFAULT 'ACTIVE'::character varying NOT NULL,
    created_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_monitoring_plans_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: monitoring_plans_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.monitoring_plans ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.monitoring_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: monitoring_visits; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.monitoring_visits (
    id bigint NOT NULL,
    monitoring_plan_id bigint NOT NULL,
    visit_date date NOT NULL,
    monitor_id bigint,
    visit_status character varying(50) NOT NULL,
    observations text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_monitoring_visits_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: monitoring_visits_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.monitoring_visits ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.monitoring_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: preventive_actions; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.preventive_actions (
    id bigint NOT NULL,
    finding_id bigint NOT NULL,
    action_description text NOT NULL,
    responsible_user_id bigint,
    target_completion_date date,
    completion_date date,
    status_code character varying(50) DEFAULT 'OPEN'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_preventive_actions_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: preventive_actions_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.preventive_actions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.preventive_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: protocol_violations; Type: TABLE; Schema: monitoring; Owner: -
--

CREATE TABLE monitoring.protocol_violations (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    violation_date date NOT NULL,
    severity character varying(50) NOT NULL,
    description text NOT NULL,
    corrective_action_required boolean DEFAULT true NOT NULL,
    status_code character varying(50) DEFAULT 'OPEN'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_monitoring_protocol_violations_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: protocol_violations_id_seq; Type: SEQUENCE; Schema: monitoring; Owner: -
--

ALTER TABLE monitoring.protocol_violations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME monitoring.protocol_violations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: perf_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.perf_results (
    stage_name text,
    query_name text,
    avg_ms numeric,
    min_ms numeric,
    max_ms numeric
);


--
-- Name: pgmigrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pgmigrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    run_on timestamp without time zone NOT NULL
);


--
-- Name: pgmigrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pgmigrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pgmigrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pgmigrations_id_seq OWNED BY public.pgmigrations.id;


--
-- Name: application_statuses; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.application_statuses (
    id bigint NOT NULL,
    status_code character varying(100) NOT NULL,
    status_name_ar character varying(300) NOT NULL,
    status_name_en character varying(300),
    display_order integer DEFAULT 1,
    is_terminal boolean DEFAULT false
);


--
-- Name: application_statuses_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.application_statuses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.application_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: committee_decision_types; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.committee_decision_types (
    id bigint NOT NULL,
    decision_code character varying(100) NOT NULL,
    decision_name character varying(300) NOT NULL,
    is_approval boolean DEFAULT false NOT NULL
);


--
-- Name: committee_decision_types_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.committee_decision_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.committee_decision_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: document_statuses; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.document_statuses (
    id bigint NOT NULL,
    status_code character varying(50) NOT NULL,
    status_name character varying(200) NOT NULL
);


--
-- Name: document_statuses_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.document_statuses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.document_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: institutions_registry; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.institutions_registry (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    national_id character varying(50) NOT NULL,
    name_ar character varying(300) NOT NULL,
    name_en character varying(300),
    type character varying(100) NOT NULL,
    address text,
    city character varying(100),
    country character varying(100) DEFAULT 'Yemen'::character varying NOT NULL,
    phone character varying(50),
    email character varying(200),
    website character varying(200),
    is_accredited boolean DEFAULT false NOT NULL,
    accreditation_body character varying(200),
    license_number character varying(100),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: institutions_registry_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.institutions_registry ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.institutions_registry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: licenses_registry; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.licenses_registry (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id bigint,
    profession_id bigint,
    license_number character varying(100) NOT NULL,
    issuing_body character varying(200),
    issued_date date,
    expiry_date date,
    license_document_url text,
    verification_status character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    verified_by bigint,
    verified_at timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: licenses_registry_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.licenses_registry ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.licenses_registry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: lookup_categories; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.lookup_categories (
    id bigint NOT NULL,
    category_code character varying(100) NOT NULL,
    category_name_ar character varying(300) NOT NULL,
    category_name_en character varying(300),
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: lookup_categories_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.lookup_categories ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.lookup_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: lookup_values; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.lookup_values (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    value_code character varying(100) NOT NULL,
    value_name_ar character varying(500) NOT NULL,
    value_name_en character varying(500),
    display_order integer DEFAULT 1,
    is_default boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: lookup_values_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.lookup_values ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.lookup_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: notification_statuses; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.notification_statuses (
    id bigint NOT NULL,
    status_code character varying(50) NOT NULL,
    status_name character varying(200) NOT NULL
);


--
-- Name: notification_statuses_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.notification_statuses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.notification_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: priority_levels; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.priority_levels (
    id bigint NOT NULL,
    priority_code character varying(50) NOT NULL,
    priority_name character varying(200) NOT NULL,
    priority_order integer NOT NULL
);


--
-- Name: priority_levels_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.priority_levels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.priority_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: professions_registry; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.professions_registry (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    category character varying(100),
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: professions_registry_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.professions_registry ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.professions_registry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: review_statuses; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.review_statuses (
    id bigint NOT NULL,
    status_code character varying(100) NOT NULL,
    status_name character varying(300) NOT NULL,
    is_terminal boolean DEFAULT false
);


--
-- Name: review_statuses_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.review_statuses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.review_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: risk_levels; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.risk_levels (
    id bigint NOT NULL,
    risk_code character varying(50) NOT NULL,
    risk_name character varying(200) NOT NULL,
    severity_score integer NOT NULL
);


--
-- Name: risk_levels_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.risk_levels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.risk_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: status_types; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.status_types (
    id bigint NOT NULL,
    status_type_code character varying(100) NOT NULL,
    status_type_name character varying(300) NOT NULL,
    description text
);


--
-- Name: status_types_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.status_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.status_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: vote_types; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.vote_types (
    id bigint NOT NULL,
    vote_code character varying(100) NOT NULL,
    vote_name character varying(300) NOT NULL,
    display_order integer DEFAULT 1 NOT NULL
);


--
-- Name: vote_types_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.vote_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.vote_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_statuses; Type: TABLE; Schema: reference; Owner: -
--

CREATE TABLE reference.workflow_statuses (
    id bigint NOT NULL,
    status_code character varying(100) NOT NULL,
    status_name character varying(300) NOT NULL
);


--
-- Name: workflow_statuses_id_seq; Type: SEQUENCE; Schema: reference; Owner: -
--

ALTER TABLE reference.workflow_statuses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reference.workflow_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: analytics_snapshots; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.analytics_snapshots (
    id bigint NOT NULL,
    snapshot_date date NOT NULL,
    snapshot_type character varying(100) NOT NULL,
    metrics jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: analytics_snapshots_id_seq; Type: SEQUENCE; Schema: reporting; Owner: -
--

ALTER TABLE reporting.analytics_snapshots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reporting.analytics_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: dashboard_widgets; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.dashboard_widgets (
    id bigint NOT NULL,
    widget_code character varying(100) NOT NULL,
    widget_name character varying(300) NOT NULL,
    widget_type character varying(100),
    configuration jsonb,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: dashboard_widgets_id_seq; Type: SEQUENCE; Schema: reporting; Owner: -
--

ALTER TABLE reporting.dashboard_widgets ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reporting.dashboard_widgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kpi_results; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.kpi_results (
    id bigint NOT NULL,
    kpi_code character varying(100) NOT NULL,
    measurement_date date NOT NULL,
    kpi_value numeric(18,4),
    target_value numeric(18,4),
    calculated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: kpi_results_id_seq; Type: SEQUENCE; Schema: reporting; Owner: -
--

ALTER TABLE reporting.kpi_results ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reporting.kpi_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: mv_committee_performance; Type: MATERIALIZED VIEW; Schema: reporting; Owner: -
--

CREATE MATERIALIZED VIEW reporting.mv_committee_performance AS
 SELECT c.id AS committee_id,
    c.committee_name_ar,
    (date_trunc('month'::text, a.created_at))::date AS month,
    count(DISTINCT a.id) AS applications_received,
    count(DISTINCT
        CASE
            WHEN ((a.current_status)::text = ANY ((ARRAY['APPROVED'::character varying, 'CONDITIONAL_APPROVED'::character varying, 'REJECTED'::character varying])::text[])) THEN a.id
            ELSE NULL::bigint
        END) AS applications_decided,
    (avg(
        CASE
            WHEN ((a.current_status)::text = ANY ((ARRAY['APPROVED'::character varying, 'CONDITIONAL_APPROVED'::character varying, 'REJECTED'::character varying])::text[])) THEN (EXTRACT(epoch FROM (a.updated_at - a.created_at)) / (86400)::numeric)
            ELSE NULL::numeric
        END))::numeric(10,2) AS avg_days_to_decision,
    count(DISTINCT mtg.id) AS meetings_held
   FROM ((committee.committees c
     LEFT JOIN core.applications a ON ((a.target_committee_id = c.id)))
     LEFT JOIN committee.committee_meetings mtg ON (((mtg.committee_id = c.id) AND (date_trunc('month'::text, mtg.meeting_date) = date_trunc('month'::text, a.created_at)))))
  GROUP BY c.id, c.committee_name_ar, (date_trunc('month'::text, a.created_at))
  WITH NO DATA;


--
-- Name: mv_daily_application_snapshot; Type: MATERIALIZED VIEW; Schema: reporting; Owner: -
--

CREATE MATERIALIZED VIEW reporting.mv_daily_application_snapshot AS
 SELECT CURRENT_DATE AS snapshot_date,
    a.current_status,
    s.status_name_ar,
    count(*) AS count
   FROM (core.applications a
     LEFT JOIN reference.application_statuses s ON (((a.current_status)::text = (s.status_code)::text)))
  GROUP BY a.current_status, s.status_name_ar
  WITH NO DATA;


--
-- Name: report_definitions; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.report_definitions (
    id bigint NOT NULL,
    report_code character varying(100) NOT NULL,
    report_name character varying(300) NOT NULL,
    report_category character varying(100),
    sql_definition text,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: report_definitions_id_seq; Type: SEQUENCE; Schema: reporting; Owner: -
--

ALTER TABLE reporting.report_definitions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reporting.report_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: report_executions; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.report_executions (
    id bigint NOT NULL,
    report_id bigint NOT NULL,
    executed_by bigint,
    execution_start timestamp with time zone,
    execution_end timestamp with time zone,
    execution_status character varying(50),
    output_file text
);


--
-- Name: report_executions_id_seq; Type: SEQUENCE; Schema: reporting; Owner: -
--

ALTER TABLE reporting.report_executions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reporting.report_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.users (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    institution_id bigint NOT NULL,
    department_id bigint,
    username public.citext NOT NULL,
    email public.citext NOT NULL,
    password_hash text NOT NULL,
    first_name_ar character varying(150),
    last_name_ar character varying(150),
    first_name_en character varying(150),
    last_name_en character varying(150),
    mobile character varying(50),
    status character varying(30) DEFAULT 'ACTIVE'::character varying NOT NULL,
    last_login_at timestamp with time zone,
    is_locked boolean DEFAULT false NOT NULL,
    is_email_verified boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    CONSTRAINT chk_users_status CHECK (((status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'INACTIVE'::character varying, 'LOCKED'::character varying, 'SUSPENDED'::character varying])::text[])))
);


--
-- Name: vw_application_timeline; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_application_timeline AS
 SELECT ah.application_id,
    a.application_number,
    ah.action_type,
    ah.old_value,
    ah.new_value,
    ah.action_by,
    u.username AS action_by_user,
    ah.action_at,
    ah.remarks
   FROM ((core.application_history ah
     JOIN core.applications a ON ((ah.application_id = a.id)))
     LEFT JOIN security.users u ON ((ah.action_by = u.id)))
  ORDER BY ah.action_at DESC;


--
-- Name: vw_committee_members_active; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_committee_members_active AS
 SELECT c.id AS committee_id,
    c.committee_name_ar,
    cm.user_id,
    u.username,
    (((u.first_name_ar)::text || ' '::text) || (u.last_name_ar)::text) AS full_name_ar,
    cm.membership_start_date,
    cm.membership_end_date,
    cr.role_name AS committee_role
   FROM ((((committee.committee_members cm
     JOIN committee.committees c ON ((cm.committee_id = c.id)))
     JOIN security.users u ON ((cm.user_id = u.id)))
     LEFT JOIN committee.committee_member_roles cmr ON ((cmr.member_id = cm.id)))
     LEFT JOIN committee.committee_roles cr ON ((cmr.role_id = cr.id)))
  WHERE (cm.is_active = true);


--
-- Name: vw_dashboard_application_stats; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_dashboard_application_stats AS
 SELECT a.current_status,
    s.status_name_ar AS status_name,
    count(*) AS application_count,
    (((count(*))::numeric * 100.0) / NULLIF(sum(count(*)) OVER (), (0)::numeric)) AS percentage,
    count(
        CASE
            WHEN (a.created_at >= (now() - '30 days'::interval)) THEN 1
            ELSE NULL::integer
        END) AS last_30_days,
    count(
        CASE
            WHEN (a.created_at >= (now() - '7 days'::interval)) THEN 1
            ELSE NULL::integer
        END) AS last_7_days
   FROM (core.applications a
     LEFT JOIN reference.application_statuses s ON (((a.current_status)::text = (s.status_code)::text)))
  GROUP BY a.current_status, s.status_name_ar
  ORDER BY (count(*)) DESC;


--
-- Name: vw_dashboard_committee_workload; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_dashboard_committee_workload AS
 SELECT c.id AS committee_id,
    c.committee_name_ar,
    count(DISTINCT a.id) AS total_applications,
    count(DISTINCT
        CASE
            WHEN ((a.current_status)::text = 'UNDER_REVIEW'::text) THEN a.id
            ELSE NULL::bigint
        END) AS under_review,
    count(DISTINCT
        CASE
            WHEN ((a.current_status)::text = 'SUBMITTED'::text) THEN a.id
            ELSE NULL::bigint
        END) AS pending_review,
    count(DISTINCT cm.id) AS member_count,
    count(DISTINCT mtg.id) AS meeting_count
   FROM (((committee.committees c
     LEFT JOIN core.applications a ON ((a.target_committee_id = c.id)))
     LEFT JOIN committee.committee_members cm ON (((cm.committee_id = c.id) AND (cm.is_active = true))))
     LEFT JOIN committee.committee_meetings mtg ON ((mtg.committee_id = c.id)))
  GROUP BY c.id, c.committee_name_ar;


--
-- Name: institution_types; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.institution_types (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    CONSTRAINT chk_institution_types_code CHECK ((length(TRIM(BOTH FROM code)) > 0))
);


--
-- Name: institutions; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.institutions (
    id bigint NOT NULL,
    institution_type_id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(300) NOT NULL,
    name_en character varying(300),
    license_number character varying(100),
    registration_number character varying(100),
    email character varying(200),
    phone character varying(100),
    address text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint
);


--
-- Name: vw_dashboard_institution_stats; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_dashboard_institution_stats AS
 SELECT i.id AS institution_id,
    i.name_ar AS institution_name,
    it.name_ar AS institution_type,
    count(DISTINCT u.id) AS user_count,
    count(DISTINCT p.id) AS project_count,
    count(DISTINCT a.id) AS application_count,
    count(DISTINCT c.id) AS committee_count
   FROM (((((security.institutions i
     LEFT JOIN security.institution_types it ON ((i.institution_type_id = it.id)))
     LEFT JOIN security.users u ON ((u.institution_id = i.id)))
     LEFT JOIN core.projects p ON ((p.institution_id = i.id)))
     LEFT JOIN core.applications a ON ((a.id IN ( SELECT p2.id
           FROM core.projects p2
          WHERE (p2.institution_id = i.id)))))
     LEFT JOIN committee.committees c ON ((c.institution_id = i.id)))
  GROUP BY i.id, i.name_ar, it.name_ar;


--
-- Name: vw_dashboard_review_times; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_dashboard_review_times AS
 SELECT sr.application_id,
    a.application_number,
    sr.reviewer_id,
    u.username AS reviewer_username,
    sr.review_type,
    sr.assigned_at,
        CASE
            WHEN ((sr.status_code)::text = 'COMPLETED'::text) THEN (sr.assigned_at + '1 day'::interval)
            ELSE NULL::timestamp with time zone
        END AS completed_at,
    (EXTRACT(epoch FROM (now() - sr.assigned_at)) / (3600)::numeric) AS hours_in_review,
        CASE
            WHEN ((sr.status_code)::text = 'COMPLETED'::text) THEN 'Completed'::character varying
            ELSE sr.status_code
        END AS review_status
   FROM ((committee.review_assignments sr
     JOIN core.applications a ON ((sr.application_id = a.id)))
     JOIN security.users u ON ((sr.reviewer_id = u.id)));


--
-- Name: vw_kpi_approval_rate; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_kpi_approval_rate AS
 SELECT (date_trunc('month'::text, decision_date))::date AS month,
    count(*) AS total_decisions,
    count(
        CASE
            WHEN ((decision_code)::text = ANY ((ARRAY['APPROVED'::character varying, 'CONDITIONAL_APPROVAL'::character varying])::text[])) THEN 1
            ELSE NULL::integer
        END) AS approved,
    (((count(
        CASE
            WHEN ((decision_code)::text = ANY ((ARRAY['APPROVED'::character varying, 'CONDITIONAL_APPROVAL'::character varying])::text[])) THEN 1
            ELSE NULL::integer
        END))::numeric * 100.0) / (NULLIF(count(*), 0))::numeric) AS approval_rate_percentage
   FROM ( SELECT a_1.id,
            a_1.submission_date AS decision_date,
            a_1.current_status AS decision_code
           FROM core.applications a_1
          WHERE ((a_1.current_status)::text = ANY ((ARRAY['APPROVED'::character varying, 'CONDITIONAL_APPROVED'::character varying, 'REJECTED'::character varying])::text[]))) a
  GROUP BY (date_trunc('month'::text, decision_date))
  ORDER BY ((date_trunc('month'::text, decision_date))::date) DESC;


--
-- Name: vw_kpi_average_review_duration; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_kpi_average_review_duration AS
 SELECT (a.submission_date)::date AS submission_date,
    'REVIEW'::text AS review_type,
    count(DISTINCT ra.id) AS total_reviews,
    count(DISTINCT
        CASE
            WHEN ((a.current_status)::text = ANY ((ARRAY['APPROVED'::character varying, 'CONDITIONAL_APPROVED'::character varying, 'REJECTED'::character varying])::text[])) THEN ra.id
            ELSE NULL::bigint
        END) AS completed_reviews
   FROM (core.applications a
     JOIN committee.review_assignments ra ON ((ra.application_id = a.id)))
  GROUP BY ((a.submission_date)::date)
  ORDER BY ((a.submission_date)::date) DESC;


--
-- Name: workflow_instances; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_instances (
    id bigint NOT NULL,
    workflow_id bigint NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    current_state_id bigint NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    status_code character varying(50) DEFAULT 'ACTIVE'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_workflow_workflow_instances_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: workflow_sla; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_sla (
    id bigint NOT NULL,
    workflow_id bigint NOT NULL,
    state_id bigint NOT NULL,
    max_duration_hours integer NOT NULL,
    warning_hours integer,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: workflow_tasks; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_tasks (
    id bigint NOT NULL,
    workflow_instance_id bigint NOT NULL,
    task_code character varying(100) NOT NULL,
    task_name character varying(300) NOT NULL,
    assigned_to bigint,
    due_date timestamp with time zone,
    completed_at timestamp with time zone,
    task_status character varying(50) DEFAULT 'OPEN'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_workflow_workflow_tasks_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: vw_pending_sla_tasks; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_pending_sla_tasks AS
 SELECT wt.id AS task_id,
    wt.task_code,
    wt.task_name,
    wt.due_date,
    (EXTRACT(epoch FROM (now() - wt.due_date)) / (3600)::numeric) AS overdue_hours,
    u.username AS assigned_to_user,
    wi.entity_type,
    wi.entity_id,
    wsla.max_duration_hours
   FROM (((workflow.workflow_tasks wt
     JOIN workflow.workflow_instances wi ON ((wt.workflow_instance_id = wi.id)))
     JOIN workflow.workflow_sla wsla ON (((wsla.workflow_id = wi.workflow_id) AND (wsla.state_id = wi.current_state_id))))
     LEFT JOIN security.users u ON ((wt.assigned_to = u.id)))
  WHERE (((wt.task_status)::text = 'OPEN'::text) AND (wt.due_date < now()))
  ORDER BY wt.due_date;


--
-- Name: vw_upcoming_meetings; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_upcoming_meetings AS
 SELECT mtg.id AS meeting_id,
    mtg.meeting_number,
    mtg.meeting_date,
    mtg.meeting_status,
    mtg.location,
    c.committee_name_ar,
    c.id AS committee_id,
    count(DISTINCT ag.id) AS agenda_items_count,
    count(DISTINCT att.id) AS attendees_count
   FROM (((committee.committee_meetings mtg
     JOIN committee.committees c ON ((mtg.committee_id = c.id)))
     LEFT JOIN committee.meeting_agendas ag ON ((ag.meeting_id = mtg.id)))
     LEFT JOIN committee.attendance_logs att ON ((att.meeting_id = mtg.id)))
  WHERE (mtg.meeting_date >= now())
  GROUP BY mtg.id, mtg.meeting_number, mtg.meeting_date, mtg.meeting_status, mtg.location, c.committee_name_ar, c.id;


--
-- Name: vw_user_applications; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_user_applications AS
 SELECT a.id,
    a.application_number,
    a.application_type,
    a.current_status,
    s.status_name_ar AS status_name,
    a.submission_date,
    a.created_at,
    p.title_ar AS project_title,
    p.project_code,
    i.name_ar AS institution_name,
    u.username AS submitted_by_user,
    COALESCE(( SELECT sr.recommendation
           FROM committee.scientific_reviews sr
          WHERE ((sr.application_id = a.id) AND (sr.completed_at IS NOT NULL))
         LIMIT 1), 'Pending'::character varying) AS scientific_recommendation
   FROM ((((core.applications a
     LEFT JOIN reference.application_statuses s ON (((a.current_status)::text = (s.status_code)::text)))
     LEFT JOIN core.projects p ON ((a.project_id = p.id)))
     LEFT JOIN security.institutions i ON ((p.institution_id = i.id)))
     LEFT JOIN security.users u ON ((a.submitted_by = u.id)));


--
-- Name: adverse_events; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.adverse_events (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    event_number character varying(100) NOT NULL,
    participant_reference character varying(200),
    event_date date NOT NULL,
    event_type character varying(100) NOT NULL,
    severity character varying(50) NOT NULL,
    expectedness character varying(50),
    relatedness character varying(50),
    description text NOT NULL,
    outcome_status character varying(100),
    reported_by bigint,
    reported_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_adverse_events_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: adverse_events_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.adverse_events ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.adverse_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: corrective_actions; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.corrective_actions (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    incident_id bigint,
    action_code character varying(50) NOT NULL,
    description text NOT NULL,
    assigned_to bigint,
    priority character varying(20) DEFAULT 'MEDIUM'::character varying NOT NULL,
    due_date date,
    completed_at timestamp with time zone,
    status character varying(30) DEFAULT 'OPEN'::character varying NOT NULL,
    closure_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_corrective_actions_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: corrective_actions_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.corrective_actions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.corrective_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: mitigation_actions; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.mitigation_actions (
    id bigint NOT NULL,
    risk_assessment_id bigint NOT NULL,
    risk_category_id bigint,
    action_description text NOT NULL,
    responsible_user_id bigint,
    target_date date,
    completion_date date,
    status_code character varying(50) DEFAULT 'OPEN'::character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_mitigation_actions_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: mitigation_actions_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.mitigation_actions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.mitigation_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: risk_assessments; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.risk_assessments (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    assessment_date date NOT NULL,
    overall_risk_level character varying(50) NOT NULL,
    assessment_summary text,
    assessed_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_risk_assessments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: risk_assessments_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_assessments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.risk_assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: risk_categories; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.risk_categories (
    id bigint NOT NULL,
    category_code character varying(100) NOT NULL,
    category_name character varying(300) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: risk_categories_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_categories ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.risk_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: risk_incidents; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.risk_incidents (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    risk_id bigint,
    incident_code character varying(50) NOT NULL,
    incident_date timestamp with time zone NOT NULL,
    description text NOT NULL,
    severity character varying(30),
    root_cause text,
    reported_by bigint NOT NULL,
    status character varying(30) DEFAULT 'REPORTED'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_risk_incidents_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: risk_incidents_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_incidents ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.risk_incidents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: risk_mitigations; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.risk_mitigations (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    risk_id bigint NOT NULL,
    mitigation_plan text NOT NULL,
    responsible_party bigint,
    target_date date,
    status character varying(30) DEFAULT 'PLANNED'::character varying NOT NULL,
    effectiveness_score integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_risk_mitigations_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: risk_mitigations_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_mitigations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.risk_mitigations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: risk_register; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.risk_register (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    risk_code character varying(50) NOT NULL,
    risk_title character varying(300) NOT NULL,
    risk_description text,
    risk_category_id bigint,
    likelihood integer DEFAULT 1 NOT NULL,
    impact integer DEFAULT 1 NOT NULL,
    risk_score integer GENERATED ALWAYS AS ((likelihood * impact)) STORED,
    risk_level character varying(20),
    owner_id bigint,
    status character varying(30) DEFAULT 'IDENTIFIED'::character varying NOT NULL,
    identified_at timestamp with time zone DEFAULT now() NOT NULL,
    identified_by bigint,
    reviewed_at timestamp with time zone,
    reviewed_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_risk_register_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: risk_register_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.risk_register ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.risk_register_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: safety_committee_reviews; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.safety_committee_reviews (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    committee_id bigint NOT NULL,
    review_date date NOT NULL,
    review_outcome character varying(100) NOT NULL,
    recommendations text,
    reviewed_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_safety_committee_reviews_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: safety_committee_reviews_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.safety_committee_reviews ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.safety_committee_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: safety_followups; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.safety_followups (
    id bigint NOT NULL,
    adverse_event_id bigint NOT NULL,
    followup_date date NOT NULL,
    followup_notes text NOT NULL,
    outcome_status character varying(100),
    created_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_safety_followups_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: safety_followups_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.safety_followups ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.safety_followups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: safety_reports; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.safety_reports (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    report_number character varying(100) NOT NULL,
    report_type character varying(100) NOT NULL,
    reporting_period_start date,
    reporting_period_end date,
    report_summary text,
    submitted_by bigint,
    submitted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_safety_reports_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: safety_reports_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.safety_reports ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.safety_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: serious_adverse_events; Type: TABLE; Schema: safety; Owner: -
--

CREATE TABLE safety.serious_adverse_events (
    id bigint NOT NULL,
    adverse_event_id bigint NOT NULL,
    seriousness_reason character varying(200) NOT NULL,
    hospitalization_required boolean DEFAULT false NOT NULL,
    life_threatening boolean DEFAULT false NOT NULL,
    death_occurred boolean DEFAULT false NOT NULL,
    disability_occurred boolean DEFAULT false NOT NULL,
    reported_to_committee_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_safety_serious_adverse_events_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: serious_adverse_events_id_seq; Type: SEQUENCE; Schema: safety; Owner: -
--

ALTER TABLE safety.serious_adverse_events ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME safety.serious_adverse_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: access_policies; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.access_policies (
    id bigint NOT NULL,
    policy_code character varying(100) NOT NULL,
    policy_name character varying(200) NOT NULL,
    target_resource character varying(200) NOT NULL,
    policy_expression jsonb NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: access_policies_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.access_policies ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.access_policies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: api_keys; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.api_keys (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    key_name character varying(200) NOT NULL,
    api_key_hash text NOT NULL,
    expires_at timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.api_keys ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: approval_authorities; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.approval_authorities (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    committee_id bigint,
    decision_type_id bigint,
    authority_level integer NOT NULL,
    active boolean DEFAULT true
);


--
-- Name: approval_authorities_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.approval_authorities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_authorities_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.approval_authorities_id_seq OWNED BY security.approval_authorities.id;


--
-- Name: approval_limits; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.approval_limits (
    id bigint NOT NULL,
    authority_id bigint NOT NULL,
    max_risk_level integer,
    max_budget numeric(18,2),
    max_duration_days integer
);


--
-- Name: approval_limits_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.approval_limits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_limits_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.approval_limits_id_seq OWNED BY security.approval_limits.id;


--
-- Name: certificate_revocations; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.certificate_revocations (
    id bigint NOT NULL,
    certificate_id bigint NOT NULL,
    revoked_at timestamp with time zone NOT NULL,
    reason text
);


--
-- Name: certificate_revocations_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.certificate_revocations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificate_revocations_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.certificate_revocations_id_seq OWNED BY security.certificate_revocations.id;


--
-- Name: departments; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.departments (
    id bigint NOT NULL,
    institution_id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.departments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: digital_certificates; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.digital_certificates (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    serial_number character varying(255),
    issuer character varying(500),
    valid_from timestamp with time zone,
    valid_to timestamp with time zone,
    status character varying(50)
);


--
-- Name: digital_certificates_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.digital_certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: digital_certificates_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.digital_certificates_id_seq OWNED BY security.digital_certificates.id;


--
-- Name: email_verification_tokens; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.email_verification_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token_hash text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone
);


--
-- Name: email_verification_tokens_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.email_verification_tokens ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.email_verification_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: institution_types_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.institution_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.institution_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: institutions_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.institutions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.institutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: login_audit; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.login_audit (
    id bigint NOT NULL,
    user_id bigint,
    username_attempt character varying(255),
    login_time timestamp with time zone DEFAULT now() NOT NULL,
    success boolean NOT NULL,
    ip_address inet,
    failure_reason character varying(500)
);


--
-- Name: login_audit_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.login_audit ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.login_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: password_history; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.password_history (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    password_hash text NOT NULL,
    changed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: password_history_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.password_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.password_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: password_reset_tokens; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.password_reset_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint
);


--
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.password_reset_tokens ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.password_reset_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: permissions; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.permissions (
    id bigint NOT NULL,
    permission_code character varying(150) NOT NULL,
    module_name character varying(100) NOT NULL,
    action_name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint
);


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.permissions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: policy_conditions; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.policy_conditions (
    id bigint NOT NULL,
    rule_id bigint NOT NULL,
    attribute_name character varying(200),
    operator character varying(50),
    comparison_value text
);


--
-- Name: policy_conditions_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.policy_conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: policy_conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.policy_conditions_id_seq OWNED BY security.policy_conditions.id;


--
-- Name: policy_rules; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.policy_rules (
    id bigint NOT NULL,
    policy_id bigint NOT NULL,
    resource_type character varying(100) NOT NULL,
    expression text NOT NULL,
    priority integer DEFAULT 100
);


--
-- Name: policy_rules_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.policy_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: policy_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.policy_rules_id_seq OWNED BY security.policy_rules.id;


--
-- Name: responsibility_types; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.responsibility_types (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: responsibility_types_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.responsibility_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.responsibility_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: role_delegations; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.role_delegations (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    from_user_id bigint NOT NULL,
    to_user_id bigint NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    reason text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: role_delegations_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.role_delegations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: role_delegations_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.role_delegations_id_seq OWNED BY security.role_delegations.id;


--
-- Name: role_permissions; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.role_permissions (
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: roles; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.roles (
    id bigint NOT NULL,
    code character varying(100) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    description text,
    is_system_role boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: security_events; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.security_events (
    id bigint NOT NULL,
    event_type character varying(100) NOT NULL,
    severity character varying(20) NOT NULL,
    user_id bigint,
    source_ip inet,
    details jsonb,
    event_time timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_security_events_severity CHECK (((severity)::text = ANY ((ARRAY['LOW'::character varying, 'MEDIUM'::character varying, 'HIGH'::character varying, 'CRITICAL'::character varying])::text[])))
);


--
-- Name: security_events_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.security_events ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.security_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: segregation_rules; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.segregation_rules (
    id bigint NOT NULL,
    source_role_id bigint NOT NULL,
    target_role_id bigint NOT NULL,
    violation_type character varying(100) NOT NULL,
    active boolean DEFAULT true
);


--
-- Name: segregation_rules_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

CREATE SEQUENCE security.segregation_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: segregation_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: -
--

ALTER SEQUENCE security.segregation_rules_id_seq OWNED BY security.segregation_rules.id;


--
-- Name: sessions; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.sessions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    session_token uuid DEFAULT gen_random_uuid() NOT NULL,
    ip_address inet,
    user_agent text,
    login_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked_at timestamp with time zone
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.sessions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_profiles; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.user_profiles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    national_id character varying(50),
    passport_number character varying(50),
    gender character varying(20) DEFAULT 'Male'::character varying,
    date_of_birth date,
    nationality_code character varying(10),
    academic_title character varying(200),
    specialization character varying(300),
    biography text,
    cv_document_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT chk_user_profiles_gender CHECK (((gender IS NULL) OR ((gender)::text = ANY ((ARRAY['MALE'::character varying, 'FEMALE'::character varying])::text[]))))
);


--
-- Name: user_profiles_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.user_profiles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.user_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_responsibilities; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.user_responsibilities (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id bigint NOT NULL,
    responsibility_type_id bigint NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id bigint NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    assigned_by bigint,
    revoked_at timestamp with time zone,
    revoked_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    deleted_by bigint,
    deleted_at time with time zone,
    created_by bigint
);


--
-- Name: user_responsibilities_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.user_responsibilities ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.user_responsibilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_roles; Type: TABLE; Schema: security; Owner: -
--

CREATE TABLE security.user_roles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    assigned_by bigint
);


--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.user_roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: security; Owner: -
--

ALTER TABLE security.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME security.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: audit_config; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.audit_config (
    id bigint NOT NULL,
    entity_name character varying(200) NOT NULL,
    operations character varying(50)[] NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    retention_days integer DEFAULT 365 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: audit_config_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.audit_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.audit_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: audit_log; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.audit_log (
    id bigint NOT NULL,
    user_id bigint,
    action_type character varying(100) NOT NULL,
    entity_type character varying(100),
    entity_id bigint,
    old_values jsonb,
    new_values jsonb,
    ip_address character varying(45),
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

CREATE SEQUENCE system.audit_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: system; Owner: -
--

ALTER SEQUENCE system.audit_log_id_seq OWNED BY system.audit_log.id;


--
-- Name: business_rules; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.business_rules (
    id bigint NOT NULL,
    code character varying(100),
    name character varying(255),
    rule_definition jsonb,
    active boolean DEFAULT true
);


--
-- Name: business_rules_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

CREATE SEQUENCE system.business_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: business_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: system; Owner: -
--

ALTER SEQUENCE system.business_rules_id_seq OWNED BY system.business_rules.id;


--
-- Name: email_config; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.email_config (
    id bigint NOT NULL,
    config_name character varying(200) NOT NULL,
    smtp_host character varying(500) NOT NULL,
    smtp_port integer DEFAULT 587 NOT NULL,
    smtp_username character varying(500),
    smtp_password text,
    use_tls boolean DEFAULT true NOT NULL,
    from_address character varying(500) NOT NULL,
    from_name character varying(300),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: email_config_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.email_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.email_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: feature_flags; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.feature_flags (
    id bigint NOT NULL,
    code character varying(100),
    name character varying(255),
    enabled boolean DEFAULT false
);


--
-- Name: feature_flags_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

CREATE SEQUENCE system.feature_flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feature_flags_id_seq; Type: SEQUENCE OWNED BY; Schema: system; Owner: -
--

ALTER SEQUENCE system.feature_flags_id_seq OWNED BY system.feature_flags.id;


--
-- Name: maintenance_log; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.maintenance_log (
    id bigint NOT NULL,
    maintenance_type character varying(100) NOT NULL,
    description text NOT NULL,
    started_at timestamp with time zone NOT NULL,
    completed_at timestamp with time zone,
    status character varying(50) DEFAULT 'IN_PROGRESS'::character varying NOT NULL,
    performed_by bigint,
    notes text,
    CONSTRAINT chk_maintenance_status CHECK (((status)::text = ANY ((ARRAY['SCHEDULED'::character varying, 'IN_PROGRESS'::character varying, 'COMPLETED'::character varying, 'FAILED'::character varying, 'CANCELLED'::character varying])::text[])))
);


--
-- Name: maintenance_log_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.maintenance_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.maintenance_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rule_actions; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.rule_actions (
    id bigint NOT NULL,
    rule_id bigint NOT NULL,
    action_type character varying(100) NOT NULL,
    action_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    order_index integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: rule_actions_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.rule_actions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.rule_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rule_conditions; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.rule_conditions (
    id bigint NOT NULL,
    rule_id bigint NOT NULL,
    condition_group character varying(50) DEFAULT 'AND'::character varying NOT NULL,
    field_name character varying(200) NOT NULL,
    operator character varying(30) NOT NULL,
    field_value text NOT NULL,
    value_type character varying(30) DEFAULT 'STRING'::character varying NOT NULL,
    order_index integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: rule_conditions_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.rule_conditions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.rule_conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rule_executions; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.rule_executions (
    id bigint NOT NULL,
    rule_id bigint NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    conditions_met boolean NOT NULL,
    execution_result jsonb,
    execution_duration_ms integer,
    triggered_by bigint,
    executed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: rule_executions_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.rule_executions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.rule_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rule_versions; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.rule_versions (
    id bigint NOT NULL,
    rule_id bigint NOT NULL,
    version_no integer NOT NULL,
    definition jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: rule_versions_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

CREATE SEQUENCE system.rule_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rule_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: system; Owner: -
--

ALTER SEQUENCE system.rule_versions_id_seq OWNED BY system.rule_versions.id;


--
-- Name: saved_searches; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.saved_searches (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id bigint NOT NULL,
    search_name character varying(200) NOT NULL,
    search_criteria jsonb NOT NULL,
    entity_type character varying(100),
    is_shared boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    created_by bigint,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint
);


--
-- Name: saved_searches_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.saved_searches ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.saved_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: search_audit; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.search_audit (
    id bigint NOT NULL,
    user_id bigint,
    search_query text NOT NULL,
    entity_type character varying(100),
    result_count integer,
    search_duration_ms integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: search_audit_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.search_audit ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.search_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: search_indexes; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.search_indexes (
    id bigint NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    search_text text NOT NULL,
    search_vector tsvector,
    weight integer DEFAULT 1 NOT NULL,
    language character varying(10) DEFAULT 'arabic'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: search_indexes_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.search_indexes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.search_indexes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sms_config; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.sms_config (
    id bigint NOT NULL,
    config_name character varying(200) NOT NULL,
    provider character varying(100) NOT NULL,
    api_key text,
    api_secret text,
    sender_name character varying(100),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: sms_config_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.sms_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.sms_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: system_config; Type: TABLE; Schema: system; Owner: -
--

CREATE TABLE system.system_config (
    id bigint NOT NULL,
    config_key character varying(200) NOT NULL,
    config_value text NOT NULL,
    config_group character varying(100) DEFAULT 'GENERAL'::character varying NOT NULL,
    description text,
    is_encrypted boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: system_config_id_seq; Type: SEQUENCE; Schema: system; Owner: -
--

ALTER TABLE system.system_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME system.system_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_actions; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_actions (
    id bigint NOT NULL,
    workflow_instance_id bigint NOT NULL,
    transition_id bigint NOT NULL,
    action_by bigint NOT NULL,
    action_comment text,
    action_date timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: workflow_actions_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_actions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_comments; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_comments (
    id bigint NOT NULL,
    workflow_instance_id bigint NOT NULL,
    user_id bigint NOT NULL,
    comment_text text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: workflow_comments_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_comments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_escalations; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_escalations (
    id bigint NOT NULL,
    workflow_task_id bigint NOT NULL,
    escalation_level integer NOT NULL,
    escalated_to bigint,
    escalation_reason text,
    escalated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: workflow_escalations_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_escalations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_escalations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_events; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_events (
    id bigint NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    workflow_instance_id bigint,
    event_type character varying(100) NOT NULL,
    event_data jsonb DEFAULT '{}'::jsonb,
    source character varying(100),
    created_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: workflow_events_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_events ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_history; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_history (
    id bigint NOT NULL,
    workflow_instance_id bigint NOT NULL,
    from_state_id bigint,
    to_state_id bigint,
    transition_id bigint,
    action_by bigint,
    action_date timestamp with time zone DEFAULT now() NOT NULL,
    comments text
);


--
-- Name: workflow_history_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_instances_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_schedulers; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_schedulers (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    cron_expression character varying(100) NOT NULL,
    workflow_id bigint NOT NULL,
    action_params jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true NOT NULL,
    last_run_at timestamp with time zone,
    next_run_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: workflow_schedulers_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_schedulers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_schedulers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_sla_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_sla ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_sla_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_states; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_states (
    id bigint NOT NULL,
    workflow_id bigint NOT NULL,
    state_code character varying(100) NOT NULL,
    state_name character varying(300) NOT NULL,
    is_initial boolean DEFAULT false NOT NULL,
    is_terminal boolean DEFAULT false NOT NULL,
    display_order integer DEFAULT 1 NOT NULL
);


--
-- Name: workflow_states_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_states ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_tasks_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_tasks ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_transitions; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_transitions (
    id bigint NOT NULL,
    workflow_id bigint NOT NULL,
    from_state_id bigint NOT NULL,
    to_state_id bigint NOT NULL,
    transition_code character varying(100) NOT NULL,
    transition_name character varying(300) NOT NULL,
    requires_comment boolean DEFAULT false NOT NULL,
    requires_vote boolean DEFAULT false NOT NULL,
    allowed_roles character varying(500)
);


--
-- Name: workflow_transitions_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_transitions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_triggers; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_triggers (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(200) NOT NULL,
    name_en character varying(200),
    trigger_event character varying(100) NOT NULL,
    trigger_conditions jsonb DEFAULT '{}'::jsonb,
    target_workflow_id bigint,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: workflow_triggers_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_triggers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_triggers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_variables; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflow_variables (
    id bigint NOT NULL,
    workflow_instance_id bigint NOT NULL,
    variable_name character varying(200) NOT NULL,
    variable_value jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: workflow_variables_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflow_variables ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflow_variables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflows; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.workflows (
    id bigint NOT NULL,
    workflow_code character varying(100) NOT NULL,
    workflow_name character varying(300) NOT NULL,
    entity_type character varying(100) NOT NULL,
    version_no integer DEFAULT 1 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_workflow_workflows_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--
-- Name: workflows_id_seq; Type: SEQUENCE; Schema: workflow; Owner: -
--

ALTER TABLE workflow.workflows ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME workflow.workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hash_ledger id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.hash_ledger ALTER COLUMN id SET DEFAULT nextval('audit.hash_ledger_id_seq'::regclass);


--
-- Name: message_attachments id; Type: DEFAULT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_attachments ALTER COLUMN id SET DEFAULT nextval('communication.message_attachments_id_seq'::regclass);


--
-- Name: message_recipients id; Type: DEFAULT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_recipients ALTER COLUMN id SET DEFAULT nextval('communication.message_recipients_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.messages ALTER COLUMN id SET DEFAULT nextval('communication.messages_id_seq'::regclass);


--
-- Name: pgmigrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pgmigrations ALTER COLUMN id SET DEFAULT nextval('public.pgmigrations_id_seq'::regclass);


--
-- Name: approval_authorities id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.approval_authorities ALTER COLUMN id SET DEFAULT nextval('security.approval_authorities_id_seq'::regclass);


--
-- Name: approval_limits id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.approval_limits ALTER COLUMN id SET DEFAULT nextval('security.approval_limits_id_seq'::regclass);


--
-- Name: certificate_revocations id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.certificate_revocations ALTER COLUMN id SET DEFAULT nextval('security.certificate_revocations_id_seq'::regclass);


--
-- Name: digital_certificates id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.digital_certificates ALTER COLUMN id SET DEFAULT nextval('security.digital_certificates_id_seq'::regclass);


--
-- Name: policy_conditions id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.policy_conditions ALTER COLUMN id SET DEFAULT nextval('security.policy_conditions_id_seq'::regclass);


--
-- Name: policy_rules id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.policy_rules ALTER COLUMN id SET DEFAULT nextval('security.policy_rules_id_seq'::regclass);


--
-- Name: role_delegations id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.role_delegations ALTER COLUMN id SET DEFAULT nextval('security.role_delegations_id_seq'::regclass);


--
-- Name: segregation_rules id; Type: DEFAULT; Schema: security; Owner: -
--

ALTER TABLE ONLY security.segregation_rules ALTER COLUMN id SET DEFAULT nextval('security.segregation_rules_id_seq'::regclass);


--
-- Name: audit_log id; Type: DEFAULT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.audit_log ALTER COLUMN id SET DEFAULT nextval('system.audit_log_id_seq'::regclass);


--
-- Name: business_rules id; Type: DEFAULT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.business_rules ALTER COLUMN id SET DEFAULT nextval('system.business_rules_id_seq'::regclass);


--
-- Name: feature_flags id; Type: DEFAULT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.feature_flags ALTER COLUMN id SET DEFAULT nextval('system.feature_flags_id_seq'::regclass);


--
-- Name: rule_versions id; Type: DEFAULT; Schema: system; Owner: -
--

ALTER TABLE ONLY system.rule_versions ALTER COLUMN id SET DEFAULT nextval('system.rule_versions_id_seq'::regclass);


--
-- PostgreSQL database dump complete
--

\unrestrict J1bMektdHyK22rHWR2HxpX1Dbrb4IFQojz2vffa9xqTykAximIaE55w1mhvupTk

