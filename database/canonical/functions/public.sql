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


