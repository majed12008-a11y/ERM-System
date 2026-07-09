-- =============================================================================
-- Commit 3: Yemen Validation Dataset — Research Projects (core.projects)
-- Created: 2026-07-06 22:33
-- Total projects: 93
-- Requirement: Business Realism, Workload Distribution, Data Quality
-- =============================================================================

-- Ensure clean state
BEGIN;

-- Disable FK triggers for bulk insert performance
SET session_replication_role = 'replica';

-- Set context for RLS (admin user)
SELECT set_config('app.user_id', '1', true);

-- =============================================================================
-- PROJECTS
-- =============================================================================

-- Workload Summary (for reference):
-- PIs with 0 projects: users (57-64) — new researchers
-- PIs with 1-2 projects: users (65-84) — normal researchers
-- PIs with 3-5 projects: users (85-92) — experienced researchers
-- PIs with 6-8 projects: users (93-96) — senior investigators
-- Additional PIs: moh.ethics(id=2), aden.ethics(id=3), chair.irb.sanaa(id=6), chair.irb.aden(id=7)

-- Expected total projects: 93

-- =============================================================================
-- Project PRJ-26-000001: Injury Patterns from Road Traffic Accidents in Sana''a
-- PI: user 65 | Institution: 10 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  10,
  'PRJ-26-000001',
  'أنماط الإصابات الناجمة عن الحوادث المرورية في صنعاء',
  'Injury Patterns from Road Traffic Accidents in Sana''a',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  65,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'CLOSED',
  '2024-09-16',
  '2027-05-04',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الصحة العالمية',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000001',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Health Policy - السياسة الصحية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Health Systems - النظم الصحية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Jawf الرئيسي',
  'Al-Jawf',
  'المركز الصحي الرئيسي - Al-Jawf',
  370,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000002: Effectiveness of Supplementary Feeding Programs in Affected Areas
-- PI: user 66 | Institution: 11 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  11,
  'PRJ-26-000002',
  'تقييم فعالية برامج التغذية التكميلية في المناطق المتضررة',
  'Effectiveness of Supplementary Feeding Programs in Affected Areas',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  66,
  'SOCIAL',
  'LOW',
  'APPROVED',
  '2024-09-10',
  '2025-06-07',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الأمم المتحدة للطفولة (اليونيسف)',
  'GRANT',
  5000,
  'USD',
  'FND-PRJ-26-000002',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Reproductive Health - الصحة الإنجابية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Schistosomiasis - البلهارسيا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Health Systems - النظم الصحية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Abyan الرئيسي',
  'Abyan',
  'المركز الصحي الرئيسي - Abyan',
  154,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000003: Knowledge About HPV Vaccine Among Medical Students
-- PI: user 67 | Institution: 12 | Status: ETHICAL_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  12,
  'PRJ-26-000003',
  'مستوى المعرفة حول لقاح فيروس الورم الحليمي البشري بين طلاب الطب',
  'Knowledge About HPV Vaccine Among Medical Students',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  67,
  'SOCIAL',
  'LOW',
  'ETHICAL_REVIEW',
  '2026-04-13',
  '2027-07-07',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'تمويل ذاتي',
  'GRANT',
  500000,
  'YER',
  'FND-PRJ-26-000003',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Genetics - علم الوراثة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'TB - السل', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Healthcare Access - الوصول للرعاية الصحية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Jawf الرئيسي',
  'Al-Jawf',
  'المركز الصحي الرئيسي - Al-Jawf',
  429,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'ETHICAL_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000004: Serological Screening for Epstein-Barr Virus Among Cancer Patients
-- PI: user 67 | Institution: 12 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  12,
  'PRJ-26-000004',
  'التحري المصلي لفيروس إيبشتاين بار لدى مرضى السرطان',
  'Serological Screening for Epstein-Barr Virus Among Cancer Patients',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  67,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'DRAFT',
  '2025-06-10',
  '2028-02-25',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الوكالة الأمريكية للتنمية الدولية',
  'GRANT',
  50000,
  'USD',
  'FND-PRJ-26-000004',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Molecular Biology - البيولوجيا الجزيئية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cholera - الكوليرا', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Dhalea الرئيسي',
  'Al-Dhalea',
  'المركز الصحي الرئيسي - Al-Dhalea',
  196,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000005: Factors Leading to Preterm Birth in Taiz Hospitals
-- PI: user 68 | Institution: 13 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  13,
  'PRJ-26-000005',
  'العوامل المؤدية للولادة المبكرة في مستشفيات تعز',
  'Factors Leading to Preterm Birth in Taiz Hospitals',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  68,
  'EPIDEMIOLOGICAL',
  'LOW',
  'DRAFT',
  '2024-11-28',
  '2027-07-16',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'تمويل ذاتي',
  'GRANT',
  1250000,
  'YER',
  'FND-PRJ-26-000005',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Trauma - الإصابات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Diabetes - السكري', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Dhamar الرئيسي',
  'Dhamar',
  'المركز الصحي الرئيسي - Dhamar',
  463,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000006: Assessment of Emergency Services in Yemeni General Hospitals
-- PI: user 69 | Institution: 14 | Status: ETHICAL_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  14,
  'PRJ-26-000006',
  'تقييم خدمات الطوارئ في المستشفيات العامة باليمن',
  'Assessment of Emergency Services in Yemeni General Hospitals',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  69,
  'SOCIAL',
  'LOW',
  'ETHICAL_REVIEW',
  '2024-09-02',
  '2026-02-24',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'برنامج الأمم المتحدة الإنمائي',
  'GRANT',
  10000,
  'USD',
  'FND-PRJ-26-000006',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Child Health - صحة الطفل', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Emergency Medicine - طب الطوارئ', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Research - البحث السريري', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Abyan الرئيسي',
  'Abyan',
  'المركز الصحي الرئيسي - Abyan',
  456,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'ETHICAL_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000007: Maternal Mortality Rates in Rural Areas of Hajjah Governorate
-- PI: user 69 | Institution: 14 | Status: SUBMITTED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  14,
  'PRJ-26-000007',
  'معدلات وفيات الأمهات في المناطق الريفية بمحافظة حجة',
  'Maternal Mortality Rates in Rural Areas of Hajjah Governorate',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  69,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'SUBMITTED',
  '2025-04-21',
  '2026-08-14',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الأمم المتحدة للطفولة (اليونيسف)',
  'GRANT',
  25000,
  'USD',
  'FND-PRJ-26-000007',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Reproductive Health - الصحة الإنجابية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'HIV - الإيدز', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Dhamar الرئيسي',
  'Dhamar',
  'المركز الصحي الرئيسي - Dhamar',
  332,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SUBMITTED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000008: Cardiovascular Disease Surveillance in Urban Areas
-- PI: user 70 | Institution: 15 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  15,
  'PRJ-26-000008',
  'ترصد أمراض القلب والشرايين في المناطق الحضرية',
  'Cardiovascular Disease Surveillance in Urban Areas',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  70,
  'EPIDEMIOLOGICAL',
  'LOW',
  'CLOSED',
  '2025-03-16',
  '2027-06-04',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة أطباء بلا حدود',
  'GRANT',
  2000,
  'USD',
  'FND-PRJ-26-000008',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Infectious Disease - الأمراض المعدية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Aden الرئيسي',
  'Aden',
  'المركز الصحي الرئيسي - Aden',
  151,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000009: Malnutrition Rates Among Under-Five Children in Yemen
-- PI: user 71 | Institution: 16 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  16,
  'PRJ-26-000009',
  'معدلات سوء التغذية بين الأطفال دون سن الخامسة في اليمن',
  'Malnutrition Rates Among Under-Five Children in Yemen',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  71,
  'EPIDEMIOLOGICAL',
  'LOW',
  'APPROVED',
  '2026-03-19',
  '2026-11-14',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الوكالة الأمريكية للتنمية الدولية',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000009',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Child Health - صحة الطفل', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Nutrition - التغذية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Taiz الرئيسي',
  'Taiz',
  'المركز الصحي الرئيسي - Taiz',
  367,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000010: Prevalence of Hepatitis B and C Among Blood Donors
-- PI: user 71 | Institution: 16 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  16,
  'PRJ-26-000010',
  'معدلات انتشار التهاب الكبد B و C بين المتبرعين بالدم',
  'Prevalence of Hepatitis B and C Among Blood Donors',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  71,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'CLOSED',
  '2024-08-24',
  '2026-12-12',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الصحة العالمية',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000010',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hepatitis - التهاب الكبد', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Microbiology - علم الأحياء الدقيقة', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahra الرئيسي',
  'Al-Mahra',
  'المركز الصحي الرئيسي - Al-Mahra',
  324,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000011: HIV Prevalence Among High-Risk Groups in Yemen
-- PI: user 72 | Institution: 17 | Status: SUBMITTED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  17,
  'PRJ-26-000011',
  'انتشار فيروس نقص المناعة البشرية بين الفئات عالية الخطورة',
  'HIV Prevalence Among High-Risk Groups in Yemen',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  72,
  'EPIDEMIOLOGICAL',
  'HIGH',
  'SUBMITTED',
  '2025-03-09',
  '2025-12-04',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'اللجنة الدولية للصليب الأحمر',
  'GRANT',
  100000,
  'USD',
  'FND-PRJ-26-000011',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Child Health - صحة الطفل', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hajjah الرئيسي',
  'Hajjah',
  'المركز الصحي الرئيسي - Hajjah',
  437,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SUBMITTED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000012: Knowledge About HPV Vaccine Among Medical Students (73-0)
-- PI: user 73 | Institution: 18 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  18,
  'PRJ-26-000012',
  'مستوى المعرفة حول لقاح فيروس الورم الحليمي البشري بين طلاب الطب (73-0)',
  'Knowledge About HPV Vaccine Among Medical Students (73-0)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  73,
  'SOCIAL',
  'LOW',
  'CLOSED',
  '2024-10-21',
  '2027-07-08',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الصندوق العالمي لمكافحة الإيدز والسل والملاريا',
  'GRANT',
  5000,
  'USD',
  'FND-PRJ-26-000012',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Microbiology - علم الأحياء الدقيقة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Vaccine - اللقاح', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Abyan الرئيسي',
  'Abyan',
  'المركز الصحي الرئيسي - Abyan',
  163,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000013: Evaluation of Family Planning Programs in Remote Areas
-- PI: user 73 | Institution: 18 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  18,
  'PRJ-26-000013',
  'تقييم برامج تنظيم الأسرة في المناطق النائية',
  'Evaluation of Family Planning Programs in Remote Areas',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  73,
  'SOCIAL',
  'LOW',
  'APPROVED',
  '2026-02-09',
  '2028-09-26',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'برنامج الأمم المتحدة الإنمائي',
  'GRANT',
  10000,
  'USD',
  'FND-PRJ-26-000013',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Anemia - فقر الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Molecular Biology - البيولوجيا الجزيئية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Taiz الرئيسي',
  'Taiz',
  'المركز الصحي الرئيسي - Taiz',
  201,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000014: Evaluation of Rapid Diagnostic Tests for Malaria in Reference Laboratories
-- PI: user 74 | Institution: 19 | Status: SUBMITTED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  19,
  'PRJ-26-000014',
  'تقييم اختبارات التشخيص السريع للملاريا في المختبرات المرجعية',
  'Evaluation of Rapid Diagnostic Tests for Malaria in Reference Laboratories',
  'هذه دراسة تداخلية تهدف إلى تقييم فعالية وسلامة التدخل العلاجي المقترح مقارنة بالعلاج القياسي في مجموعة من المرضى اليمنيين. سيتم توزيع المشاركين عشوائياً على مجموعتي الدراسة والضابطة، مع متابعة سريرية ومخبرية منتظمة. ستساهم نتائج هذه الدراسة في تحسين الممارسات السريرية ورفع جودة الرعاية الصحية المقدمة.',
  'This interventional study aims to evaluate the efficacy and safety of the proposed therapeutic intervention compared to standard treatment in a group of Yemeni patients. Participants will be randomly assigned to study and control groups, with regular clinical and laboratory follow-up. The results will contribute to improving clinical practices and enhancing the quality of healthcare provided.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  74,
  'CLINICAL_TRIAL',
  'LOW',
  'SUBMITTED',
  '2025-08-30',
  '2027-05-22',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الصندوق العالمي لمكافحة الإيدز والسل والملاريا',
  'GRANT',
  5000,
  'USD',
  'FND-PRJ-26-000014',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Yemen - اليمن', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Molecular Biology - البيولوجيا الجزيئية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahweet الرئيسي',
  'Al-Mahweet',
  'المركز الصحي الرئيسي - Al-Mahweet',
  404,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SUBMITTED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000015: Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen
