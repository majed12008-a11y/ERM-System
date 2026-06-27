SET app.user_id = '0';
BEGIN;

-- ============================================================
-- 26-REFERENCE-DATA-CRUD.SQL
-- Creates missing lookup tables and seeds standard reference data
-- ============================================================

-- 1. ACADEMIC TITLES (اللقب الأكاديمي)
CREATE TABLE IF NOT EXISTS reference.academic_titles (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name_ar VARCHAR(200) NOT NULL,
    name_en VARCHAR(200),
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

COMMENT ON TABLE reference.academic_titles IS 'الألقاب الأكاديمية / Academic Titles';
COMMENT ON COLUMN reference.academic_titles.code IS 'رمز اللقب (مثال: PROF, ASSOC_PROF)';
COMMENT ON COLUMN reference.academic_titles.name_ar IS 'الاسم بالعربية';
COMMENT ON COLUMN reference.academic_titles.name_en IS 'الاسم بالإنجليزية';

INSERT INTO reference.academic_titles (code, name_ar, name_en, display_order) VALUES
  ('PROF', 'أستاذ', 'Professor', 1),
  ('ASSOC_PROF', 'أستاذ مشارك', 'Associate Professor', 2),
  ('ASST_PROF', 'أستاذ مساعد', 'Assistant Professor', 3),
  ('LECTURER', 'محاضر', 'Lecturer', 4),
  ('ASST_LECTURER', 'محاضر مساعد', 'Assistant Lecturer', 5),
  ('RESEARCHER', 'باحث', 'Researcher', 6),
  ('ASST_RESEARCHER', 'باحث مساعد', 'Assistant Researcher', 7),
  ('CONSULTANT', 'استشاري', 'Consultant', 8),
  ('SPECIALIST', 'أخصائي', 'Specialist', 9),
  ('TECHNICIAN', 'فني', 'Technician', 10),
  ('TRAINEE', 'متدرب', 'Trainee', 11)
ON CONFLICT (code) DO NOTHING;

-- Grant permissions
GRANT ALL ON TABLE reference.academic_titles TO ethics_app;
GRANT USAGE ON SEQUENCE reference.academic_titles_id_seq TO ethics_app;

-- 2. Add FK from user_profiles to academic_titles if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'security' AND table_name = 'user_profiles'
    AND column_name = 'academic_title_id'
  ) THEN
    ALTER TABLE security.user_profiles ADD COLUMN academic_title_id BIGINT REFERENCES reference.academic_titles(id);
    COMMENT ON COLUMN security.user_profiles.academic_title_id IS 'اللقب الأكاديمي (مرجع)';
  END IF;
END;
$$;

COMMIT;
