-- ============================================================
-- 18-AUDIT-FIX: Fix audit system gaps
--   1. Add old_values / new_values JSONB columns
--   2. Rewrite fn_log_audit to capture field-level changes + source_ip
--   3. Grant permissions
-- ============================================================

-- 1. Add JSONB columns for before/after snapshots
ALTER TABLE audit.audit_logs
  ADD COLUMN IF NOT EXISTS old_values JSONB,
  ADD COLUMN IF NOT EXISTS new_values JSONB;

-- 2. Index for JSONB queries (e.g. find all changes to a specific field)
CREATE INDEX IF NOT EXISTS idx_audit_logs_old_values
  ON audit.audit_logs USING GIN (old_values);
CREATE INDEX IF NOT EXISTS idx_audit_logs_new_values
  ON audit.audit_logs USING GIN (new_values);

-- 3. Rewrite the audit trigger function
CREATE OR REPLACE FUNCTION system.fn_log_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
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
$function$;

-- 4. Ensure grants
GRANT SELECT, INSERT ON TABLE audit.audit_logs TO ethics_app;
GRANT SELECT, INSERT ON TABLE audit.audit_details TO ethics_app;
GRANT USAGE ON SCHEMA audit TO ethics_app;