-- PI: user 75 | Institution: 20 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  20,
  'PRJ-26-000015',
  'الانتشار المصلي لفيروس كورونا بين العاملين الصحيين في اليمن',
  'Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  75,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'DRAFT',
  '2025-03-29',
  '2027-04-18',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الوكالة الأمريكية للتنمية الدولية',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000015',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Vaccine - اللقاح', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Maternal Health - صحة الأم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Sana''a الرئيسي',
  'Sana''a',
  'المركز الصحي الرئيسي - Sana''a',
  237,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000016: Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients
-- PI: user 75 | Institution: 20 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  20,
  'PRJ-26-000016',
  'التشخيص الجزيئي لالتهاب الكبد الفيروسي بين مرضى غسيل الكلى',
  'Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients',
  'تدرس هذه الدراسة الوراثية العوامل الجينية المرتبطة بالحالة المرضية في العينة اليمنية، باستخدام تقنيات البيولوجيا الجزيئية المتقدمة. تشمل المنهجية استخراج الحمض النووي وتسلسل الجينات المستهدفة وتحليل التعددات الوراثية. النتائج ستساهم في فهم الأساس الجيني للأمراض في المجتمع اليمني وتطوير أساليب التشخيص الجزيئي.',
  'This genetic study examines the genetic factors associated with the disease condition in the Yemeni sample, using advanced molecular biology techniques. The methodology includes DNA extraction, sequencing of target genes, and analysis of genetic polymorphisms. The results will contribute to understanding the genetic basis of diseases in the Yemeni community and developing molecular diagnostic approaches.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  75,
  'GENETIC',
  'HIGH',
  'APPROVED',
  '2025-05-10',
  '2026-12-01',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'تمويل ذاتي',
  'GRANT',
  25000000,
  'YER',
  'FND-PRJ-26-000016',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Genetics - علم الوراثة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Blood Safety - سلامة الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cholera - الكوليرا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Vaccine - اللقاح', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahweet الرئيسي',
  'Al-Mahweet',
  'المركز الصحي الرئيسي - Al-Mahweet',
  388,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000017: Effectiveness of Radiotherapy for Cervical Cancer in Yemen
-- PI: user 76 | Institution: 21 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  21,
  'PRJ-26-000017',
  'تقييم فعالية العلاج الإشعاعي لسرطان عنق الرحم في اليمن',
  'Effectiveness of Radiotherapy for Cervical Cancer in Yemen',
  'هذه دراسة تداخلية تهدف إلى تقييم فعالية وسلامة التدخل العلاجي المقترح مقارنة بالعلاج القياسي في مجموعة من المرضى اليمنيين. سيتم توزيع المشاركين عشوائياً على مجموعتي الدراسة والضابطة، مع متابعة سريرية ومخبرية منتظمة. ستساهم نتائج هذه الدراسة في تحسين الممارسات السريرية ورفع جودة الرعاية الصحية المقدمة.',
  'This interventional study aims to evaluate the efficacy and safety of the proposed therapeutic intervention compared to standard treatment in a group of Yemeni patients. Participants will be randomly assigned to study and control groups, with regular clinical and laboratory follow-up. The results will contribute to improving clinical practices and enhancing the quality of healthcare provided.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  76,
  'CLINICAL_TRIAL',
  'MEDIUM',
  'CLOSED',
  '2024-10-02',
  '2025-12-26',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'البنك الدولي',
  'GRANT',
  75000,
  'USD',
  'FND-PRJ-26-000017',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Maternal Health - صحة الأم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cholera - الكوليرا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Drug Resistance - مقاومة الأدوية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Jawf الرئيسي',
  'Al-Jawf',
  'المركز الصحي الرئيسي - Al-Jawf',
  399,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000018: Burden of Non-Communicable Diseases in Urban and Rural Areas
-- PI: user 77 | Institution: 22 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  22,
  'PRJ-26-000018',
  'دراسة عبء الأمراض غير السارية في المناطق الحضرية والريفية',
  'Burden of Non-Communicable Diseases in Urban and Rural Areas',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  77,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'APPROVED',
  '2025-04-28',
  '2028-03-13',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'برنامج الأمم المتحدة الإنمائي',
  'GRANT',
  25000,
  'USD',
  'FND-PRJ-26-000018',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Health Policy - السياسة الصحية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Malaria - الملاريا', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Dhamar الرئيسي',
  'Dhamar',
  'المركز الصحي الرئيسي - Dhamar',
  175,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000019: Asthma Prevalence Among Children in Industrial Areas
-- PI: user 77 | Institution: 22 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  22,
  'PRJ-26-000019',
  'معدلات انتشار الربو بين الأطفال في المناطق الصناعية',
  'Asthma Prevalence Among Children in Industrial Areas',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  77,
  'EPIDEMIOLOGICAL',
  'LOW',
  'CLOSED',
  '2026-05-31',
  '2028-02-20',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة أطباء بلا حدود',
  'GRANT',
  5000,
  'USD',
  'FND-PRJ-26-000019',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Health Systems - النظم الصحية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Risk Factors - عوامل الخطر', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Aden الرئيسي',
  'Aden',
  'المركز الصحي الرئيسي - Aden',
  151,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000020: Hypertension Prevalence Among Diabetic Patients in Sana''a Hospitals
-- PI: user 78 | Institution: 23 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  23,
  'PRJ-26-000020',
  'معدلات انتشار ارتفاع ضغط الدم بين مرضى السكري في مستشفيات صنعاء',
  'Hypertension Prevalence Among Diabetic Patients in Sana''a Hospitals',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  78,
  'EPIDEMIOLOGICAL',
  'LOW',
  'APPROVED',
  '2025-11-29',
  '2027-11-19',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'برنامج الأمم المتحدة الإنمائي',
  'GRANT',
  2000,
  'USD',
  'FND-PRJ-26-000020',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Bacteriology - علم البكتيريا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cancer - السرطان', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hodeidah الرئيسي',
  'Hodeidah',
  'المركز الصحي الرئيسي - Hodeidah',
  90,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000021: Quality of Life Assessment Among Chronic Kidney Disease Patients
-- PI: user 79 | Institution: 24 | Status: ETHICAL_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  24,
  'PRJ-26-000021',
  'تقييم جودة الحياة لدى مرضى الفشل الكلوي المزمن',
  'Quality of Life Assessment Among Chronic Kidney Disease Patients',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  79,
  'SOCIAL',
  'LOW',
  'ETHICAL_REVIEW',
  '2026-03-06',
  '2028-10-21',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الصندوق العالمي لمكافحة الإيدز والسل والملاريا',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000021',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Yemen - اليمن', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Thalassemia - الثلاسيميا', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Marib الرئيسي',
  'Marib',
  'المركز الصحي الرئيسي - Marib',
  306,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'ETHICAL_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000022: Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1)
-- PI: user 79 | Institution: 24 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  24,
  'PRJ-26-000022',
  'معدلات وفيات الأمهات في المناطق الريفية بمحافظة حجة (79-1)',
  'Maternal Mortality Rates in Rural Areas of Hajjah Governorate (79-1)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  79,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'APPROVED',
  '2026-03-07',
  '2027-07-30',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'البنك الدولي',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000022',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cross-Sectional - مقطعي', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Reproductive Health - الصحة الإنجابية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hadramawt الرئيسي',
  'Hadramawt',
  'المركز الصحي الرئيسي - Hadramawt',
  344,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000023: Health System Preparedness Assessment for Health Emergencies
-- PI: user 80 | Institution: 25 | Status: SUBMITTED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  25,
  'PRJ-26-000023',
  'تقييم جاهزية النظام الصحي لمواجهة الطوارئ الصحية',
  'Health System Preparedness Assessment for Health Emergencies',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  80,
  'SOCIAL',
  'MEDIUM',
  'SUBMITTED',
  '2025-11-25',
  '2026-11-20',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'البنك الدولي',
  'GRANT',
  50000,
  'USD',
  'FND-PRJ-26-000023',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Dengue - حمى الضنك', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'TB - السل', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Raymah الرئيسي',
  'Raymah',
  'المركز الصحي الرئيسي - Raymah',
  323,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SUBMITTED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000024: Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates
-- PI: user 81 | Institution: 26 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  26,
  'PRJ-26-000024',
  'التحليل المكاني لانتشار حمى الضنك في محافظات اليمن',
  'Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  81,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'CLOSED',
  '2026-04-07',
  '2027-10-29',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الصندوق العالمي لمكافحة الإيدز والسل والملاريا',
  'GRANT',
  40000,
  'USD',
  'FND-PRJ-26-000024',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Maternal Health - صحة الأم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hodeidah الرئيسي',
  'Hodeidah',
  'المركز الصحي الرئيسي - Hodeidah',
  54,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000025: Injury Patterns from Road Traffic Accidents in Sana''a (81-1)
-- PI: user 81 | Institution: 26 | Status: SUBMITTED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  26,
  'PRJ-26-000025',
  'أنماط الإصابات الناجمة عن الحوادث المرورية في صنعاء (81-1)',
  'Injury Patterns from Road Traffic Accidents in Sana''a (81-1)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  81,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'SUBMITTED',
  '2026-03-15',
  '2026-12-10',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'وزارة الصحة والبيئة - اليمن',
  'GRANT',
  3750000,
  'YER',
  'FND-PRJ-26-000025',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Virology - علم الفيروسات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Maternal Health - صحة الأم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Sa''dah الرئيسي',
  'Sa''dah',
  'المركز الصحي الرئيسي - Sa''dah',
  64,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SUBMITTED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000026: Effectiveness of Diabetes Awareness Programs in Schools
-- PI: user 82 | Institution: 27 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  27,
  'PRJ-26-000026',
  'تقييم فعالية برامج التوعية بمرض السكري في المدارس',
  'Effectiveness of Diabetes Awareness Programs in Schools',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  82,
  'SOCIAL',
  'LOW',
  'APPROVED',
  '2024-07-27',
  '2025-02-22',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'تمويل ذاتي',
  'GRANT',
  3750000,
  'YER',
  'FND-PRJ-26-000026',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Reproductive Health - الصحة الإنجابية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Emergency Medicine - طب الطوارئ', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hodeidah الرئيسي',
  'Hodeidah',
  'المركز الصحي الرئيسي - Hodeidah',
  51,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000027: Effectiveness of Supplementary Feeding Programs in Affected Areas (83-0)
-- PI: user 83 | Institution: 28 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  28,
  'PRJ-26-000027',
  'تقييم فعالية برامج التغذية التكميلية في المناطق المتضررة (83-0)',
  'Effectiveness of Supplementary Feeding Programs in Affected Areas (83-0)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  83,
  'SOCIAL',
  'LOW',
  'APPROVED',
  '2026-04-06',
  '2027-09-28',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'وزارة الصحة والبيئة - اليمن',
  'GRANT',
  1250000,
  'YER',
  'FND-PRJ-26-000027',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hepatitis - التهاب الكبد', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Healthcare Access - الوصول للرعاية الصحية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Lahij الرئيسي',
  'Lahij',
  'المركز الصحي الرئيسي - Lahij',
  450,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000028: Assessment of Emergency Services in Yemeni General Hospitals (83-1)
-- PI: user 83 | Institution: 28 | Status: SCIENTIFIC_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  28,
  'PRJ-26-000028',
  'تقييم خدمات الطوارئ في المستشفيات العامة باليمن (83-1)',
  'Assessment of Emergency Services in Yemeni General Hospitals (83-1)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  83,
  'SOCIAL',
  'LOW',
  'SCIENTIFIC_REVIEW',
  '2024-08-22',
  '2026-09-11',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الأمم المتحدة للطفولة (اليونيسف)',
  'GRANT',
  5000,
  'USD',
  'FND-PRJ-26-000028',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Risk Factors - عوامل الخطر', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'HIV - الإيدز', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Dhamar الرئيسي',
  'Dhamar',
  'المركز الصحي الرئيسي - Dhamar',
  126,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SCIENTIFIC_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000029: Effectiveness of Supplementary Feeding Programs in Affected Areas (84-0)
-- PI: user 84 | Institution: 29 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  29,
  'PRJ-26-000029',
  'تقييم فعالية برامج التغذية التكميلية في المناطق المتضررة (84-0)',
  'Effectiveness of Supplementary Feeding Programs in Affected Areas (84-0)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  84,
  'SOCIAL',
  'LOW',
  'APPROVED',
  '2025-07-18',
  '2027-05-09',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'برنامج الأمم المتحدة الإنمائي',
  'GRANT',
  2000,
  'USD',
  'FND-PRJ-26-000029',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Vaccine - اللقاح', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Healthcare Access - الوصول للرعاية الصحية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Malaria - الملاريا', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahra الرئيسي',
  'Al-Mahra',
  'المركز الصحي الرئيسي - Al-Mahra',
  361,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000030: Evaluation of Nutritional Supplements in Malnourished Patients
