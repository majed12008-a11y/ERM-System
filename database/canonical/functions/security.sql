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


