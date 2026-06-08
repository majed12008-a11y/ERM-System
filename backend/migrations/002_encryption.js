exports.up = (pgm) => {
  pgm.sql(`
    CREATE OR REPLACE FUNCTION security.fn_encrypt(plaintext TEXT)
    RETURNS TEXT AS $$
    DECLARE
      key TEXT;
      iv BYTEA;
      encrypted BYTEA;
      tag BYTEA;
    BEGIN
      key := current_setting('app.encryption_key', true);
      IF key IS NULL THEN
        RETURN plaintext;
      END IF;
      iv := gen_random_bytes(16);
      encrypted := pgp_sym_encrypt(plaintext, key);
      RETURN encode(iv, 'hex') || ':' || encode(encrypted, 'hex');
    END;
    $$ LANGUAGE plpgsql SECURITY DEFINER;

    CREATE OR REPLACE FUNCTION security.fn_decrypt(ciphertext TEXT)
    RETURNS TEXT AS $$
    DECLARE
      key TEXT;
    BEGIN
      key := current_setting('app.encryption_key', true);
      IF key IS NULL OR ciphertext IS NULL THEN
        RETURN ciphertext;
      END IF;
      RETURN pgp_sym_decrypt(decode(ciphertext, 'hex'), key);
    EXCEPTION WHEN OTHERS THEN
      RETURN ciphertext;
    END;
    $$ LANGUAGE plpgsql SECURITY DEFINER;
  `);
};

exports.down = (pgm) => {
  pgm.sql(`
    DROP FUNCTION IF EXISTS security.fn_encrypt(TEXT);
    DROP FUNCTION IF EXISTS security.fn_decrypt(TEXT);
  `);
};