-- PI: user 85 | Institution: 30 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  30,
  'PRJ-26-000030',
  'تقييم المكملات الغذائية في تحسين نتائج مرضى سوء التغذية',
  'Evaluation of Nutritional Supplements in Malnourished Patients',
  'هذه دراسة تداخلية تهدف إلى تقييم فعالية وسلامة التدخل العلاجي المقترح مقارنة بالعلاج القياسي في مجموعة من المرضى اليمنيين. سيتم توزيع المشاركين عشوائياً على مجموعتي الدراسة والضابطة، مع متابعة سريرية ومخبرية منتظمة. ستساهم نتائج هذه الدراسة في تحسين الممارسات السريرية ورفع جودة الرعاية الصحية المقدمة.',
  'This interventional study aims to evaluate the efficacy and safety of the proposed therapeutic intervention compared to standard treatment in a group of Yemeni patients. Participants will be randomly assigned to study and control groups, with regular clinical and laboratory follow-up. The results will contribute to improving clinical practices and enhancing the quality of healthcare provided.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  85,
  'CLINICAL_TRIAL',
  'MEDIUM',
  'CLOSED',
  '2025-05-23',
  '2025-12-19',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الوكالة الأمريكية للتنمية الدولية',
  'GRANT',
  40000,
  'USD',
  'FND-PRJ-26-000030',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Risk Factors - عوامل الخطر', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Nosocomial Infection - العدوى المستشفوية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Drug Resistance - مقاومة الأدوية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Abyan الرئيسي',
  'Abyan',
  'المركز الصحي الرئيسي - Abyan',
  341,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000031: Analysis of Public Health Policy Effectiveness in Combating Chronic Diseases
-- PI: user 85 | Institution: 30 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  30,
  'PRJ-26-000031',
  'تحليل فعالية سياسات الصحة العامة في مكافحة الأمراض المزمنة',
  'Analysis of Public Health Policy Effectiveness in Combating Chronic Diseases',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  85,
  'SOCIAL',
  'LOW',
  'DRAFT',
  '2025-02-05',
  '2025-08-04',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'تمويل ذاتي',
  'GRANT',
  3750000,
  'YER',
  'FND-PRJ-26-000031',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Nosocomial Infection - العدوى المستشفوية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Vaccine - اللقاح', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Leishmaniasis - الليشمانيا', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahweet الرئيسي',
  'Al-Mahweet',
  'المركز الصحي الرئيسي - Al-Mahweet',
  424,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000032: Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2)
-- PI: user 85 | Institution: 30 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  30,
  'PRJ-26-000032',
  'معدلات وفيات الأمهات في المناطق الريفية بمحافظة حجة (85-2)',
  'Maternal Mortality Rates in Rural Areas of Hajjah Governorate (85-2)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  85,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'CLOSED',
  '2025-09-12',
  '2026-07-09',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'البنك الدولي',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000032',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Dengue - حمى الضنك', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Health Policy - السياسة الصحية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hadramawt الرئيسي',
  'Hadramawt',
  'المركز الصحي الرئيسي - Hadramawt',
  435,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000033: Antimicrobial Resistance Prevalence in Yemeni Hospitals
-- PI: user 85 | Institution: 30 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  30,
  'PRJ-26-000033',
  'معدلات انتشار مقاومة المضادات الحيوية في المستشفيات اليمنية',
  'Antimicrobial Resistance Prevalence in Yemeni Hospitals',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  85,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'DRAFT',
  '2025-02-14',
  '2027-11-01',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الصحة العالمية',
  'GRANT',
  25000,
  'USD',
  'FND-PRJ-26-000033',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Infectious Disease - الأمراض المعدية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Anemia - فقر الدم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Dhalea الرئيسي',
  'Al-Dhalea',
  'المركز الصحي الرئيسي - Al-Dhalea',
  119,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000034: Evaluation of Communicable Disease Surveillance System in Yemen
-- PI: user 86 | Institution: 31 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  31,
  'PRJ-26-000034',
  'تقييم نظام الترصد الوبائي للأمراض السارية في اليمن',
  'Evaluation of Communicable Disease Surveillance System in Yemen',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  86,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'CLOSED',
  '2024-12-26',
  '2027-09-12',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الصندوق العالمي لمكافحة الإيدز والسل والملاريا',
  'GRANT',
  40000,
  'USD',
  'FND-PRJ-26-000034',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Antimicrobial Resistance - مقاومة المضادات الحيوية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Health Systems - النظم الصحية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Bayda الرئيسي',
  'Al-Bayda',
  'المركز الصحي الرئيسي - Al-Bayda',
  379,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000035: Efficacy and Safety Evaluation of Generic Medicines in Yemen
-- PI: user 86 | Institution: 31 | Status: ETHICAL_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  31,
  'PRJ-26-000035',
  'تقييم فعالية وسلامة الأدوية الجنيسة في اليمن',
  'Efficacy and Safety Evaluation of Generic Medicines in Yemen',
  'هذه دراسة تداخلية تهدف إلى تقييم فعالية وسلامة التدخل العلاجي المقترح مقارنة بالعلاج القياسي في مجموعة من المرضى اليمنيين. سيتم توزيع المشاركين عشوائياً على مجموعتي الدراسة والضابطة، مع متابعة سريرية ومخبرية منتظمة. ستساهم نتائج هذه الدراسة في تحسين الممارسات السريرية ورفع جودة الرعاية الصحية المقدمة.',
  'This interventional study aims to evaluate the efficacy and safety of the proposed therapeutic intervention compared to standard treatment in a group of Yemeni patients. Participants will be randomly assigned to study and control groups, with regular clinical and laboratory follow-up. The results will contribute to improving clinical practices and enhancing the quality of healthcare provided.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  86,
  'CLINICAL_TRIAL',
  'HIGH',
  'ETHICAL_REVIEW',
  '2024-10-31',
  '2027-01-19',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الصندوق العالمي لمكافحة الإيدز والسل والملاريا',
  'GRANT',
  200000,
  'USD',
  'FND-PRJ-26-000035',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Diabetes - السكري', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Vaccine - اللقاح', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Reproductive Health - الصحة الإنجابية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Socotra الرئيسي',
  'Socotra',
  'المركز الصحي الرئيسي - Socotra',
  157,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'ETHICAL_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000036: Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates (86-2)
-- PI: user 86 | Institution: 31 | Status: SUBMITTED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  31,
  'PRJ-26-000036',
  'التحليل المكاني لانتشار حمى الضنك في محافظات اليمن (86-2)',
  'Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates (86-2)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  86,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'SUBMITTED',
  '2026-03-17',
  '2027-05-11',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الصحة العالمية',
  'GRANT',
  40000,
  'USD',
  'FND-PRJ-26-000036',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Vaccine - اللقاح', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Reproductive Health - الصحة الإنجابية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Shabwah الرئيسي',
  'Shabwah',
  'المركز الصحي الرئيسي - Shabwah',
  158,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SUBMITTED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000037: Economic Burden of Thalassemia on Yemeni Families
-- PI: user 87 | Institution: 32 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  32,
  'PRJ-26-000037',
  'العبء الاقتصادي لمرض الثلاسيميا على الأسر اليمنية',
  'Economic Burden of Thalassemia on Yemeni Families',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  87,
  'SOCIAL',
  'LOW',
  'APPROVED',
  '2025-09-29',
  '2027-05-22',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الوكالة الأمريكية للتنمية الدولية',
  'GRANT',
  2000,
  'USD',
  'FND-PRJ-26-000037',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Non-Communicable Disease - الأمراض غير السارية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cross-Sectional - مقطعي', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hadramawt الرئيسي',
  'Hadramawt',
  'المركز الصحي الرئيسي - Hadramawt',
  101,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000038: Asthma Prevalence Among Children in Industrial Areas (87-1)
-- PI: user 87 | Institution: 32 | Status: SUBMITTED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  32,
  'PRJ-26-000038',
  'معدلات انتشار الربو بين الأطفال في المناطق الصناعية (87-1)',
  'Asthma Prevalence Among Children in Industrial Areas (87-1)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  87,
  'EPIDEMIOLOGICAL',
  'LOW',
  'SUBMITTED',
  '2025-10-28',
  '2027-12-17',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'البنك الدولي',
  'GRANT',
  2000,
  'USD',
  'FND-PRJ-26-000038',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Infectious Disease - الأمراض المعدية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Emergency Medicine - طب الطوارئ', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Abyan الرئيسي',
  'Abyan',
  'المركز الصحي الرئيسي - Abyan',
  163,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SUBMITTED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000039: Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)
-- PI: user 87 | Institution: 32 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  32,
  'PRJ-26-000039',
  'معدلات انتشار مقاومة المضادات الحيوية في المستشفيات اليمنية (87-2)',
  'Antimicrobial Resistance Prevalence in Yemeni Hospitals (87-2)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  87,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'CLOSED',
  '2026-06-29',
  '2028-10-16',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الصندوق العالمي لمكافحة الإيدز والسل والملاريا',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000039',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Yemen - اليمن', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hajjah الرئيسي',
  'Hajjah',
  'المركز الصحي الرئيسي - Hajjah',
  87,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000040: Prevalence of Hepatitis B and C Among Blood Donors (87-3)
-- PI: user 87 | Institution: 32 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  32,
  'PRJ-26-000040',
  'معدلات انتشار التهاب الكبد B و C بين المتبرعين بالدم (87-3)',
  'Prevalence of Hepatitis B and C Among Blood Donors (87-3)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  87,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'CLOSED',
  '2024-12-15',
  '2027-06-03',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'اللجنة الدولية للصليب الأحمر',
  'GRANT',
  50000,
  'USD',
  'FND-PRJ-26-000040',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'HIV - الإيدز', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cohort - طولي', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Raymah الرئيسي',
  'Raymah',
  'المركز الصحي الرئيسي - Raymah',
  71,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000041: Prevalence of Sickle Cell Disease Among Newborns in Aden
-- PI: user 87 | Institution: 32 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  32,
  'PRJ-26-000041',
  'انتشار فقر الدم المنجلي بين حديثي الولادة في عدن',
  'Prevalence of Sickle Cell Disease Among Newborns in Aden',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  87,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'CLOSED',
  '2025-08-22',
  '2026-11-15',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'اللجنة الدولية للصليب الأحمر',
  'GRANT',
  50000,
  'USD',
  'FND-PRJ-26-000041',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Quality of Life - جودة الحياة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hadramawt الرئيسي',
  'Hadramawt',
  'المركز الصحي الرئيسي - Hadramawt',
  96,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000042: Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (88-0)
-- PI: user 88 | Institution: 33 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  33,
  'PRJ-26-000042',
  'التشخيص الجزيئي لالتهاب الكبد الفيروسي بين مرضى غسيل الكلى (88-0)',
  'Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (88-0)',
  'تدرس هذه الدراسة الوراثية العوامل الجينية المرتبطة بالحالة المرضية في العينة اليمنية، باستخدام تقنيات البيولوجيا الجزيئية المتقدمة. تشمل المنهجية استخراج الحمض النووي وتسلسل الجينات المستهدفة وتحليل التعددات الوراثية. النتائج ستساهم في فهم الأساس الجيني للأمراض في المجتمع اليمني وتطوير أساليب التشخيص الجزيئي.',
  'This genetic study examines the genetic factors associated with the disease condition in the Yemeni sample, using advanced molecular biology techniques. The methodology includes DNA extraction, sequencing of target genes, and analysis of genetic polymorphisms. The results will contribute to understanding the genetic basis of diseases in the Yemeni community and developing molecular diagnostic approaches.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  88,
  'GENETIC',
  'HIGH',
  'APPROVED',
  '2025-04-02',
  '2025-12-28',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'اللجنة الدولية للصليب الأحمر',
  'GRANT',
  50000,
  'USD',
  'FND-PRJ-26-000042',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Genetics - علم الوراثة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Blood Safety - سلامة الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cholera - الكوليرا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Malaria - الملاريا', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Taiz الرئيسي',
  'Taiz',
  'المركز الصحي الرئيسي - Taiz',
  321,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000043: Effectiveness of Radiotherapy for Cervical Cancer in Yemen (88-1)
-- PI: user 88 | Institution: 33 | Status: SUBMITTED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  33,
  'PRJ-26-000043',
  'تقييم فعالية العلاج الإشعاعي لسرطان عنق الرحم في اليمن (88-1)',
  'Effectiveness of Radiotherapy for Cervical Cancer in Yemen (88-1)',
  'هذه دراسة تداخلية تهدف إلى تقييم فعالية وسلامة التدخل العلاجي المقترح مقارنة بالعلاج القياسي في مجموعة من المرضى اليمنيين. سيتم توزيع المشاركين عشوائياً على مجموعتي الدراسة والضابطة، مع متابعة سريرية ومخبرية منتظمة. ستساهم نتائج هذه الدراسة في تحسين الممارسات السريرية ورفع جودة الرعاية الصحية المقدمة.',
  'This interventional study aims to evaluate the efficacy and safety of the proposed therapeutic intervention compared to standard treatment in a group of Yemeni patients. Participants will be randomly assigned to study and control groups, with regular clinical and laboratory follow-up. The results will contribute to improving clinical practices and enhancing the quality of healthcare provided.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  88,
  'CLINICAL_TRIAL',
  'MEDIUM',
  'SUBMITTED',
  '2026-03-30',
  '2027-04-24',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الصحة العالمية',
  'GRANT',
  75000,
  'USD',
  'FND-PRJ-26-000043',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Microbiology - علم الأحياء الدقيقة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Emergency Medicine - طب الطوارئ', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Blood Safety - سلامة الدم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Bayda الرئيسي',
  'Al-Bayda',
  'المركز الصحي الرئيسي - Al-Bayda',
  493,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SUBMITTED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000044: Economic Burden of Thalassemia on Yemeni Families (88-2)
