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


