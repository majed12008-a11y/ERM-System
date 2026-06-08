exports.up = (pgm) => {
  pgm.sql(`
    CREATE OR REPLACE FUNCTION security.fn_authenticate(p_username TEXT)
    RETURNS TABLE(v_id BIGINT, v_password_hash TEXT, v_status VARCHAR, v_is_locked BOOLEAN)
    SECURITY DEFINER
    LANGUAGE plpgsql
    AS $$
    BEGIN
      RETURN QUERY
      SELECT u.id, u.password_hash, u.status, u.is_locked
      FROM security.users u
      WHERE u.username = p_username OR u.email = p_username;
    END;
    $$;
  `);
};

exports.down = (pgm) => {
  pgm.sql('DROP FUNCTION IF EXISTS security.fn_authenticate(TEXT)');
};