-- PI: user 88 | Institution: 33 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  33,
  'PRJ-26-000044',
  'العبء الاقتصادي لمرض الثلاسيميا على الأسر اليمنية (88-2)',
  'Economic Burden of Thalassemia on Yemeni Families (88-2)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  88,
  'SOCIAL',
  'LOW',
  'APPROVED',
  '2025-12-04',
  '2026-11-29',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الأمم المتحدة للطفولة (اليونيسف)',
  'GRANT',
  10000,
  'USD',
  'FND-PRJ-26-000044',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Anemia - فقر الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Infectious Disease - الأمراض المعدية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Raymah الرئيسي',
  'Raymah',
  'المركز الصحي الرئيسي - Raymah',
  374,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000045: Injury Patterns from Road Traffic Accidents in Sana''a (88-3)
-- PI: user 88 | Institution: 33 | Status: SCIENTIFIC_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  33,
  'PRJ-26-000045',
  'أنماط الإصابات الناجمة عن الحوادث المرورية في صنعاء (88-3)',
  'Injury Patterns from Road Traffic Accidents in Sana''a (88-3)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  88,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'SCIENTIFIC_REVIEW',
  '2024-08-28',
  '2026-01-20',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'اللجنة الدولية للصليب الأحمر',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000045',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Leishmaniasis - الليشمانيا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cholera - الكوليرا', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Aden الرئيسي',
  'Aden',
  'المركز الصحي الرئيسي - Aden',
  313,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SCIENTIFIC_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000046: Blood Transfusion Safety Assessment in Yemeni Blood Banks
-- PI: user 89 | Institution: 34 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  34,
  'PRJ-26-000046',
  'تقييم سلامة نقل الدم في بنوك الدم اليمنية',
  'Blood Transfusion Safety Assessment in Yemeni Blood Banks',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  89,
  'EPIDEMIOLOGICAL',
  'HIGH',
  'APPROVED',
  '2026-04-25',
  '2028-02-14',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الأمم المتحدة للطفولة (اليونيسف)',
  'GRANT',
  50000,
  'USD',
  'FND-PRJ-26-000046',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Trauma - الإصابات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Jawf الرئيسي',
  'Al-Jawf',
  'المركز الصحي الرئيسي - Al-Jawf',
  173,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000047: Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates (89-1)
-- PI: user 89 | Institution: 34 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  34,
  'PRJ-26-000047',
  'التحليل المكاني لانتشار حمى الضنك في محافظات اليمن (89-1)',
  'Spatial Analysis of Dengue Fever Distribution in Yemeni Governorates (89-1)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  89,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'DRAFT',
  '2025-04-06',
  '2026-01-31',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'تمويل ذاتي',
  'GRANT',
  6250000,
  'YER',
  'FND-PRJ-26-000047',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Blood Safety - سلامة الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Child Health - صحة الطفل', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hadramawt الرئيسي',
  'Hadramawt',
  'المركز الصحي الرئيسي - Hadramawt',
  315,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000048: Assessment of Emergency Services in Yemeni General Hospitals (89-2)
-- PI: user 89 | Institution: 34 | Status: SCIENTIFIC_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  34,
  'PRJ-26-000048',
  'تقييم خدمات الطوارئ في المستشفيات العامة باليمن (89-2)',
  'Assessment of Emergency Services in Yemeni General Hospitals (89-2)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  89,
  'SOCIAL',
  'LOW',
  'SCIENTIFIC_REVIEW',
  '2025-11-26',
  '2027-07-19',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الوكالة الأمريكية للتنمية الدولية',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000048',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Health Policy - السياسة الصحية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Risk Factors - عوامل الخطر', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Trauma - الإصابات', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahra الرئيسي',
  'Al-Mahra',
  'المركز الصحي الرئيسي - Al-Mahra',
  117,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SCIENTIFIC_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000049: Effectiveness of CPR Protocols in Emergency Departments
-- PI: user 90 | Institution: 35 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  35,
  'PRJ-26-000049',
  'تقييم فعالية بروتوكولات الإنعاش القلبي الرئوي في أقسام الطوارئ',
  'Effectiveness of CPR Protocols in Emergency Departments',
  'هذه دراسة تداخلية تهدف إلى تقييم فعالية وسلامة التدخل العلاجي المقترح مقارنة بالعلاج القياسي في مجموعة من المرضى اليمنيين. سيتم توزيع المشاركين عشوائياً على مجموعتي الدراسة والضابطة، مع متابعة سريرية ومخبرية منتظمة. ستساهم نتائج هذه الدراسة في تحسين الممارسات السريرية ورفع جودة الرعاية الصحية المقدمة.',
  'This interventional study aims to evaluate the efficacy and safety of the proposed therapeutic intervention compared to standard treatment in a group of Yemeni patients. Participants will be randomly assigned to study and control groups, with regular clinical and laboratory follow-up. The results will contribute to improving clinical practices and enhancing the quality of healthcare provided.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  90,
  'CLINICAL_TRIAL',
  'LOW',
  'DRAFT',
  '2026-04-18',
  '2028-10-04',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'برنامج الأمم المتحدة الإنمائي',
  'GRANT',
  2000,
  'USD',
  'FND-PRJ-26-000049',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Trauma - الإصابات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Risk Factors - عوامل الخطر', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahweet الرئيسي',
  'Al-Mahweet',
  'المركز الصحي الرئيسي - Al-Mahweet',
  259,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000050: Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (90-1)
-- PI: user 90 | Institution: 35 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  35,
  'PRJ-26-000050',
  'الانتشار المصلي لفيروس كورونا بين العاملين الصحيين في اليمن (90-1)',
  'Seroprevalence of SARS-CoV-2 Among Healthcare Workers in Yemen (90-1)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  90,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'APPROVED',
  '2025-02-20',
  '2025-12-17',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'برنامج الأمم المتحدة الإنمائي',
  'GRANT',
  75000,
  'USD',
  'FND-PRJ-26-000050',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Risk Factors - عوامل الخطر', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Maternal Health - صحة الأم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Ibb الرئيسي',
  'Ibb',
  'المركز الصحي الرئيسي - Ibb',
  221,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000051: Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)
-- PI: user 90 | Institution: 35 | Status: ETHICAL_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  35,
  'PRJ-26-000051',
  'دراسة عبء الأمراض غير السارية في المناطق الحضرية والريفية (90-2)',
  'Burden of Non-Communicable Diseases in Urban and Rural Areas (90-2)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  90,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'ETHICAL_REVIEW',
  '2025-09-09',
  '2027-07-01',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة أطباء بلا حدود',
  'GRANT',
  40000,
  'USD',
  'FND-PRJ-26-000051',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Molecular Biology - البيولوجيا الجزيئية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Research - البحث السريري', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Sa''dah الرئيسي',
  'Sa''dah',
  'المركز الصحي الرئيسي - Sa''dah',
  255,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'ETHICAL_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000052: Assessment of Emergency Services in Yemeni General Hospitals (90-3)
-- PI: user 90 | Institution: 35 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  35,
  'PRJ-26-000052',
  'تقييم خدمات الطوارئ في المستشفيات العامة باليمن (90-3)',
  'Assessment of Emergency Services in Yemeni General Hospitals (90-3)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  90,
  'SOCIAL',
  'LOW',
  'APPROVED',
  '2026-01-01',
  '2027-09-23',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'اللجنة الدولية للصليب الأحمر',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000052',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'TB - السل', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Child Health - صحة الطفل', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Healthcare Access - الوصول للرعاية الصحية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Ibb الرئيسي',
  'Ibb',
  'المركز الصحي الرئيسي - Ibb',
  171,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000053: Assessment of Antenatal Care Services in Primary Health Centers
-- PI: user 90 | Institution: 35 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  35,
  'PRJ-26-000053',
  'تقييم خدمات الرعاية السابقة للولادة في مراكز الصحة الأولية',
  'Assessment of Antenatal Care Services in Primary Health Centers',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  90,
  'SOCIAL',
  'LOW',
  'CLOSED',
  '2026-02-18',
  '2028-04-08',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الصندوق العالمي لمكافحة الإيدز والسل والملاريا',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000053',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Leishmaniasis - الليشمانيا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Trauma - الإصابات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Infectious Disease - الأمراض المعدية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Bayda الرئيسي',
  'Al-Bayda',
  'المركز الصحي الرئيسي - Al-Bayda',
  193,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000054: Genetic Factors Associated with Type 1 Diabetes Mellitus
-- PI: user 91 | Institution: 36 | Status: SCIENTIFIC_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  36,
  'PRJ-26-000054',
  'دراسة العوامل الوراثية المرتبطة بمرض السكري من النوع الأول',
  'Genetic Factors Associated with Type 1 Diabetes Mellitus',
  'تدرس هذه الدراسة الوراثية العوامل الجينية المرتبطة بالحالة المرضية في العينة اليمنية، باستخدام تقنيات البيولوجيا الجزيئية المتقدمة. تشمل المنهجية استخراج الحمض النووي وتسلسل الجينات المستهدفة وتحليل التعددات الوراثية. النتائج ستساهم في فهم الأساس الجيني للأمراض في المجتمع اليمني وتطوير أساليب التشخيص الجزيئي.',
  'This genetic study examines the genetic factors associated with the disease condition in the Yemeni sample, using advanced molecular biology techniques. The methodology includes DNA extraction, sequencing of target genes, and analysis of genetic polymorphisms. The results will contribute to understanding the genetic basis of diseases in the Yemeni community and developing molecular diagnostic approaches.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  91,
  'GENETIC',
  'HIGH',
  'SCIENTIFIC_REVIEW',
  '2026-06-21',
  '2028-11-07',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الوكالة الأمريكية للتنمية الدولية',
  'GRANT',
  150000,
  'USD',
  'FND-PRJ-26-000054',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Genetics - علم الوراثة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Microbiology - علم الأحياء الدقيقة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Reproductive Health - الصحة الإنجابية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Sa''dah الرئيسي',
  'Sa''dah',
  'المركز الصحي الرئيسي - Sa''dah',
  372,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SCIENTIFIC_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000055: Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (91-1)
-- PI: user 91 | Institution: 36 | Status: SCIENTIFIC_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  36,
  'PRJ-26-000055',
  'التشخيص الجزيئي لالتهاب الكبد الفيروسي بين مرضى غسيل الكلى (91-1)',
  'Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (91-1)',
  'تدرس هذه الدراسة الوراثية العوامل الجينية المرتبطة بالحالة المرضية في العينة اليمنية، باستخدام تقنيات البيولوجيا الجزيئية المتقدمة. تشمل المنهجية استخراج الحمض النووي وتسلسل الجينات المستهدفة وتحليل التعددات الوراثية. النتائج ستساهم في فهم الأساس الجيني للأمراض في المجتمع اليمني وتطوير أساليب التشخيص الجزيئي.',
  'This genetic study examines the genetic factors associated with the disease condition in the Yemeni sample, using advanced molecular biology techniques. The methodology includes DNA extraction, sequencing of target genes, and analysis of genetic polymorphisms. The results will contribute to understanding the genetic basis of diseases in the Yemeni community and developing molecular diagnostic approaches.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  91,
  'GENETIC',
  'HIGH',
  'SCIENTIFIC_REVIEW',
  '2026-04-11',
  '2027-11-02',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الصحة العالمية',
  'GRANT',
  75000,
  'USD',
  'FND-PRJ-26-000055',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Genetics - علم الوراثة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Malaria - الملاريا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Drug Resistance - مقاومة الأدوية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Nosocomial Infection - العدوى المستشفوية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Lahij الرئيسي',
  'Lahij',
  'المركز الصحي الرئيسي - Lahij',
  462,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SCIENTIFIC_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000056: Effectiveness of Radiotherapy for Cervical Cancer in Yemen (91-2)
