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