-- PI: user 91 | Institution: 36 | Status: SCIENTIFIC_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  36,
  'PRJ-26-000056',
  'تقييم فعالية العلاج الإشعاعي لسرطان عنق الرحم في اليمن (91-2)',
  'Effectiveness of Radiotherapy for Cervical Cancer in Yemen (91-2)',
  'هذه دراسة تداخلية تهدف إلى تقييم فعالية وسلامة التدخل العلاجي المقترح مقارنة بالعلاج القياسي في مجموعة من المرضى اليمنيين. سيتم توزيع المشاركين عشوائياً على مجموعتي الدراسة والضابطة، مع متابعة سريرية ومخبرية منتظمة. ستساهم نتائج هذه الدراسة في تحسين الممارسات السريرية ورفع جودة الرعاية الصحية المقدمة.',
  'This interventional study aims to evaluate the efficacy and safety of the proposed therapeutic intervention compared to standard treatment in a group of Yemeni patients. Participants will be randomly assigned to study and control groups, with regular clinical and laboratory follow-up. The results will contribute to improving clinical practices and enhancing the quality of healthcare provided.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  91,
  'CLINICAL_TRIAL',
  'MEDIUM',
  'SCIENTIFIC_REVIEW',
  '2024-07-13',
  '2027-04-29',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'تمويل ذاتي',
  'GRANT',
  10000000,
  'YER',
  'FND-PRJ-26-000056',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Virology - علم الفيروسات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cross-Sectional - مقطعي', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahweet الرئيسي',
  'Al-Mahweet',
  'المركز الصحي الرئيسي - Al-Mahweet',
  369,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SCIENTIFIC_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000057: Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)
-- PI: user 91 | Institution: 36 | Status: ETHICAL_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  36,
  'PRJ-26-000057',
  'معدلات وفيات الأمهات في المناطق الريفية بمحافظة حجة (91-3)',
  'Maternal Mortality Rates in Rural Areas of Hajjah Governorate (91-3)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  91,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'ETHICAL_REVIEW',
  '2025-03-21',
  '2028-02-04',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الوكالة الأمريكية للتنمية الدولية',
  'GRANT',
  25000,
  'USD',
  'FND-PRJ-26-000057',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Yemen - اليمن', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hepatitis - التهاب الكبد', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Dhalea الرئيسي',
  'Al-Dhalea',
  'المركز الصحي الرئيسي - Al-Dhalea',
  445,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'ETHICAL_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000058: Assessment of Emergency Services in Yemeni General Hospitals (92-0)
-- PI: user 92 | Institution: 37 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  37,
  'PRJ-26-000058',
  'تقييم خدمات الطوارئ في المستشفيات العامة باليمن (92-0)',
  'Assessment of Emergency Services in Yemeni General Hospitals (92-0)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  92,
  'SOCIAL',
  'LOW',
  'CLOSED',
  '2025-01-07',
  '2025-08-05',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'اللجنة الدولية للصليب الأحمر',
  'GRANT',
  2000,
  'USD',
  'FND-PRJ-26-000058',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Antimicrobial Resistance - مقاومة المضادات الحيوية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Tropical Medicine - الطب الاستوائي', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cohort - طولي', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hajjah الرئيسي',
  'Hajjah',
  'المركز الصحي الرئيسي - Hajjah',
  450,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000059: Cardiovascular Disease Surveillance in Urban Areas (92-1)
-- PI: user 92 | Institution: 37 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  37,
  'PRJ-26-000059',
  'ترصد أمراض القلب والشرايين في المناطق الحضرية (92-1)',
  'Cardiovascular Disease Surveillance in Urban Areas (92-1)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  92,
  'EPIDEMIOLOGICAL',
  'LOW',
  'CLOSED',
  '2024-12-05',
  '2025-11-30',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'وزارة الصحة والبيئة - اليمن',
  'GRANT',
  2000000,
  'YER',
  'FND-PRJ-26-000059',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Drug Resistance - مقاومة الأدوية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Sa''dah الرئيسي',
  'Sa''dah',
  'المركز الصحي الرئيسي - Sa''dah',
  308,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000060: Genetic Diversity of Hepatitis B Virus in Yemen
-- PI: user 92 | Institution: 37 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  37,
  'PRJ-26-000060',
  'التنوع الوراثي لفيروس التهاب الكبد B في اليمن',
  'Genetic Diversity of Hepatitis B Virus in Yemen',
  'تدرس هذه الدراسة الوراثية العوامل الجينية المرتبطة بالحالة المرضية في العينة اليمنية، باستخدام تقنيات البيولوجيا الجزيئية المتقدمة. تشمل المنهجية استخراج الحمض النووي وتسلسل الجينات المستهدفة وتحليل التعددات الوراثية. النتائج ستساهم في فهم الأساس الجيني للأمراض في المجتمع اليمني وتطوير أساليب التشخيص الجزيئي.',
  'This genetic study examines the genetic factors associated with the disease condition in the Yemeni sample, using advanced molecular biology techniques. The methodology includes DNA extraction, sequencing of target genes, and analysis of genetic polymorphisms. The results will contribute to understanding the genetic basis of diseases in the Yemeni community and developing molecular diagnostic approaches.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  92,
  'GENETIC',
  'HIGH',
  'APPROVED',
  '2024-09-26',
  '2027-06-13',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'البنك الدولي',
  'GRANT',
  75000,
  'USD',
  'FND-PRJ-26-000060',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Genetics - علم الوراثة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Leishmaniasis - الليشمانيا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cancer - السرطان', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Socotra الرئيسي',
  'Socotra',
  'المركز الصحي الرئيسي - Socotra',
  252,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000061: Pharmacogenetic Study of Drug Metabolism Among Yemenis
-- PI: user 93 | Institution: 38 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  38,
  'PRJ-26-000061',
  'الدراسة الدوائية الوراثية لاستقلاب الأدوية لدى اليمنيين',
  'Pharmacogenetic Study of Drug Metabolism Among Yemenis',
  'تدرس هذه الدراسة الوراثية العوامل الجينية المرتبطة بالحالة المرضية في العينة اليمنية، باستخدام تقنيات البيولوجيا الجزيئية المتقدمة. تشمل المنهجية استخراج الحمض النووي وتسلسل الجينات المستهدفة وتحليل التعددات الوراثية. النتائج ستساهم في فهم الأساس الجيني للأمراض في المجتمع اليمني وتطوير أساليب التشخيص الجزيئي.',
  'This genetic study examines the genetic factors associated with the disease condition in the Yemeni sample, using advanced molecular biology techniques. The methodology includes DNA extraction, sequencing of target genes, and analysis of genetic polymorphisms. The results will contribute to understanding the genetic basis of diseases in the Yemeni community and developing molecular diagnostic approaches.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  93,
  'GENETIC',
  'HIGH',
  'CLOSED',
  '2026-03-31',
  '2029-01-14',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'اللجنة الدولية للصليب الأحمر',
  'GRANT',
  150000,
  'USD',
  'FND-PRJ-26-000061',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Genetics - علم الوراثة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cohort - طولي', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Leishmaniasis - الليشمانيا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Vaccine - اللقاح', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Sa''dah الرئيسي',
  'Sa''dah',
  'المركز الصحي الرئيسي - Sa''dah',
  187,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000062: Obesity Prevalence and Its Association with Chronic Diseases in Adults
-- PI: user 93 | Institution: 38 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  38,
  'PRJ-26-000062',
  'انتشار السمنة وارتباطها بالأمراض المزمنة لدى البالغين',
  'Obesity Prevalence and Its Association with Chronic Diseases in Adults',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  93,
  'EPIDEMIOLOGICAL',
  'LOW',
  'APPROVED',
  '2025-07-18',
  '2027-09-06',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الصحة العالمية',
  'GRANT',
  2000,
  'USD',
  'FND-PRJ-26-000062',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Reproductive Health - الصحة الإنجابية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Blood Safety - سلامة الدم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Lahij الرئيسي',
  'Lahij',
  'المركز الصحي الرئيسي - Lahij',
  279,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000063: Prevalence of Hepatitis B and C Among Blood Donors (93-2)
-- PI: user 93 | Institution: 38 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  38,
  'PRJ-26-000063',
  'معدلات انتشار التهاب الكبد B و C بين المتبرعين بالدم (93-2)',
  'Prevalence of Hepatitis B and C Among Blood Donors (93-2)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  93,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'DRAFT',
  '2025-08-23',
  '2027-04-15',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الوكالة الأمريكية للتنمية الدولية',
  'GRANT',
  75000,
  'USD',
  'FND-PRJ-26-000063',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cohort - طولي', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Infectious Disease - الأمراض المعدية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hadramawt الرئيسي',
  'Hadramawt',
  'المركز الصحي الرئيسي - Hadramawt',
  236,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000064: Assessment of Emergency Services in Yemeni General Hospitals (93-3)
-- PI: user 93 | Institution: 38 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  38,
  'PRJ-26-000064',
  'تقييم خدمات الطوارئ في المستشفيات العامة باليمن (93-3)',
  'Assessment of Emergency Services in Yemeni General Hospitals (93-3)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  93,
  'SOCIAL',
  'LOW',
  'APPROVED',
  '2025-12-16',
  '2026-11-11',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'البنك الدولي',
  'GRANT',
  8000,
  'USD',
  'FND-PRJ-26-000064',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Molecular Biology - البيولوجيا الجزيئية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Genetics - علم الوراثة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Quality of Life - جودة الحياة', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Socotra الرئيسي',
  'Socotra',
  'المركز الصحي الرئيسي - Socotra',
  157,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000065: Association Between Obesity and Hypertension Among Yemeni Adults
-- PI: user 93 | Institution: 38 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  38,
  'PRJ-26-000065',
  'الارتباط بين السمنة وارتفاع ضغط الدم لدى البالغين اليمنيين',
  'Association Between Obesity and Hypertension Among Yemeni Adults',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  93,
  'EPIDEMIOLOGICAL',
  'LOW',
  'DRAFT',
  '2026-03-25',
  '2028-03-14',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'برنامج الأمم المتحدة الإنمائي',
  'GRANT',
  2000,
  'USD',
  'FND-PRJ-26-000065',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Healthcare Access - الوصول للرعاية الصحية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Emergency Medicine - طب الطوارئ', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Jawf الرئيسي',
  'Al-Jawf',
  'المركز الصحي الرئيسي - Al-Jawf',
  158,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000066: Association Between Obesity and Hypertension Among Yemeni Adults (93-5)
-- PI: user 93 | Institution: 38 | Status: SUBMITTED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  38,
  'PRJ-26-000066',
  'الارتباط بين السمنة وارتفاع ضغط الدم لدى البالغين اليمنيين (93-5)',
  'Association Between Obesity and Hypertension Among Yemeni Adults (93-5)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  93,
  'EPIDEMIOLOGICAL',
  'LOW',
  'SUBMITTED',
  '2026-06-18',
  '2029-05-03',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الوكالة الأمريكية للتنمية الدولية',
  'GRANT',
  10000,
  'USD',
  'FND-PRJ-26-000066',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Maternal Health - صحة الأم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Bacteriology - علم البكتيريا', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahweet الرئيسي',
  'Al-Mahweet',
  'المركز الصحي الرئيسي - Al-Mahweet',
  257,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SUBMITTED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000067: Evaluation of Nutritional Supplements in Malnourished Patients (93-6)
-- PI: user 93 | Institution: 38 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  38,
  'PRJ-26-000067',
  'تقييم المكملات الغذائية في تحسين نتائج مرضى سوء التغذية (93-6)',
  'Evaluation of Nutritional Supplements in Malnourished Patients (93-6)',
  'هذه دراسة تداخلية تهدف إلى تقييم فعالية وسلامة التدخل العلاجي المقترح مقارنة بالعلاج القياسي في مجموعة من المرضى اليمنيين. سيتم توزيع المشاركين عشوائياً على مجموعتي الدراسة والضابطة، مع متابعة سريرية ومخبرية منتظمة. ستساهم نتائج هذه الدراسة في تحسين الممارسات السريرية ورفع جودة الرعاية الصحية المقدمة.',
  'This interventional study aims to evaluate the efficacy and safety of the proposed therapeutic intervention compared to standard treatment in a group of Yemeni patients. Participants will be randomly assigned to study and control groups, with regular clinical and laboratory follow-up. The results will contribute to improving clinical practices and enhancing the quality of healthcare provided.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  93,
  'CLINICAL_TRIAL',
  'MEDIUM',
  'DRAFT',
  '2026-03-04',
  '2027-03-29',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'تمويل ذاتي',
  'GRANT',
  6250000,
  'YER',
  'FND-PRJ-26-000067',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Microbiology - علم الأحياء الدقيقة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Child Health - صحة الطفل', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Shabwah الرئيسي',
  'Shabwah',
  'المركز الصحي الرئيسي - Shabwah',
  467,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000068: Health System Preparedness Assessment for Health Emergencies (94-0)
-- PI: user 94 | Institution: 39 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  39,
  'PRJ-26-000068',
  'تقييم جاهزية النظام الصحي لمواجهة الطوارئ الصحية (94-0)',
  'Health System Preparedness Assessment for Health Emergencies (94-0)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  94,
  'SOCIAL',
  'MEDIUM',
  'CLOSED',
  '2025-01-02',
  '2027-07-21',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الصحة العالمية',
  'GRANT',
  25000,
  'USD',
  'FND-PRJ-26-000068',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cross-Sectional - مقطعي', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Emergency Medicine - طب الطوارئ', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahra الرئيسي',
  'Al-Mahra',
  'المركز الصحي الرئيسي - Al-Mahra',
  467,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000069: Prevalence of Hepatitis B and C Among Blood Donors (94-1)
-- PI: user 94 | Institution: 39 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  39,
  'PRJ-26-000069',
  'معدلات انتشار التهاب الكبد B و C بين المتبرعين بالدم (94-1)',
  'Prevalence of Hepatitis B and C Among Blood Donors (94-1)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  94,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'APPROVED',
  '2026-01-13',
  '2027-08-06',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة أطباء بلا حدود',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000069',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Tropical Medicine - الطب الاستوائي', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Ibb الرئيسي',
  'Ibb',
  'المركز الصحي الرئيسي - Ibb',
  422,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000070: Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2)
-- PI: user 94 | Institution: 39 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  39,
  'PRJ-26-000070',
  'انتشار فقر الدم المنجلي بين حديثي الولادة في عدن (94-2)',
  'Prevalence of Sickle Cell Disease Among Newborns in Aden (94-2)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  94,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'APPROVED',
  '2025-11-27',
  '2026-11-22',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الصندوق العالمي لمكافحة الإيدز والسل والملاريا',
  'GRANT',
  50000,
  'USD',
  'FND-PRJ-26-000070',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cancer - السرطان', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Drug Resistance - مقاومة الأدوية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Raymah الرئيسي',
  'Raymah',
  'المركز الصحي الرئيسي - Raymah',
  288,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000071: Cancer Incidence Patterns in Yemen Based on National Registry
-- PI: user 94 | Institution: 39 | Status: SCIENTIFIC_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  39,
  'PRJ-26-000071',
  'أنماط انتشار السرطان في اليمن حسب السجل الوطني',
  'Cancer Incidence Patterns in Yemen Based on National Registry',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  94,
  'EPIDEMIOLOGICAL',
  'LOW',
  'SCIENTIFIC_REVIEW',
  '2025-01-16',
  '2027-07-05',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'برنامج الأمم المتحدة الإنمائي',
  'GRANT',
  10000,
  'USD',
  'FND-PRJ-26-000071',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Infectious Disease - الأمراض المعدية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cancer - السرطان', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Sa''dah الرئيسي',
  'Sa''dah',
  'المركز الصحي الرئيسي - Sa''dah',
  286,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SCIENTIFIC_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000072: Early Warning System for Infectious Disease Outbreaks in Conflict Zones
-- PI: user 94 | Institution: 39 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  39,
  'PRJ-26-000072',
  'نظام الإنذار المبكر لتفشي الأمراض المعدية في مناطق النزاع',
  'Early Warning System for Infectious Disease Outbreaks in Conflict Zones',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  94,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'DRAFT',
  '2025-02-05',
  '2027-03-27',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'وزارة الصحة والبيئة - اليمن',
  'GRANT',
  6250000,
  'YER',
  'FND-PRJ-26-000072',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Maternal Health - صحة الأم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Non-Communicable Disease - الأمراض غير السارية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Taiz الرئيسي',
  'Taiz',
  'المركز الصحي الرئيسي - Taiz',
  176,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000073: Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)
-- PI: user 94 | Institution: 39 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  39,
  'PRJ-26-000073',
  'تقييم سلامة نقل الدم في بنوك الدم اليمنية (94-5)',
  'Blood Transfusion Safety Assessment in Yemeni Blood Banks (94-5)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  94,
  'EPIDEMIOLOGICAL',
  'HIGH',
  'CLOSED',
  '2025-02-12',
  '2026-01-08',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الصحة العالمية',
  'GRANT',
  75000,
  'USD',
  'FND-PRJ-26-000073',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hepatitis - التهاب الكبد', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Malaria - الملاريا', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahra الرئيسي',
  'Al-Mahra',
  'المركز الصحي الرئيسي - Al-Mahra',
  389,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000074: Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (95-0)
-- PI: user 95 | Institution: 40 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  40,
  'PRJ-26-000074',
  'التشخيص الجزيئي لالتهاب الكبد الفيروسي بين مرضى غسيل الكلى (95-0)',
  'Molecular Diagnosis of Viral Hepatitis Among Hemodialysis Patients (95-0)',
  'تدرس هذه الدراسة الوراثية العوامل الجينية المرتبطة بالحالة المرضية في العينة اليمنية، باستخدام تقنيات البيولوجيا الجزيئية المتقدمة. تشمل المنهجية استخراج الحمض النووي وتسلسل الجينات المستهدفة وتحليل التعددات الوراثية. النتائج ستساهم في فهم الأساس الجيني للأمراض في المجتمع اليمني وتطوير أساليب التشخيص الجزيئي.',
  'This genetic study examines the genetic factors associated with the disease condition in the Yemeni sample, using advanced molecular biology techniques. The methodology includes DNA extraction, sequencing of target genes, and analysis of genetic polymorphisms. The results will contribute to understanding the genetic basis of diseases in the Yemeni community and developing molecular diagnostic approaches.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  95,
  'GENETIC',
  'HIGH',
  'APPROVED',
  '2026-04-24',
  '2028-05-13',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة أطباء بلا حدود',
  'GRANT',
  100000,
  'USD',
  'FND-PRJ-26-000074',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Genetics - علم الوراثة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Leishmaniasis - الليشمانيا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Diabetes - السكري', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Virology - علم الفيروسات', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Raymah الرئيسي',
  'Raymah',
  'المركز الصحي الرئيسي - Raymah',
  126,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000075: Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)
-- PI: user 95 | Institution: 40 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  40,
  'PRJ-26-000075',
  'تقييم فعالية وسلامة الأدوية الجنيسة في اليمن (95-1)',
  'Efficacy and Safety Evaluation of Generic Medicines in Yemen (95-1)',
  'هذه دراسة تداخلية تهدف إلى تقييم فعالية وسلامة التدخل العلاجي المقترح مقارنة بالعلاج القياسي في مجموعة من المرضى اليمنيين. سيتم توزيع المشاركين عشوائياً على مجموعتي الدراسة والضابطة، مع متابعة سريرية ومخبرية منتظمة. ستساهم نتائج هذه الدراسة في تحسين الممارسات السريرية ورفع جودة الرعاية الصحية المقدمة.',
  'This interventional study aims to evaluate the efficacy and safety of the proposed therapeutic intervention compared to standard treatment in a group of Yemeni patients. Participants will be randomly assigned to study and control groups, with regular clinical and laboratory follow-up. The results will contribute to improving clinical practices and enhancing the quality of healthcare provided.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  95,
  'CLINICAL_TRIAL',
  'HIGH',
  'CLOSED',
  '2025-07-31',
  '2026-10-24',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الصحة العالمية',
  'GRANT',
  50000,
  'USD',
  'FND-PRJ-26-000075',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Drug Resistance - مقاومة الأدوية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Tropical Medicine - الطب الاستوائي', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Diabetes - السكري', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Aden الرئيسي',
  'Aden',
  'المركز الصحي الرئيسي - Aden',
  146,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000076: Obesity Prevalence and Its Association with Chronic Diseases in Adults (95-2)
-- PI: user 95 | Institution: 40 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  40,
  'PRJ-26-000076',
  'انتشار السمنة وارتباطها بالأمراض المزمنة لدى البالغين (95-2)',
  'Obesity Prevalence and Its Association with Chronic Diseases in Adults (95-2)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  95,
  'EPIDEMIOLOGICAL',
  'LOW',
  'DRAFT',
  '2024-08-25',
  '2026-03-18',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الأمم المتحدة للطفولة (اليونيسف)',
  'GRANT',
  2000,
  'USD',
  'FND-PRJ-26-000076',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Non-Communicable Disease - الأمراض غير السارية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Maternal Health - صحة الأم', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hajjah الرئيسي',
  'Hajjah',
  'المركز الصحي الرئيسي - Hajjah',
  220,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000077: Effectiveness of Diabetes Awareness Programs in Schools (95-3)
-- PI: user 95 | Institution: 40 | Status: SCIENTIFIC_REVIEW
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  40,
  'PRJ-26-000077',
  'تقييم فعالية برامج التوعية بمرض السكري في المدارس (95-3)',
  'Effectiveness of Diabetes Awareness Programs in Schools (95-3)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  95,
  'SOCIAL',
  'LOW',
  'SCIENTIFIC_REVIEW',
  '2025-11-06',
  '2026-09-02',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الوكالة الأمريكية للتنمية الدولية',
  'GRANT',
  10000,
  'USD',
  'FND-PRJ-26-000077',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Blood Safety - سلامة الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Health Policy - السياسة الصحية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Nutrition - التغذية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hodeidah الرئيسي',
  'Hodeidah',
  'المركز الصحي الرئيسي - Hodeidah',
  483,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SCIENTIFIC_REVIEW', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000078: Effectiveness of Diabetes Awareness Programs in Schools (95-4)
-- PI: user 95 | Institution: 40 | Status: SUBMITTED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  40,
  'PRJ-26-000078',
  'تقييم فعالية برامج التوعية بمرض السكري في المدارس (95-4)',
  'Effectiveness of Diabetes Awareness Programs in Schools (95-4)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  95,
  'SOCIAL',
  'LOW',
  'SUBMITTED',
  '2024-12-26',
  '2025-12-21',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الصندوق العالمي لمكافحة الإيدز والسل والملاريا',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000078',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Hypertension - ارتفاع ضغط الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cholera - الكوليرا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Reproductive Health - الصحة الإنجابية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Jawf الرئيسي',
  'Al-Jawf',
  'المركز الصحي الرئيسي - Al-Jawf',
  268,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SUBMITTED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000079: Cancer Incidence Patterns in Yemen Based on National Registry (95-5)
-- PI: user 95 | Institution: 40 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  40,
  'PRJ-26-000079',
  'أنماط انتشار السرطان في اليمن حسب السجل الوطني (95-5)',
  'Cancer Incidence Patterns in Yemen Based on National Registry (95-5)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  95,
  'EPIDEMIOLOGICAL',
  'LOW',
  'APPROVED',
  '2025-07-03',
  '2026-09-26',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الصندوق العالمي لمكافحة الإيدز والسل والملاريا',
  'GRANT',
  5000,
  'USD',
  'FND-PRJ-26-000079',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Diabetes - السكري', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'HIV - الإيدز', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hodeidah الرئيسي',
  'Hodeidah',
  'المركز الصحي الرئيسي - Hodeidah',
  376,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000080: Antimicrobial Resistance Prevalence in Yemeni Hospitals (95-6)
-- PI: user 95 | Institution: 40 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  40,
  'PRJ-26-000080',
  'معدلات انتشار مقاومة المضادات الحيوية في المستشفيات اليمنية (95-6)',
  'Antimicrobial Resistance Prevalence in Yemeni Hospitals (95-6)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  95,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'APPROVED',
  '2024-12-18',
  '2025-06-16',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'تمويل ذاتي',
  'GRANT',
  6250000,
  'YER',
  'FND-PRJ-26-000080',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Antimicrobial Resistance - مقاومة المضادات الحيوية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Microbiology - علم الأحياء الدقيقة', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahra الرئيسي',
  'Al-Mahra',
  'المركز الصحي الرئيسي - Al-Mahra',
  360,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000081: Cancer Incidence Patterns in Yemen Based on National Registry (95-7)
-- PI: user 95 | Institution: 40 | Status: SUBMITTED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  40,
  'PRJ-26-000081',
  'أنماط انتشار السرطان في اليمن حسب السجل الوطني (95-7)',
  'Cancer Incidence Patterns in Yemen Based on National Registry (95-7)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  95,
  'EPIDEMIOLOGICAL',
  'LOW',
  'SUBMITTED',
  '2025-09-08',
  '2026-08-04',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'وزارة الصحة والبيئة - اليمن',
  'GRANT',
  500000,
  'YER',
  'FND-PRJ-26-000081',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Non-Communicable Disease - الأمراض غير السارية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hadramawt الرئيسي',
  'Hadramawt',
  'المركز الصحي الرئيسي - Hadramawt',
  417,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SUBMITTED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000082: Injury Patterns from Road Traffic Accidents in Sana''a (96-0)
-- PI: user 96 | Institution: 41 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  41,
  'PRJ-26-000082',
  'أنماط الإصابات الناجمة عن الحوادث المرورية في صنعاء (96-0)',
  'Injury Patterns from Road Traffic Accidents in Sana''a (96-0)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  96,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'APPROVED',
  '2025-02-18',
  '2025-10-16',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الصحة العالمية',
  'GRANT',
  50000,
  'USD',
  'FND-PRJ-26-000082',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Drug Resistance - مقاومة الأدوية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Sa''dah الرئيسي',
  'Sa''dah',
  'المركز الصحي الرئيسي - Sa''dah',
  224,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000083: Cancer Incidence Patterns in Yemen Based on National Registry (96-1)
-- PI: user 96 | Institution: 41 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  41,
  'PRJ-26-000083',
  'أنماط انتشار السرطان في اليمن حسب السجل الوطني (96-1)',
  'Cancer Incidence Patterns in Yemen Based on National Registry (96-1)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  96,
  'EPIDEMIOLOGICAL',
  'LOW',
  'APPROVED',
  '2026-07-05',
  '2027-05-31',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'برنامج الأمم المتحدة الإنمائي',
  'GRANT',
  2000,
  'USD',
  'FND-PRJ-26-000083',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Yemen - اليمن', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Raymah الرئيسي',
  'Raymah',
  'المركز الصحي الرئيسي - Raymah',
  288,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000084: Impact of Health Insurance Policies on Access to Curative Services
-- PI: user 96 | Institution: 41 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  41,
  'PRJ-26-000084',
  'أثر سياسات التأمين الصحي على الوصول للخدمات العلاجية',
  'Impact of Health Insurance Policies on Access to Curative Services',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  96,
  'SOCIAL',
  'LOW',
  'DRAFT',
  '2025-04-05',
  '2027-07-24',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة أطباء بلا حدود',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000084',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Emergency Medicine - طب الطوارئ', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Nosocomial Infection - العدوى المستشفوية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Vaccine - اللقاح', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Ibb الرئيسي',
  'Ibb',
  'المركز الصحي الرئيسي - Ibb',
  370,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000085: Asthma Prevalence Among Children in Industrial Areas (96-3)
-- PI: user 96 | Institution: 41 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  41,
  'PRJ-26-000085',
  'معدلات انتشار الربو بين الأطفال في المناطق الصناعية (96-3)',
  'Asthma Prevalence Among Children in Industrial Areas (96-3)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  96,
  'EPIDEMIOLOGICAL',
  'LOW',
  'CLOSED',
  '2024-07-17',
  '2027-04-03',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'البنك الدولي',
  'GRANT',
  15000,
  'USD',
  'FND-PRJ-26-000085',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Bacteriology - علم البكتيريا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Quality of Life - جودة الحياة', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Shabwah الرئيسي',
  'Shabwah',
  'المركز الصحي الرئيسي - Shabwah',
  425,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000086: Assessment of Neonatal Care Services in Intensive Care Units
-- PI: user 96 | Institution: 41 | Status: SUBMITTED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  41,
  'PRJ-26-000086',
  'تقييم خدمات رعاية حديثي الولادة في وحدات العناية المركزة',
  'Assessment of Neonatal Care Services in Intensive Care Units',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  96,
  'SOCIAL',
  'LOW',
  'SUBMITTED',
  '2026-03-15',
  '2027-06-08',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'وزارة الصحة والبيئة - اليمن',
  'GRANT',
  3750000,
  'YER',
  'FND-PRJ-26-000086',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Reproductive Health - الصحة الإنجابية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Health Systems - النظم الصحية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Raymah الرئيسي',
  'Raymah',
  'المركز الصحي الرئيسي - Raymah',
  172,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'SUBMITTED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000087: Malnutrition Rates Among Under-Five Children in Yemen (96-5)
-- PI: user 96 | Institution: 41 | Status: CLOSED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  41,
  'PRJ-26-000087',
  'معدلات سوء التغذية بين الأطفال دون سن الخامسة في اليمن (96-5)',
  'Malnutrition Rates Among Under-Five Children in Yemen (96-5)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  96,
  'EPIDEMIOLOGICAL',
  'LOW',
  'CLOSED',
  '2024-12-16',
  '2027-05-05',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'الصندوق العالمي لمكافحة الإيدز والسل والملاريا',
  'GRANT',
  10000,
  'USD',
  'FND-PRJ-26-000087',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Blood Safety - سلامة الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Socotra الرئيسي',
  'Socotra',
  'المركز الصحي الرئيسي - Socotra',
  173,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'CLOSED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000088: Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas
-- PI: user 2 | Institution: 2 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  2,
  'PRJ-26-000088',
  'فعالية العلاج المركب للملاريا في المناطق الساحلية اليمنية',
  'Efficacy of Artemisinin-Based Combination Therapy in Yemeni Coastal Areas',
  'هذه دراسة تداخلية تهدف إلى تقييم فعالية وسلامة التدخل العلاجي المقترح مقارنة بالعلاج القياسي في مجموعة من المرضى اليمنيين. سيتم توزيع المشاركين عشوائياً على مجموعتي الدراسة والضابطة، مع متابعة سريرية ومخبرية منتظمة. ستساهم نتائج هذه الدراسة في تحسين الممارسات السريرية ورفع جودة الرعاية الصحية المقدمة.',
  'This interventional study aims to evaluate the efficacy and safety of the proposed therapeutic intervention compared to standard treatment in a group of Yemeni patients. Participants will be randomly assigned to study and control groups, with regular clinical and laboratory follow-up. The results will contribute to improving clinical practices and enhancing the quality of healthcare provided.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  2,
  'CLINICAL_TRIAL',
  'MEDIUM',
  'APPROVED',
  '2025-08-10',
  '2027-08-30',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الأمم المتحدة للطفولة (اليونيسف)',
  'GRANT',
  50000,
  'USD',
  'FND-PRJ-26-000088',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Clinical Trial - تجربة سريرية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cholera - الكوليرا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Emergency Medicine - طب الطوارئ', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Marib الرئيسي',
  'Marib',
  'المركز الصحي الرئيسي - Marib',
  444,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000089: Genetic Factors Associated with Type 1 Diabetes Mellitus (3-0)
-- PI: user 3 | Institution: 2 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  2,
  'PRJ-26-000089',
  'دراسة العوامل الوراثية المرتبطة بمرض السكري من النوع الأول (3-0)',
  'Genetic Factors Associated with Type 1 Diabetes Mellitus (3-0)',
  'تدرس هذه الدراسة الوراثية العوامل الجينية المرتبطة بالحالة المرضية في العينة اليمنية، باستخدام تقنيات البيولوجيا الجزيئية المتقدمة. تشمل المنهجية استخراج الحمض النووي وتسلسل الجينات المستهدفة وتحليل التعددات الوراثية. النتائج ستساهم في فهم الأساس الجيني للأمراض في المجتمع اليمني وتطوير أساليب التشخيص الجزيئي.',
  'This genetic study examines the genetic factors associated with the disease condition in the Yemeni sample, using advanced molecular biology techniques. The methodology includes DNA extraction, sequencing of target genes, and analysis of genetic polymorphisms. The results will contribute to understanding the genetic basis of diseases in the Yemeni community and developing molecular diagnostic approaches.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  3,
  'GENETIC',
  'HIGH',
  'DRAFT',
  '2024-07-22',
  '2027-01-08',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة أطباء بلا حدود',
  'GRANT',
  150000,
  'USD',
  'FND-PRJ-26-000089',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Genetics - علم الوراثة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Virology - علم الفيروسات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Genetics - علم الوراثة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Abyan الرئيسي',
  'Abyan',
  'المركز الصحي الرئيسي - Abyan',
  219,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000090: Evaluation of Communicable Disease Surveillance System in Yemen (6-0)
-- PI: user 6 | Institution: 2 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  2,
  'PRJ-26-000090',
  'تقييم نظام الترصد الوبائي للأمراض السارية في اليمن (6-0)',
  'Evaluation of Communicable Disease Surveillance System in Yemen (6-0)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  6,
  'EPIDEMIOLOGICAL',
  'MEDIUM',
  'DRAFT',
  '2026-04-06',
  '2027-07-30',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'اللجنة الدولية للصليب الأحمر',
  'GRANT',
  75000,
  'USD',
  'FND-PRJ-26-000090',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Drug Resistance - مقاومة الأدوية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Non-Communicable Disease - الأمراض غير السارية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Al-Mahweet الرئيسي',
  'Al-Mahweet',
  'المركز الصحي الرئيسي - Al-Mahweet',
  165,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000091: Cardiovascular Disease Surveillance in Urban Areas (6-1)
-- PI: user 6 | Institution: 2 | Status: APPROVED
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  2,
  'PRJ-26-000091',
  'ترصد أمراض القلب والشرايين في المناطق الحضرية (6-1)',
  'Cardiovascular Disease Surveillance in Urban Areas (6-1)',
  'تهدف هذه الدراسة الوبائية إلى تقدير معدلات انتشار الحالة المرضية وتوزيعها الجغرافي في المجتمع اليمني، مع تحليل عوامل الخطر المرتبطة بها. ستستخدم الدراسة منهجية المسح المقطعي لجمع البيانات من عينة تمثيلية من السكان، مع تطبيق أدوات قياس موحدة وتحليل إحصائي متقدم. النتائج المتوقعة ستوفر أدلة علمية لصناع القرار الصحي لوضع سياسات قائمة على البراهين.',
  'This epidemiological study aims to estimate the prevalence and geographic distribution of the disease condition in the Yemeni community, while analyzing associated risk factors. The study will employ a cross-sectional survey methodology to collect data from a representative population sample, using standardized measurement tools and advanced statistical analysis. Expected results will provide scientific evidence for health policymakers to develop evidence-based policies.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  6,
  'EPIDEMIOLOGICAL',
  'LOW',
  'APPROVED',
  '2025-12-09',
  '2028-09-24',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'اللجنة الدولية للصليب الأحمر',
  'GRANT',
  2000,
  'USD',
  'FND-PRJ-26-000091',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Prevalence - الانتشار', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Epidemiology - الوبائيات', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Dengue - حمى الضنك', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hadramawt الرئيسي',
  'Hadramawt',
  'المركز الصحي الرئيسي - Hadramawt',
  328,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'APPROVED', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000092: Evaluation of Family Planning Programs in Remote Areas (7-0)
-- PI: user 7 | Institution: 9 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  9,
  'PRJ-26-000092',
  'تقييم برامج تنظيم الأسرة في المناطق النائية (7-0)',
  'Evaluation of Family Planning Programs in Remote Areas (7-0)',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  7,
  'SOCIAL',
  'LOW',
  'DRAFT',
  '2026-02-21',
  '2028-05-11',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'منظمة الصحة العالمية',
  'GRANT',
  8000,
  'USD',
  'FND-PRJ-26-000092',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Cholera - الكوليرا', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Infectious Disease - الأمراض المعدية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Nosocomial Infection - العدوى المستشفوية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Aden الرئيسي',
  'Aden',
  'المركز الصحي الرئيسي - Aden',
  129,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');

-- =============================================================================
-- Project PRJ-26-000093: Evaluation of Cancer Registry System in Yemen
-- PI: user 7 | Institution: 9 | Status: DRAFT
-- =============================================================================
INSERT INTO core.projects (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en, objectives, principal_investigator_id, research_category, risk_level, status_code, start_date, expected_end_date, created_by, updated_by)
VALUES (
  9,
  'PRJ-26-000093',
  'تقييم نظام تسجيل السرطان في اليمن',
  'Evaluation of Cancer Registry System in Yemen',
  'تستكشف هذه الدراسة الاجتماعية العوامل الاجتماعية والثقافية والاقتصادية المؤثرة في الظاهرة الصحية المدروسة ضمن السياق اليمني. ستستخدم منهجية مختلطة تجمع بين المسح الكمي والمقابلات النوعية مع أصحاب المصلحة. تهدف النتائج إلى توفير توصيات قابلة للتنفيذ لتحسين السياسات والبرامج الصحية.',
  'This social study explores the social, cultural, and economic factors influencing the studied health phenomenon within the Yemeni context. It will use a mixed methodology combining quantitative survey and qualitative interviews with stakeholders. The findings aim to provide actionable recommendations for improving health policies and programs.',
  '1. تقدير معدلات انتشار الحالة المرضية في المجتمع اليمني.
2. تحديد عوامل الخطر المرتبطة بالحالة قيد الدراسة.
3. تحليل التوزيع الجغرافي والديموغرافي للحالة.
4. تقديم توصيات قائمة على الأدلة لصناع القرار الصحي.',
  7,
  'SOCIAL',
  'LOW',
  'DRAFT',
  '2025-03-27',
  '2026-01-21',
  1, 1
);
INSERT INTO core.project_funding_sources (project_id, funding_source_name, funding_type, amount, currency_code, funding_reference, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'البنك الدولي',
  'GRANT',
  5000,
  'USD',
  'FND-PRJ-26-000093',
  1
);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Public Health - الصحة العامة', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Anemia - فقر الدم', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Health Policy - السياسة الصحية', 1);
INSERT INTO core.project_keywords (project_id, keyword, created_by)
VALUES (currval('core.projects_id_seq'), 'Nutrition - التغذية', 1);
INSERT INTO core.project_sites (project_id, site_name, governorate, address, expected_participants, created_by)
VALUES (
  currval('core.projects_id_seq'),
  'موقع Hodeidah الرئيسي',
  'Hodeidah',
  'المركز الصحي الرئيسي - Hodeidah',
  205,
  1
);
INSERT INTO core.project_status_history (project_id, old_status, new_status, changed_by, remarks)
VALUES (currval('core.projects_id_seq'), NULL, 'DRAFT', 1, 'Initial status set during seed');
-- =============================================================================
-- PROJECT TEAM MEMBERS
-- Each project has PI + 1-3 additional team members
-- =============================================================================
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 66, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000001';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 67, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000001';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 67, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000002';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 68, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000002';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 68, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000003';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 68, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000004';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 69, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000005';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 70, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000005';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 70, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000006';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 70, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000007';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 71, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000008';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 72, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000008';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 72, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000009';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 73, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000009';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 72, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000010';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 73, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000011';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 74, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000011';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 74, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000012';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 74, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000013';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 75, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000014';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 76, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000014';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 76, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000015';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 77, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000015';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 76, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000016';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 77, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000016';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 77, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000017';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 78, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000017';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 78, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000018';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 78, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000019';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 79, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000020';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 80, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000020';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 80, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000021';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 80, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000022';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 81, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000023';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 82, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000024';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 82, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000025';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 83, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000025';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 83, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000026';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 84, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000027';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 85, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000027';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 84, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000028';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 85, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000029';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 86, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000029';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 86, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000030';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 86, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000031';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 87, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000031';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 86, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000032';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 87, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000032';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 86, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000033';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 87, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000033';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 87, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000034';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 88, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000034';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 87, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000035';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 87, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000036';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 88, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000036';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 88, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000037';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 88, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000038';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 88, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000039';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 89, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000039';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 88, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000040';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 89, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000040';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 88, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000041';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 89, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000042';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 90, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000042';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 89, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000043';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 89, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000044';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 89, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000045';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 90, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000045';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 90, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000046';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 91, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000046';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 90, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000047';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 91, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000047';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 90, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000048';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 91, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000048';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 91, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000049';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 91, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000050';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 92, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000050';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 91, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000051';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 92, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000051';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 91, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000052';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 91, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000053';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 92, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000053';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 92, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000054';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 92, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000055';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 92, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000056';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 92, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000057';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 93, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000058';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 93, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000059';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 93, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000060';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 94, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000061';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 94, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000062';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 95, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000062';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 94, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000063';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 94, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000064';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 94, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000065';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 95, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000065';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 94, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000066';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 94, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000067';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 95, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000068';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000068';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 95, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000069';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000069';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 95, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000070';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000070';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 95, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000071';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000071';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 95, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000072';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000072';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 95, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000073';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000074';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 59, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000074';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000075';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 59, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000075';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000076';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 59, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000076';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000077';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000078';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 59, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000078';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000079';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 59, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000079';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000080';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 96, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000081';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 59, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000081';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 58, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000082';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 58, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000083';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 58, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000084';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 59, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000084';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 58, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000085';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 58, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000086';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 58, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000087';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 59, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000087';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 3, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000088';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 4, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000089';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 5, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000089';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 7, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000090';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 8, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000090';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 7, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000091';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 8, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000091';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 8, 'Research Assistant', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000092';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 9, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000092';
INSERT INTO core.project_team_members (project_id, user_id, role_name, assigned_at, created_by)
SELECT p.id, 8, 'Co-Investigator', p.start_date, 1
FROM core.projects p
WHERE p.project_code = 'PRJ-26-000093';

-- =============================================================================
-- FIX SEQUENCES
-- =============================================================================
SELECT setval('core.projects_id_seq', COALESCE((SELECT MAX(id) FROM core.projects), 0) + 1, false);
SELECT setval('core.project_funding_sources_id_seq', COALESCE((SELECT MAX(id) FROM core.project_funding_sources), 0) + 1, false);
SELECT setval('core.project_keywords_id_seq', COALESCE((SELECT MAX(id) FROM core.project_keywords), 0) + 1, false);
SELECT setval('core.project_sites_id_seq', COALESCE((SELECT MAX(id) FROM core.project_sites), 0) + 1, false);
SELECT setval('core.project_status_history_id_seq', COALESCE((SELECT MAX(id) FROM core.project_status_history), 0) + 1, false);
SELECT setval('core.project_team_members_id_seq', COALESCE((SELECT MAX(id) FROM core.project_team_members), 0) + 1, false);

-- Re-enable FK triggers
SET session_replication_role = 'origin';

-- =============================================================================
-- VERIFICATION BLOCK
-- =============================================================================
DO $do$
DECLARE
  v_total_projects INTEGER;
  v_total_funding INTEGER;
  v_total_keywords INTEGER;
  v_total_sites INTEGER;
  v_total_team INTEGER;
  v_fk_violations INTEGER;
  v_seq_ok BOOLEAN;
  v_seq_check INTEGER;
  v_pi_count INTEGER;
  v_code_text TEXT;
  v_count_val INTEGER;
  v_institution_count INTEGER;
  v_category_count INTEGER;
  v_zero_project_pis INTEGER;
BEGIN
  -- === ROW COUNTS ===
  SELECT COUNT(*) INTO v_total_projects FROM core.projects;
  SELECT COUNT(*) INTO v_total_funding FROM core.project_funding_sources;
  SELECT COUNT(*) INTO v_total_keywords FROM core.project_keywords;
  SELECT COUNT(*) INTO v_total_sites FROM core.project_sites;
  SELECT COUNT(*) INTO v_total_team FROM core.project_team_members;

  RAISE NOTICE '=== COMMIT 3: PROJECTS VERIFICATION ===';
  RAISE NOTICE 'Total projects: % (expected ~93)', v_total_projects;
  RAISE NOTICE 'Funding sources: %', v_total_funding;
  RAISE NOTICE 'Keywords: %', v_total_keywords;
  RAISE NOTICE 'Sites: %', v_total_sites;
  RAISE NOTICE 'Team members: %', v_total_team;

  -- === FK VIOLATIONS ===
  -- institution_id
  SELECT COUNT(*) INTO v_fk_violations
  FROM core.projects p
  WHERE NOT EXISTS (SELECT 1 FROM security.institutions i WHERE i.id = p.institution_id);
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % projects reference non-existent institutions', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK institution_id: OK (0 violations)';

  -- principal_investigator_id
  SELECT COUNT(*) INTO v_fk_violations
  FROM core.projects p
  WHERE NOT EXISTS (SELECT 1 FROM security.users u WHERE u.id = p.principal_investigator_id);
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % projects reference non-existent PIs', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK principal_investigator_id: OK (0 violations)';

  -- project_funding_sources -> projects
  SELECT COUNT(*) INTO v_fk_violations
  FROM core.project_funding_sources f
  WHERE NOT EXISTS (SELECT 1 FROM core.projects p WHERE p.id = f.project_id);
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % funding sources reference non-existent projects', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK funding_sources -> projects: OK (0 violations)';

  -- project_keywords -> projects
  SELECT COUNT(*) INTO v_fk_violations
  FROM core.project_keywords k
  WHERE NOT EXISTS (SELECT 1 FROM core.projects p WHERE p.id = k.project_id);
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % keywords reference non-existent projects', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK keywords -> projects: OK (0 violations)';

  -- project_sites -> projects
  SELECT COUNT(*) INTO v_fk_violations
  FROM core.project_sites s
  WHERE NOT EXISTS (SELECT 1 FROM core.projects p WHERE p.id = s.project_id);
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % sites reference non-existent projects', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK sites -> projects: OK (0 violations)';

  -- project_team_members -> projects
  SELECT COUNT(*) INTO v_fk_violations
  FROM core.project_team_members tm
  WHERE NOT EXISTS (SELECT 1 FROM core.projects p WHERE p.id = tm.project_id);
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % team members reference non-existent projects', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK team_members -> projects: OK (0 violations)';

  -- project_team_members -> users
  SELECT COUNT(*) INTO v_fk_violations
  FROM core.project_team_members tm
  WHERE NOT EXISTS (SELECT 1 FROM security.users u WHERE u.id = tm.user_id);
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'FK VIOLATION: % team members reference non-existent users', v_fk_violations;
  END IF;
  RAISE NOTICE 'FK team_members -> users: OK (0 violations)';

  -- === NOT NULL ===
  SELECT COUNT(*) INTO v_fk_violations
  FROM core.projects WHERE title_ar IS NULL OR project_code IS NULL OR principal_investigator_id IS NULL OR institution_id IS NULL;
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'NOT NULL VIOLATION: % projects have NULL required fields', v_fk_violations;
  END IF;
  RAISE NOTICE 'NOT NULL constraints: OK';

  -- === UNIQUE ===
  SELECT COUNT(*) INTO v_fk_violations
  FROM core.projects GROUP BY project_code HAVING COUNT(*) > 1;
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'UNIQUE VIOLATION: duplicate project codes';
  END IF;
  RAISE NOTICE 'UNIQUE project codes: OK';

  -- === BUSINESS VALIDATION ===
  -- No project in THU institution (id=1) except possibly admin's
  SELECT COUNT(*) INTO v_fk_violations
  FROM core.projects p WHERE p.institution_id = 1 AND p.principal_investigator_id > 1;
  IF v_fk_violations > 0 THEN
    RAISE EXCEPTION 'BUSINESS RULE: % projects incorrectly assigned to THU institution', v_fk_violations;
  END IF;
  RAISE NOTICE 'No non-admin projects in THU: OK';

  -- All PIs should be valid users
  SELECT COUNT(*) INTO v_pi_count
  FROM (SELECT DISTINCT principal_investigator_id FROM core.projects) pi;
  RAISE NOTICE 'Unique PIs with projects: %', v_pi_count;

  -- Status distribution
  RAISE NOTICE '=== STATUS DISTRIBUTION ===';
  FOR v_code_text, v_count_val IN
    SELECT status_code, COUNT(*)::int FROM core.projects GROUP BY status_code ORDER BY COUNT(*) DESC
  LOOP
    RAISE NOTICE '%: %', v_code_text, v_count_val;
  END LOOP;

  -- Institution distribution
  RAISE NOTICE '=== INSTITUTION DISTRIBUTION (top 10) ===';
  FOR v_code_text, v_count_val IN
    SELECT i.code, COUNT(*)::int FROM core.projects p JOIN security.institutions i ON i.id = p.institution_id
    GROUP BY i.code ORDER BY COUNT(*) DESC LIMIT 10
  LOOP
    RAISE NOTICE '%: %', v_code_text, v_count_val;
  END LOOP;

  -- Category distribution
  RAISE NOTICE '=== RESEARCH CATEGORY DISTRIBUTION ===';
  FOR v_code_text, v_count_val IN
    SELECT research_category, COUNT(*)::int FROM core.projects GROUP BY research_category ORDER BY COUNT(*) DESC
  LOOP
    RAISE NOTICE '%: %', v_code_text, v_count_val;
  END LOOP;

  -- Risk distribution
  RAISE NOTICE '=== RISK LEVEL DISTRIBUTION ===';
  FOR v_code_text, v_count_val IN
    SELECT risk_level, COUNT(*)::int FROM core.projects GROUP BY risk_level ORDER BY COUNT(*) DESC
  LOOP
    RAISE NOTICE '%: %', v_code_text, v_count_val;
  END LOOP;

  -- === WORKLOAD DISTRIBUTION ===
  RAISE NOTICE '=== RESEARCHER WORKLOAD DISTRIBUTION ===';
  RAISE NOTICE 'PIs with 0 projects: researchers (ids 57-64) have no projects (new researchers)';
  
  SELECT COUNT(*) INTO v_zero_project_pis
  FROM security.users u WHERE u.id BETWEEN 57 AND 96
  AND NOT EXISTS (SELECT 1 FROM core.projects p WHERE p.principal_investigator_id = u.id);
  RAISE NOTICE 'Researchers with zero projects: % (expected 8)', v_zero_project_pis;

  -- === SEQUENCE HEALTH ===
  SELECT nextval('core.projects_id_seq') INTO v_seq_check;
  v_seq_ok := (v_seq_check = (SELECT COALESCE(MAX(id), 0) + 1 FROM core.projects));
  PERFORM setval('core.projects_id_seq', v_seq_check - 1, true);
  IF NOT v_seq_ok THEN
    RAISE EXCEPTION 'SEQUENCE MISMATCH: projects_id_seq at % but MAX(id) + 1 = %', v_seq_check, (SELECT COALESCE(MAX(id), 0) + 1 FROM core.projects);
  END IF;
  RAISE NOTICE 'Sequences: OK';

  RAISE NOTICE '=== COMMIT 3 PASSED ===';
END $do$;

COMMIT;