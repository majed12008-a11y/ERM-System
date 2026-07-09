# ==============================================================================
# PowerShell Generator — Commit 4: Applications, Committees, Reviews
# Output: backend/seed/53-yemen-applications.sql
# ==============================================================================
#requires -Version 7

$ErrorActionPreference = 'Stop'
$outputFile = Join-Path $PSScriptRoot '53-yemen-applications.sql'

# ==============================================================================
# PROLOGUE
# ==============================================================================
$sql = @'
-- =============================================================================
-- Commit 4: Yemen Validation Dataset — Committees, Applications, Reviews
-- Generated: 2026-07-06
-- Total committees: 8 | Total committee members: 60 | Total applications: 100
-- Requirements: Business Realism, Workflow Compliance, Data Quality
-- =============================================================================

BEGIN;

SET session_replication_role = 'replica';

SELECT set_config('app.user_id', '1', true);

-- Reset sequences
SELECT setval('committee.committees_id_seq', COALESCE((SELECT MAX(id) FROM committee.committees), 0) + 1, false);
SELECT setval('committee.committee_members_id_seq', COALESCE((SELECT MAX(id) FROM committee.committee_members), 0) + 1, false);
SELECT setval('core.applications_id_seq', COALESCE((SELECT MAX(id) FROM core.applications), 0) + 1, false);
SELECT setval('core.application_history_id_seq', COALESCE((SELECT MAX(id) FROM core.application_history), 0) + 1, false);
SELECT setval('workflow.workflow_instances_id_seq', COALESCE((SELECT MAX(id) FROM workflow.workflow_instances), 0) + 1, false);
SELECT setval('workflow.workflow_actions_id_seq', COALESCE((SELECT MAX(id) FROM workflow.workflow_actions), 0) + 1, false);
SELECT setval('committee.review_assignments_id_seq', COALESCE((SELECT MAX(id) FROM committee.review_assignments), 0) + 1, false);
SELECT setval('committee.scientific_reviews_id_seq', COALESCE((SELECT MAX(id) FROM committee.scientific_reviews), 0) + 1, false);
SELECT setval('committee.ethics_reviews_id_seq', COALESCE((SELECT MAX(id) FROM committee.ethics_reviews), 0) + 1, false);
SELECT setval('committee.application_conditions_id_seq', COALESCE((SELECT MAX(id) FROM committee.application_conditions), 0) + 1, false);
SELECT setval('core.application_amendments_id_seq', COALESCE((SELECT MAX(id) FROM core.application_amendments), 0) + 1, false);

-- =============================================================================
-- COMMITTEES
-- =============================================================================

'@

# =============================================================================
# COMMITTEE DATA
# =============================================================================
# [code, name_ar, name_en, type_id, inst_id, est_date]
$committees = @(
  @{code='NMEC_YE'; na='اللجنة الوطنية للأخلاقيات الطبية'; ne='National Medical Ethics Committee'; tid=1; iid=2; est='2020-01-15'},
  @{code='SUREC_31'; na='لجنة أخلاقيات البحث بجامعة صنعاء'; ne="Sana'a University Research Ethics Committee"; tid=4; iid=31; est='2020-06-01'},
  @{code='AUREC_32'; na='لجنة أخلاقيات البحث بجامعة عدن'; ne='Aden University Research Ethics Committee'; tid=4; iid=32; est='2020-09-15'},
  @{code='NBC_YE'; na='اللجنة الوطنية للسلامة الحيوية'; ne='National Biosafety Committee'; tid=3; iid=3; est='2021-01-10'},
  @{code='SHEC_26'; na="لجنة أخلاقيات مستشفى صنعاء التعليمي"; ne="Sana'a Teaching Hospital Ethics Committee"; tid=1; iid=26; est='2021-03-20'},
  @{code='TRC_33'; na='لجنة أبحاث تعز'; ne='Taiz Research Committee'; tid=4; iid=33; est='2021-06-05'},
  @{code='NSRB_4'; na='مجلس المراجعة العلمية الوطني'; ne='National Scientific Review Board'; tid=5; iid=4; est='2021-09-01'},
  @{code='NRC_YE'; na='المجلس الوطني للبحوث'; ne='National Research Council'; tid=8; iid=2; est='2022-01-01'}
)

foreach ($c in $committees) {
  $escapedNe = $c.ne.Replace("'", "''")
  $escapedNa = $c.na
  $sql += @"
-- Committee: $($c.ne) ($($c.code))
INSERT INTO committee.committees (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, establishment_date, is_active, created_by)
SELECT $($c.iid), '$($c.code)', '$escapedNa', '$escapedNe', $($c.tid), '$($c.est)', true, 1
WHERE NOT EXISTS (SELECT 1 FROM committee.committees WHERE committee_code = '$($c.code)');

"@
}

$sql += @'
-- =============================================================================
-- COMMITTEE MEMBERS
-- =============================================================================
-- Format: committee_code, user_id, role_code, start_date, end_date
-- Chairs (6-10), Members (11-56), Ethics Admins as Secretaries (2-5)
-- Distributed unevenly across committees (workload variation)
--

'@

# Committee Members Data
# [committee_code, user_id, role_id, start_date, end_date (= '' for ongoing)]
# role_id: 1=CHAIR, 2=VICE_CHAIR, 3=MEMBER, 4=SECRETARY, 5=EXTERNAL
$members = @(
  # National IRB (NMEC_YE) — 7 members
  @{cc='NMEC_YE'; uid=6;  rid=1; sd='2020-01-15'; ed='2025-12-31'},
  @{cc='NMEC_YE'; uid=2;  rid=2; sd='2020-01-15'; ed=''},
  @{cc='NMEC_YE'; uid=11; rid=3; sd='2020-03-01'; ed=''},
  @{cc='NMEC_YE'; uid=12; rid=3; sd='2020-03-01'; ed='2025-12-31'},
  @{cc='NMEC_YE'; uid=13; rid=3; sd='2021-01-01'; ed=''},
  @{cc='NMEC_YE'; uid=14; rid=3; sd='2021-06-01'; ed=''},
  @{cc='NMEC_YE'; uid=15; rid=3; sd='2022-01-01'; ed=''},

  # Sana'a REC (SUREC_31) — 6 members
  @{cc='SUREC_31'; uid=8;  rid=1; sd='2020-06-01'; ed=''},
  @{cc='SUREC_31'; uid=16; rid=2; sd='2020-06-01'; ed=''},
  @{cc='SUREC_31'; uid=17; rid=3; sd='2020-07-01'; ed=''},
  @{cc='SUREC_31'; uid=18; rid=3; sd='2020-07-01'; ed='2025-06-30'},
  @{cc='SUREC_31'; uid=19; rid=3; sd='2021-01-01'; ed=''},
  @{cc='SUREC_31'; uid=20; rid=3; sd='2022-01-01'; ed=''},

  # Aden REC (AUREC_32) — 6 members
  @{cc='AUREC_32'; uid=9;  rid=1; sd='2020-09-15'; ed=''},
  @{cc='AUREC_32'; uid=21; rid=2; sd='2020-09-15'; ed=''},
  @{cc='AUREC_32'; uid=22; rid=3; sd='2020-10-01'; ed=''},
  @{cc='AUREC_32'; uid=23; rid=3; sd='2020-10-01'; ed=''},
  @{cc='AUREC_32'; uid=24; rid=3; sd='2021-03-01'; ed='2025-12-31'},
  @{cc='AUREC_32'; uid=25; rid=3; sd='2022-01-01'; ed=''},

  # Biosafety (NBC_YE) — 5 members
  @{cc='NBC_YE'; uid=7;  rid=1; sd='2021-01-10'; ed=''},
  @{cc='NBC_YE'; uid=26; rid=2; sd='2021-01-10'; ed=''},
  @{cc='NBC_YE'; uid=27; rid=3; sd='2021-02-01'; ed=''},
  @{cc='NBC_YE'; uid=28; rid=3; sd='2021-02-01'; ed=''},
  @{cc='NBC_YE'; uid=29; rid=3; sd='2021-06-01'; ed=''},

  # Sana'a Hospital IRB (SHEC_26) — 6 members
  @{cc='SHEC_26'; uid=6;  rid=1; sd='2021-03-20'; ed=''},
  @{cc='SHEC_26'; uid=30; rid=2; sd='2021-03-20'; ed=''},
  @{cc='SHEC_26'; uid=31; rid=3; sd='2021-04-01'; ed=''},
  @{cc='SHEC_26'; uid=32; rid=3; sd='2021-04-01'; ed=''},
  @{cc='SHEC_26'; uid=33; rid=3; sd='2021-07-01'; ed='2025-12-31'},
  @{cc='SHEC_26'; uid=34; rid=3; sd='2022-01-01'; ed=''},

  # Taiz REC (TRC_33) — 5 members
  @{cc='TRC_33'; uid=10; rid=1; sd='2021-06-05'; ed=''},
  @{cc='TRC_33'; uid=35; rid=2; sd='2021-06-05'; ed=''},
  @{cc='TRC_33'; uid=36; rid=3; sd='2021-07-01'; ed=''},
  @{cc='TRC_33'; uid=37; rid=3; sd='2021-07-01'; ed=''},
  @{cc='TRC_33'; uid=38; rid=3; sd='2022-01-01'; ed=''},

  # Scientific Review (NSRB_4) — 5 members
  @{cc='NSRB_4'; uid=8;  rid=1; sd='2021-09-01'; ed=''},
  @{cc='NSRB_4'; uid=39; rid=2; sd='2021-09-01'; ed=''},
  @{cc='NSRB_4'; uid=40; rid=3; sd='2021-10-01'; ed=''},
  @{cc='NSRB_4'; uid=41; rid=3; sd='2021-10-01'; ed=''},
  @{cc='NSRB_4'; uid=42; rid=3; sd='2022-01-01'; ed=''},

  # National Research Council (NRC_YE) — 5 members
  @{cc='NRC_YE'; uid=9;  rid=1; sd='2022-01-01'; ed=''},
  @{cc='NRC_YE'; uid=43; rid=2; sd='2022-01-01'; ed=''},
  @{cc='NRC_YE'; uid=44; rid=3; sd='2022-02-01'; ed=''},
  @{cc='NRC_YE'; uid=45; rid=3; sd='2022-02-01'; ed='2025-12-31'},
  @{cc='NRC_YE'; uid=46; rid=3; sd='2023-01-01'; ed=''},

  # Secretaries (assigned as extra members with SECRETARY role)
  @{cc='NMEC_YE'; uid=3;  rid=4; sd='2020-01-15'; ed=''},
  @{cc='SUREC_31'; uid=4;  rid=4; sd='2020-06-01'; ed=''},
  @{cc='AUREC_32'; uid=5;  rid=4; sd='2020-09-15'; ed=''},
  @{cc='NBC_YE'; uid=3;  rid=4; sd='2021-01-10'; ed=''},
  @{cc='SHEC_26'; uid=4;  rid=4; sd='2021-03-20'; ed=''},
  @{cc='TRC_33'; uid=5;  rid=4; sd='2021-06-05'; ed=''},
  @{cc='NSRB_4'; uid=2;  rid=4; sd='2021-09-01'; ed=''},
  @{cc='NRC_YE'; uid=2;  rid=4; sd='2022-01-01'; ed=''},

  # External members (EXTERNAL role) — for select committees
  @{cc='NMEC_YE'; uid=47; rid=5; sd='2022-01-01'; ed=''},
  @{cc='NRC_YE'; uid=48; rid=5; sd='2022-01-01'; ed=''}
)

$secId = 300 # Secretaries as user_scope reference (not needed, just for data purposes)

foreach ($m in $members) {
  $endDateClause = if ($m.ed -ne '') { "'$($m.ed)'" } else { 'NULL' }
  $sql += @"
INSERT INTO committee.committee_members (committee_id, user_id, membership_start_date, membership_end_date, is_active, role_id, created_by)
SELECT c.id, $($m.uid), '$($m.sd)', $endDateClause, true, $($m.rid), 1
FROM committee.committees c WHERE c.committee_code = '$($m.cc)'
AND NOT EXISTS (SELECT 1 FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.user_id = $($m.uid));

"@
}

# =============================================================================
# APPLICATION DATA
# =============================================================================
# Each application entry:
# project_id, pi_id, inst_id, category, risk, status
# The generator assigns committee, creates transitions, workflow
# =============================================================================

# Build project data from the existing database
$projects = @()

# Project list from core.projects (id, pi_id, inst_id, category, risk, status_code)
# Retrieved from the database earlier
$projects = @(
  @{id=190; pi=65; inst=10; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='CLOSED'}
  @{id=191; pi=66; inst=11; cat='SOCIAL'; risk='LOW'; pstat='APPROVED'}
  @{id=192; pi=67; inst=12; cat='SOCIAL'; risk='LOW'; pstat='ETHICAL_REVIEW'}
  @{id=193; pi=67; inst=12; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='DRAFT'}
  @{id=194; pi=68; inst=13; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='DRAFT'}
  @{id=195; pi=69; inst=14; cat='SOCIAL'; risk='LOW'; pstat='ETHICAL_REVIEW'}
  @{id=196; pi=69; inst=14; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='SUBMITTED'}
  @{id=197; pi=70; inst=15; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='CLOSED'}
  @{id=198; pi=71; inst=16; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='APPROVED'}
  @{id=199; pi=71; inst=16; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='CLOSED'}
  @{id=200; pi=72; inst=17; cat='EPIDEMIOLOGICAL'; risk='HIGH'; pstat='SUBMITTED'}
  @{id=201; pi=73; inst=18; cat='SOCIAL'; risk='LOW'; pstat='CLOSED'}
  @{id=202; pi=73; inst=18; cat='SOCIAL'; risk='LOW'; pstat='APPROVED'}
  @{id=203; pi=74; inst=19; cat='CLINICAL_TRIAL'; risk='LOW'; pstat='SUBMITTED'}
  @{id=204; pi=75; inst=20; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='DRAFT'}
  @{id=205; pi=75; inst=20; cat='GENETIC'; risk='HIGH'; pstat='APPROVED'}
  @{id=206; pi=76; inst=21; cat='CLINICAL_TRIAL'; risk='MEDIUM'; pstat='CLOSED'}
  @{id=207; pi=77; inst=22; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='APPROVED'}
  @{id=208; pi=77; inst=22; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='CLOSED'}
  @{id=209; pi=78; inst=23; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='APPROVED'}
  @{id=210; pi=79; inst=24; cat='SOCIAL'; risk='LOW'; pstat='ETHICAL_REVIEW'}
  @{id=211; pi=79; inst=24; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='APPROVED'}
  @{id=212; pi=80; inst=25; cat='SOCIAL'; risk='MEDIUM'; pstat='SUBMITTED'}
  @{id=213; pi=81; inst=26; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='CLOSED'}
  @{id=214; pi=81; inst=26; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='SUBMITTED'}
  @{id=215; pi=82; inst=27; cat='SOCIAL'; risk='LOW'; pstat='APPROVED'}
  @{id=216; pi=83; inst=28; cat='SOCIAL'; risk='LOW'; pstat='APPROVED'}
  @{id=217; pi=83; inst=28; cat='SOCIAL'; risk='LOW'; pstat='SCIENTIFIC_REVIEW'}
  @{id=218; pi=84; inst=29; cat='SOCIAL'; risk='LOW'; pstat='APPROVED'}
  @{id=219; pi=85; inst=30; cat='CLINICAL_TRIAL'; risk='MEDIUM'; pstat='CLOSED'}
  @{id=220; pi=85; inst=30; cat='SOCIAL'; risk='LOW'; pstat='DRAFT'}
  @{id=221; pi=85; inst=30; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='CLOSED'}
  @{id=222; pi=85; inst=30; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='DRAFT'}
  @{id=223; pi=86; inst=31; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='CLOSED'}
  @{id=224; pi=86; inst=31; cat='CLINICAL_TRIAL'; risk='HIGH'; pstat='ETHICAL_REVIEW'}
  @{id=225; pi=86; inst=31; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='SUBMITTED'}
  @{id=226; pi=87; inst=31; cat='SOCIAL'; risk='LOW'; pstat='APPROVED'}
  @{id=227; pi=87; inst=31; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='SUBMITTED'}
  @{id=228; pi=87; inst=31; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='CLOSED'}
  @{id=229; pi=87; inst=31; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='CLOSED'}
  @{id=230; pi=87; inst=31; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='CLOSED'}
  @{id=231; pi=88; inst=31; cat='GENETIC'; risk='HIGH'; pstat='APPROVED'}
  @{id=232; pi=88; inst=31; cat='CLINICAL_TRIAL'; risk='MEDIUM'; pstat='SUBMITTED'}
  @{id=233; pi=88; inst=31; cat='SOCIAL'; risk='LOW'; pstat='APPROVED'}
  @{id=234; pi=88; inst=31; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='SCIENTIFIC_REVIEW'}
  @{id=235; pi=89; inst=32; cat='EPIDEMIOLOGICAL'; risk='HIGH'; pstat='APPROVED'}
  @{id=236; pi=89; inst=32; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='DRAFT'}
  @{id=237; pi=89; inst=32; cat='SOCIAL'; risk='LOW'; pstat='SCIENTIFIC_REVIEW'}
  @{id=238; pi=90; inst=33; cat='CLINICAL_TRIAL'; risk='LOW'; pstat='DRAFT'}
  @{id=239; pi=90; inst=33; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='APPROVED'}
  @{id=240; pi=90; inst=33; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='ETHICAL_REVIEW'}
  @{id=241; pi=90; inst=33; cat='SOCIAL'; risk='LOW'; pstat='APPROVED'}
  @{id=242; pi=90; inst=33; cat='SOCIAL'; risk='LOW'; pstat='CLOSED'}
  @{id=243; pi=91; inst=34; cat='GENETIC'; risk='HIGH'; pstat='SCIENTIFIC_REVIEW'}
  @{id=244; pi=91; inst=34; cat='GENETIC'; risk='HIGH'; pstat='SCIENTIFIC_REVIEW'}
  @{id=245; pi=91; inst=34; cat='CLINICAL_TRIAL'; risk='MEDIUM'; pstat='SCIENTIFIC_REVIEW'}
  @{id=246; pi=91; inst=34; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='ETHICAL_REVIEW'}
  @{id=247; pi=92; inst=35; cat='SOCIAL'; risk='LOW'; pstat='CLOSED'}
  @{id=248; pi=92; inst=35; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='CLOSED'}
  @{id=249; pi=92; inst=35; cat='GENETIC'; risk='HIGH'; pstat='APPROVED'}
  @{id=250; pi=93; inst=36; cat='GENETIC'; risk='HIGH'; pstat='CLOSED'}
  @{id=251; pi=93; inst=36; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='APPROVED'}
  @{id=252; pi=93; inst=36; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='DRAFT'}
  @{id=253; pi=93; inst=36; cat='SOCIAL'; risk='LOW'; pstat='APPROVED'}
  @{id=254; pi=93; inst=36; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='DRAFT'}
  @{id=255; pi=93; inst=36; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='SUBMITTED'}
  @{id=256; pi=93; inst=36; cat='CLINICAL_TRIAL'; risk='MEDIUM'; pstat='DRAFT'}
  @{id=257; pi=94; inst=37; cat='SOCIAL'; risk='MEDIUM'; pstat='CLOSED'}
  @{id=258; pi=94; inst=37; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='APPROVED'}
  @{id=259; pi=94; inst=37; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='APPROVED'}
  @{id=260; pi=94; inst=37; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='SCIENTIFIC_REVIEW'}
  @{id=261; pi=94; inst=37; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='DRAFT'}
  @{id=262; pi=94; inst=37; cat='EPIDEMIOLOGICAL'; risk='HIGH'; pstat='CLOSED'}
  @{id=263; pi=95; inst=38; cat='GENETIC'; risk='HIGH'; pstat='APPROVED'}
  @{id=264; pi=95; inst=38; cat='CLINICAL_TRIAL'; risk='HIGH'; pstat='CLOSED'}
  @{id=265; pi=95; inst=38; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='DRAFT'}
  @{id=266; pi=95; inst=38; cat='SOCIAL'; risk='LOW'; pstat='SCIENTIFIC_REVIEW'}
  @{id=267; pi=95; inst=38; cat='SOCIAL'; risk='LOW'; pstat='SUBMITTED'}
  @{id=268; pi=95; inst=38; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='APPROVED'}
  @{id=269; pi=95; inst=38; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='APPROVED'}
  @{id=270; pi=95; inst=38; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='SUBMITTED'}
  @{id=271; pi=96; inst=39; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='APPROVED'}
  @{id=272; pi=96; inst=39; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='APPROVED'}
  @{id=273; pi=96; inst=39; cat='SOCIAL'; risk='LOW'; pstat='DRAFT'}
  @{id=274; pi=96; inst=39; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='CLOSED'}
  @{id=275; pi=96; inst=39; cat='SOCIAL'; risk='LOW'; pstat='SUBMITTED'}
  @{id=276; pi=96; inst=39; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='CLOSED'}
  @{id=277; pi=2;  inst=2; cat='CLINICAL_TRIAL'; risk='MEDIUM'; pstat='APPROVED'}
  @{id=278; pi=3;  inst=31; cat='GENETIC'; risk='HIGH'; pstat='DRAFT'}
  @{id=279; pi=6;  inst=31; cat='EPIDEMIOLOGICAL'; risk='MEDIUM'; pstat='DRAFT'}
  @{id=280; pi=6;  inst=31; cat='EPIDEMIOLOGICAL'; risk='LOW'; pstat='APPROVED'}
  @{id=281; pi=7;  inst=31; cat='SOCIAL'; risk='LOW'; pstat='DRAFT'}
  @{id=282; pi=7;  inst=31; cat='SOCIAL'; risk='LOW'; pstat='DRAFT'}
)

# =============================================================================
# WORKFLOW PATH DEFINITIONS
# =============================================================================
# Each path is an array of states with transition info
# [state_code, transition_code, from_state_id, to_state_id]
# transition IDs from DB: 1=SUBMIT, 2=ACCEPT_INITIAL, 5=SEND_TO_SCIENTIFIC,
#   7=SEND_TO_ETHICAL, 9=SEND_TO_COMMITTEE, 11=COMMITTEE_APPROVE,
#   12=COMMITTEE_REJECT, 13=COMMITTEE_RETURN, 14=RESUBMIT,
#   18=COMMITTEE_CONDITIONAL, 19=CONDITIONS_MET, 20=CLOSE,
#   21=ARCHIVE, 25=WITHDRAW, 4=REJECT_SUBMITTED,
#   15=REJECT_FROM_INITIAL, 16=REJECT_FROM_SCIENTIFIC, 22=CONDITIONS_NOT_MET,
#   23=SUBMIT_EVIDENCE, 24=REJECT_CONDITIONS, 6=RETURN_INITIAL,
#   8=RETURN_SCIENTIFIC, 10=RETURN_ETHICAL
# =============================================================================

# State IDs: 1=DRAFT, 2=SUBMITTED, 3=INITIAL_REVIEW, 4=SCIENTIFIC_REVIEW,
# 5=ETHICAL_REVIEW, 6=COMMITTEE_REVIEW, 7=APPROVED, 8=REJECTED, 9=RETURNED,
# 10=AWAITING_CONDITIONS, 11=EVIDENCE_REJECTED, 12=WITHDRAWN, 13=CLOSED, 14=ARCHIVED

# Path definitions as arrays of hashtables:
# @{from=state_id; to=state_id; trans=transition_id; action_by=user_id}

# Path 1: DRAFT → SUBMITTED
$p1 = @(@{f=1;t=2;tr=1})

# Path 2: DRAFT → SUBMITTED → INITIAL_REVIEW
$p2 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2})

# Path 3: DRAFT → SUBMITTED → INITIAL_REVIEW → SCIENTIFIC_REVIEW
$p3 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5})

# Path 4: DRAFT → SUBMITTED → INITIAL_REVIEW → SCIENTIFIC_REVIEW → ETHICAL_REVIEW
$p4 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7})

# Path 5: DRAFT → SUBMITTED → INITIAL_REVIEW → SCIENTIFIC_REVIEW → ETHICAL_REVIEW → COMMITTEE_REVIEW
$p5 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9})

# Path 6: Full approval
$p6 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=7;tr=11})

# Path 7: Full approval → CLOSED
$p7 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=7;tr=11}, @{f=7;t=13;tr=20})

# Path 8: Full → CLOSED → ARCHIVED
$p8 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=7;tr=11}, @{f=7;t=13;tr=20}, @{f=13;t=14;tr=21})

# Path 9: Rejected from committee
$p9 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=8;tr=12})

# Path 10: Returned then resubmitted and approved
$p10 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=9;tr=13}, @{f=9;t=2;tr=14}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=7;tr=11})

# Path 11: Conditional approval → conditions met → approved → closed
$p11 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=10;tr=18}, @{f=10;t=7;tr=19}, @{f=7;t=13;tr=20})

# Path 12: Conditional → evidence rejected → resubmit → approved
$p12 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=10;tr=18}, @{f=10;t=11;tr=22}, @{f=11;t=10;tr=23}, @{f=10;t=7;tr=19}, @{f=7;t=13;tr=20})

# Path 13: Conditional → evidence rejected → rejected
$p13 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=10;tr=18}, @{f=10;t=11;tr=22}, @{f=11;t=8;tr=24})

# Path 14: Returned early (from initial review) then approved
$p14 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=2;tr=6}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=7;tr=11})

# Path 15: Returned from scientific then rejected
$p15 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=2;tr=8}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=8;tr=16})

# Path 16: Rejected at initial review
$p16 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=8;tr=15})

# Path 17: Rejected at submission
$p17 = @(@{f=1;t=2;tr=1}, @{f=2;t=8;tr=4})

# Path 18: Withdrawn from draft
$p18 = @(@{f=1;t=12;tr=25})

# Path 19: Withdrawn from submitted
$p19 = @(@{f=1;t=2;tr=1}, @{f=2;t=12;tr=26})

# Path 20: Conditional → awaiting conditions (still open)
$p20 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=10;tr=18})

# Path 21: Conditional → evidence rejected (still open, not yet rejected)
$p21 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=10;tr=18}, @{f=10;t=11;tr=22})

# Path 22: Short approval (skipping ethical review for low-risk)
$p22 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=7;tr=11})

# Path 23: Returned from ethical then approved
$p23 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=3;tr=10}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=7;tr=11})

# Path 24: Returned from committee then approved
$p24 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=9;tr=13}, @{f=9;t=2;tr=14}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=7;tr=11})

# Path 25: Conditional → evidence rejected → resubmit → awaiting (still awaiting conditions after resubmit)
$p25 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=10;tr=18}, @{f=10;t=11;tr=22}, @{f=11;t=10;tr=23})

# Path 26: Returned from committee (ends in RETURNED state)
$p26 = @(@{f=1;t=2;tr=1}, @{f=2;t=3;tr=2}, @{f=3;t=4;tr=5}, @{f=4;t=5;tr=7}, @{f=5;t=6;tr=9}, @{f=6;t=9;tr=13})

# Assign path index to each project
# Format: @{proj_id=idx; pi=userid; inst=institutionid}
# path_index: 0=DRAFT only, 1=SUBMITTED, 2=INITIAL_REVIEW, 3=SCIENTIFIC_REVIEW,
#   4=ETHICAL_REVIEW, 5=COMMITTEE_REVIEW, 6=FULL_APPROVED, 7=APPROVED_CLOSED,
#   8=ARCHIVED, 9=REJECTED_COMMITTEE, 10=RETURNED_APPROVED, 11=CONDITIONS_MET,
#   12=EVIDENCE_FIXED, 13=EVIDENCE_REJECTED, 14=RETURNED_EARLY_APPROVED,
#   15=RETURNED_REJECTED, 16=REJECTED_INITIAL, 17=REJECTED_SUBMIT,
#   18=WITHDRAWN_DRAFT, 19=WITHDRAWN_SUBMITTED, 20=AWAITING_CONDITIONS,
#   21=EVIDENCE_REJECTED_OPEN, 22=SHORT_APPROVED, 23=RETURNED_ETHICAL,
#   24=RETURNED_COMMITTEE_APPROVED, 25=EVIDENCE_RESUBMITTED_AWAITING

function Get-ApplicationType {
  param($projectStatus, $isAmendment = $false)
  if ($isAmendment) { return 'AMENDMENT' }
  return 'NEW'
}

function Get-PriorityLevel {
  param($risk, $category)
  if ($risk -eq 'HIGH') { return 'HIGH' }
  if ($category -eq 'CLINICAL_TRIAL') { return 'HIGH' }
  if ($risk -eq 'MEDIUM') { return 'NORMAL' }
  return 'NORMAL'
}

function Get-AssignedCommittee {
  param($projectId, $instId, $category, $risk)
  # Rules-based committee assignment
  if ($category -eq 'CLINICAL_TRIAL') { return 'NMEC_YE' }        # Clinical trials → National IRB
  if ($category -eq 'GENETIC' -and $risk -eq 'HIGH') { return 'NBC_YE' }  # Genetic HIGH → Biosafety
  if ($instId -eq 31) { return 'SUREC_31' }    # Sana'a University → Sana'a REC
  if ($instId -eq 32) { return 'AUREC_32' }    # Aden University → Aden REC
  if ($instId -eq 33) { return 'TRC_33' }      # Taiz University → Taiz REC
  if ($instId -eq 26 -or $instId -eq 27) { return 'SHEC_26' }  # Teaching hospitals → Hospital IRB
  if ($instId -eq 4 -or $instId -eq 5) { return 'NSRB_4' }     # NIPH, Oncology → Scientific Review
  if ($instId -eq 3 -or $instId -eq 36 -or $instId -eq 37 -or $instId -eq 38) { return 'NBC_YE' }  # Labs → Biosafety
  if ($risk -eq 'HIGH') { return 'NMEC_YE' }   # HIGH risk → National IRB
  return 'SUREC_31'  # Default to Sana'a REC
}

# Assign path to each project
# Structure: [project_id, path_index, is_amendment]
$appAssignments = @(
  # All 93 projects with realistic status distribution
  @{pid=190; pi=8}   # Archived
  @{pid=191; pi=7}   # Closed
  @{pid=192; pi=4}   # Ethical review
  @{pid=193; pi=2}   # Initial review
  @{pid=194; pi=18}  # Withdrawn from draft
  @{pid=195; pi=4}   # Ethical review
  @{pid=196; pi=1}   # Submitted
  @{pid=197; pi=8}   # Archived
  @{pid=198; pi=22}  # Short approved
  @{pid=199; pi=7}   # Closed
  @{pid=200; pi=17}  # Rejected at submit (HIGH risk)
  @{pid=201; pi=8}   # Archived
  @{pid=202; pi=22}  # Short approved
  @{pid=203; pi=5}   # Committee review (clinical trial)
  @{pid=204; pi=0}   # Draft
  @{pid=205; pi=6}   # Full approved (genetic)
  @{pid=206; pi=7}   # Closed (clinical trial)
  @{pid=207; pi=6}   # Full approved
  @{pid=208; pi=7}   # Closed
  @{pid=209; pi=22}  # Short approved
  @{pid=210; pi=4}   # Ethical review
  @{pid=211; pi=6}   # Full approved
  @{pid=212; pi=1}   # Submitted
  @{pid=213; pi=7}   # Closed
  @{pid=214; pi=19}  # Withdrawn from submitted
  @{pid=215; pi=6}   # Full approved
  @{pid=216; pi=22}  # Short approved
  @{pid=217; pi=3}   # Scientific review
  @{pid=218; pi=6}   # Full approved
  @{pid=219; pi=7}   # Closed (clinical trial)
  @{pid=220; pi=0}   # Draft
  @{pid=221; pi=7}   # Closed
  @{pid=222; pi=18}  # Withdrawn from draft
  @{pid=223; pi=7}   # Closed
  @{pid=224; pi=5}   # Committee review (clinical trial HIGH)
  @{pid=225; pi=1}   # Submitted
  @{pid=226; pi=6}   # Full approved
  @{pid=227; pi=1}   # Submitted
  @{pid=228; pi=7}   # Closed
  @{pid=229; pi=7}   # Closed
  @{pid=230; pi=8}   # Archived
  @{pid=231; pi=6}   # Full approved (genetic)
  @{pid=232; pi=19}  # Withdrawn from submitted (clinical trial)
  @{pid=233; pi=6}   # Full approved
  @{pid=234; pi=3}   # Scientific review
  @{pid=235; pi=6}   # Full approved (HIGH)
  @{pid=236; pi=0}   # Draft
  @{pid=237; pi=3}   # Scientific review
  @{pid=238; pi=0}   # Draft
  @{pid=239; pi=22}  # Short approved
  @{pid=240; pi=4}   # Ethical review
  @{pid=241; pi=6}   # Full approved
  @{pid=242; pi=7}   # Closed
  @{pid=243; pi=3}   # Scientific review (genetic)
  @{pid=244; pi=15}  # Returned from scientific → rejected (genetic)
  @{pid=245; pi=16}  # Rejected at initial (clinical trial)
  @{pid=246; pi=4}   # Ethical review
  @{pid=247; pi=8}   # Archived
  @{pid=248; pi=7}   # Closed
  @{pid=249; pi=6}   # Full approved (genetic)
  @{pid=250; pi=7}   # Closed (genetic)
  @{pid=251; pi=6}   # Full approved
  @{pid=252; pi=0}   # Draft
  @{pid=253; pi=6}   # Full approved
  @{pid=254; pi=0}   # Draft
  @{pid=255; pi=1}   # Submitted
  @{pid=256; pi=0}   # Draft
  @{pid=257; pi=7}   # Closed
  @{pid=258; pi=11}  # Conditions met → closed
  @{pid=259; pi=22}  # Short approved
  @{pid=260; pi=3}   # Scientific review
  @{pid=261; pi=0}   # Draft
  @{pid=262; pi=7}   # Closed (HIGH)
  @{pid=263; pi=6}   # Full approved (genetic)
  @{pid=264; pi=7}   # Closed (clinical trial HIGH)
  @{pid=265; pi=0}   # Draft
  @{pid=266; pi=3}   # Scientific review
  @{pid=267; pi=1}   # Submitted
  @{pid=268; pi=6}   # Full approved
  @{pid=269; pi=22}  # Short approved
  @{pid=270; pi=1}   # Submitted
  @{pid=271; pi=6}   # Full approved
  @{pid=272; pi=23}  # Returned from ethical → approved
  @{pid=273; pi=26}  # Returned from committee
  @{pid=274; pi=7}   # Closed
  @{pid=275; pi=1}   # Submitted
  @{pid=276; pi=7}   # Closed
  @{pid=277; pi=6}   # Full approved (clinical trial)
  @{pid=278; pi=0}   # Draft (genetic)
  @{pid=279; pi=0}   # Draft
  @{pid=280; pi=22}  # Short approved
  @{pid=281; pi=18}  # Withdrawn from draft
  @{pid=282; pi=18}  # Withdrawn from draft
)

# Extra applications (amendments) for 7 projects
# These create additional applications for projects that already have one
$amendments = @(
  @{pid=205; pi=10}  # Genetic HIGH → amendment returned then approved
  @{pid=249; pi=12}  # Genetic HIGH → amendment evidence fixed
  @{pid=207; pi=11}  # Epidemiological → amendment conditions met → closed
  @{pid=277; pi=21}  # Clinical trial → amendment evidence rejected
  @{pid=258; pi=20}  # Epidemiological → amendment awaiting conditions
  @{pid=271; pi=25}  # Amendment evidence resubmitted, awaiting
  @{pid=251; pi=7}   # Amendment closed
)

# =============================================================================
# APPLICATION NUMBER GENERATION
# =============================================================================
# Format: APP-YYYY-NNNNNN
# We use sequential numbers starting from 1001 to avoid collision with
# the auto-increment sequence (which starts from 1)
# =============================================================================

$appNum = 1001

# Path names for reference
$pathNames = @(
  'DRAFT',
  'SUBMITTED',
  'INITIAL_REVIEW',
  'SCIENTIFIC_REVIEW',
  'ETHICAL_REVIEW',
  'COMMITTEE_REVIEW',
  'FULL_APPROVED',
  'APPROVED_CLOSED',
  'ARCHIVED',
  'REJECTED_COMMITTEE',
  'RETURNED_APPROVED',
  'CONDITIONS_MET',
  'EVIDENCE_FIXED',
  'EVIDENCE_REJECTED',
  'RETURNED_EARLY_APPROVED',
  'RETURNED_REJECTED',
  'REJECTED_INITIAL',
  'REJECTED_SUBMIT',
  'WITHDRAWN_DRAFT',
  'WITHDRAWN_SUBMITTED',
  'AWAITING_CONDITIONS',
  'EVIDENCE_REJECTED_OPEN',
  'SHORT_APPROVED',
  'RETURNED_ETHICAL',
  'RETURNED_COMMITTEE_APPROVED',
  'EVIDENCE_RESUBMITTED_AWAITING',
  'RETURNED'
)

# All available paths indexed
$allPaths = @(
  @(),                    # 0: DRAFT (no transitions)
  $p1,                    # 1: SUBMITTED
  $p2,                    # 2: INITIAL_REVIEW
  $p3,                    # 3: SCIENTIFIC_REVIEW
  $p4,                    # 4: ETHICAL_REVIEW
  $p5,                    # 5: COMMITTEE_REVIEW
  $p6,                    # 6: FULL_APPROVED
  $p7,                    # 7: APPROVED_CLOSED
  $p8,                    # 8: ARCHIVED
  $p9,                    # 9: REJECTED_COMMITTEE
  $p10,                   # 10: RETURNED_APPROVED
  $p11,                   # 11: CONDITIONS_MET
  $p12,                   # 12: EVIDENCE_FIXED
  $p13,                   # 13: EVIDENCE_REJECTED
  $p14,                   # 14: RETURNED_EARLY_APPROVED
  $p15,                   # 15: RETURNED_REJECTED
  $p16,                   # 16: REJECTED_INITIAL
  $p17,                   # 17: REJECTED_SUBMIT
  $p18,                   # 18: WITHDRAWN_DRAFT
  $p19,                   # 19: WITHDRAWN_SUBMITTED
  $p20,                   # 20: AWAITING_CONDITIONS
  $p21,                   # 21: EVIDENCE_REJECTED_OPEN
  $p22,                   # 22: SHORT_APPROVED
  $p23,                   # 23: RETURNED_ETHICAL
  $p24,                   # 24: RETURNED_COMMITTEE_APPROVED
  $p25,                   # 25: EVIDENCE_RESUBMITTED_AWAITING
  $p26                    # 26: RETURNED
)

# Current status for each path (last state in the path)
$pathFinalStates = @(
  'DRAFT',                # 0
  'SUBMITTED',            # 1
  'INITIAL_REVIEW',       # 2
  'SCIENTIFIC_REVIEW',    # 3
  'ETHICAL_REVIEW',       # 4
  'COMMITTEE_REVIEW',     # 5
  'APPROVED',             # 6
  'CLOSED',               # 7
  'ARCHIVED',             # 8
  'REJECTED',             # 9
  'APPROVED',             # 10
  'CLOSED',               # 11
  'CLOSED',               # 12
  'REJECTED',             # 13
  'APPROVED',             # 14
  'REJECTED',             # 15
  'REJECTED',             # 16
  'REJECTED',             # 17
  'WITHDRAWN',            # 18
  'WITHDRAWN',            # 19
  'AWAITING_CONDITIONS',  # 20
  'EVIDENCE_REJECTED',    # 21
  'APPROVED',             # 22
  'APPROVED',             # 23
  'APPROVED',             # 24
  'AWAITING_CONDITIONS',   # 25
  'RETURNED'               # 26
)

$pathTerminalStates = @('ARCHIVED', 'REJECTED', 'WITHDRAWN')

$sql += @'
-- =============================================================================
-- APPLICATIONS
-- =============================================================================
-- Each application is linked to an existing project.
-- Applications are distributed across 14 workflow states with realistic
-- transition histories and committee assignments.
-- =============================================================================

'@

# Process each application
$appIdx = 0

# Temp hash to store application data for history generation
$appData = @{}

function Write-ApplicationInserts {
  param($project, $pathIdx, $isAmendment = $false)

  $script:appIdx++
  $script:appNum++
  
  $projId = $project.id
  $piId = $project.pi
  $instId = $project.inst
  $category = $project.cat
  $risk = $project.risk
  $projStatus = $project.pstat
  $appType = Get-ApplicationType -projectStatus $projStatus -isAmendment $isAmendment
  
  $committeeCode = Get-AssignedCommittee -projectId $projId -instId $instId -category $category -risk $risk
  $priority = Get-PriorityLevel -risk $risk -category $category
  $finalStatus = $pathFinalStates[$pathIdx]
  $isTerminal = $finalStatus -in $pathTerminalStates
  
  $path = $allPaths[$pathIdx]
  
  # Generate application number and dates
  $appYear = if ($appNum -lt 1030) { '2025' } else { '2026' }
  $appNumStr = $appNum.ToString('000000')
  $appNumber = "APP-$appYear-$appNumStr"
  
  # Generate submission date based on path
  # If path has SUBMIT transition, set submission_date
  $hasSubmission = $path.Length -gt 0
  $submissionDateStr = 'NULL'
  $submittedByStr = 'NULL'
  
  if ($hasSubmission) {
    # Calculate submission date based on created_at
    # For simplicity, submission date = created_at + some days
    $submissionDateStr = "(created_at + interval '$(Get-Random -Minimum 1 -Maximum 14) days')"
    $submittedByStr = $piId
  }
  
  # Created_by
  $createdBy = if ($isAmendment) { $piId } else { 1 }
  
  # Generate base creation date (projects were created ~2024-2025)
  # Applications created after their project was created
  # Let's distribute from 2025-01 to 2026-07
  
  # Generate dates for transitions
  $baseDate = switch ($appYear) {
    '2025' { Get-Date '2025-01-15' }
    '2026' { Get-Date '2026-01-10' }
  }
  $dateOffset = [Math]::Floor($appIdx / 3) + (Get-Random -Minimum 0 -Maximum 10)
  $createDate = $baseDate.AddDays($dateOffset)
  $createDateStr = $createDate.ToString('yyyy-MM-dd HH:mm:ss') + '+03'
  
  $remarksAr = switch ($finalStatus) {
    'DRAFT' { 'مسودة طلب لم يتم تقديمه بعد' }
    'SUBMITTED' { 'تم تقديم الطلب ويجري مراجعته' }
    'INITIAL_REVIEW' { 'الطلب قيد المراجعة الأولية' }
    'SCIENTIFIC_REVIEW' { 'الطلب قيد المراجعة العلمية' }
    'ETHICAL_REVIEW' { 'الطلب قيد المراجعة الأخلاقية' }
    'COMMITTEE_REVIEW' { 'الطلب قيد مراجعة اللجنة' }
    'APPROVED' { 'تمت الموافقة على الطلب' }
    'CLOSED' { 'تم إغلاق الطلب بعد الانتهاء' }
    'REJECTED' { 'تم رفض الطلب' }
    'WITHDRAWN' { 'تم سحب الطلب من قبل مقدمه' }
    'ARCHIVED' { 'تم أرشفة الطلب' }
    'RETURNED' { 'أعيد الطلب للتعديل' }
    'AWAITING_CONDITIONS' { 'بانتظار استيفاء الشروط' }
    'EVIDENCE_REJECTED' { 'الأدلة المقدمة غير مقبولة' }
    default { 'طلب بحث علمي' }
  }
  
  $remarksEn = switch ($finalStatus) {
    'DRAFT' { 'Draft application not yet submitted' }
    'SUBMITTED' { 'Application submitted and under review' }
    'INITIAL_REVIEW' { 'Application under initial review' }
    'SCIENTIFIC_REVIEW' { 'Application under scientific review' }
    'ETHICAL_REVIEW' { 'Application under ethical review' }
    'COMMITTEE_REVIEW' { 'Application under committee review' }
    'APPROVED' { 'Application has been approved' }
    'CLOSED' { 'Application closed after completion' }
    'REJECTED' { 'Application has been rejected' }
    'WITHDRAWN' { 'Application withdrawn by applicant' }
    'ARCHIVED' { 'Application archived' }
    'RETURNED' { 'Application returned for revision' }
    'AWAITING_CONDITIONS' { 'Awaiting conditions to be met' }
    'EVIDENCE_REJECTED' { 'Submitted evidence not acceptable' }
    default { 'Scientific research application' }
  }
  
  $remarks = if ($isAmendment) { "Amendment: $remarksEn" } else { $remarksEn }
  
  # Escape single quotes in remarks
  $remarksSafe = $remarks -replace "'", "''"
  $remarksArSafe = $remarksAr -replace "'", "''"
  
  # Store for history generation
  $key = "app_$appIdx"
  $appData[$key] = @{
    pid = $projId
    piId = $piId
    committeeCode = $committeeCode
    path = $path
    finalStatus = $finalStatus
    isTerminal = $isTerminal
    createDateStr = $createDateStr
    createDate = $createDate
    appNumber = $appNumber
    appIdx = $appIdx
    isAmendment = $isAmendment
    priority = $priority
  }
  
  # Generate INSERT
  $sql = @"
-- Application $($appIdx): Project $projId → $finalStatus ($($pathNames[$pathIdx]))
INSERT INTO core.applications (project_id, application_number, application_type, current_status, submission_date, submitted_by, priority_level, target_committee_id, remarks, created_by, created_at, updated_at)
SELECT
  $projId,
  '$appNumber',
  '$appType',
  '$finalStatus',
  $submissionDateStr,
  $submittedByStr,
  '$priority',
  c.id,
  '$remarksSafe',
  $createdBy,
  '$createDateStr'::timestamptz,
  '$createDateStr'::timestamptz
FROM committee.committees c WHERE c.committee_code = '$committeeCode';

"@

  return $sql
}

# Generate all application INSERTs
$allAppInserts = @()
$appIdx = 0

foreach ($assignment in $appAssignments) {
  $proj = $projects | Where-Object { $_.id -eq $assignment.pid }
  if ($proj) {
    $allAppInserts += Write-ApplicationInserts -project $proj -pathIdx $assignment.pi -isAmendment $false
  }
}

foreach ($amendment in $amendments) {
  $proj = $projects | Where-Object { $_.id -eq $amendment.pid }
  if ($proj) {
    $allAppInserts += Write-ApplicationInserts -project $proj -pathIdx $amendment.pi -isAmendment $true
  }
}

$sql += $allAppInserts -join ''

# =============================================================================
# APPLICATION HISTORY
# =============================================================================
# For each application with a path > 0, create history entries for each transition
# =============================================================================

$sql += @'

-- =============================================================================
-- APPLICATION HISTORY
-- =============================================================================

'@

$historySql = @()
$actionSql = @()
$workflowSql = @()

$stateNames = @{
  1 = 'DRAFT'
  2 = 'SUBMITTED'
  3 = 'INITIAL_REVIEW'
  4 = 'SCIENTIFIC_REVIEW'
  5 = 'ETHICAL_REVIEW'
  6 = 'COMMITTEE_REVIEW'
  7 = 'APPROVED'
  8 = 'REJECTED'
  9 = 'RETURNED'
  10 = 'AWAITING_CONDITIONS'
  11 = 'EVIDENCE_REJECTED'
  12 = 'WITHDRAWN'
  13 = 'CLOSED'
  14 = 'ARCHIVED'
}

$actionTypeNames = @{
  1  = 'SUBMIT'
  2  = 'ACCEPT_INITIAL'
  3  = 'RETURN_SUBMITTED'
  4  = 'REJECT_SUBMITTED'
  5  = 'SEND_TO_SCIENTIFIC'
  6  = 'RETURN_INITIAL'
  7  = 'SEND_TO_ETHICAL'
  8  = 'RETURN_SCIENTIFIC'
  9  = 'SEND_TO_COMMITTEE'
  10 = 'RETURN_ETHICAL'
  11 = 'COMMITTEE_APPROVE'
  12 = 'COMMITTEE_REJECT'
  13 = 'COMMITTEE_RETURN'
  14 = 'RESUBMIT'
  15 = 'REJECT_FROM_INITIAL'
  16 = 'REJECT_FROM_SCIENTIFIC'
  17 = 'REJECT_FROM_ETHICAL'
  18 = 'COMMITTEE_CONDITIONAL'
  19 = 'CONDITIONS_MET'
  20 = 'CLOSE'
  21 = 'ARCHIVE'
  22 = 'CONDITIONS_NOT_MET'
  23 = 'SUBMIT_EVIDENCE'
  24 = 'REJECT_CONDITIONS'
  25 = 'WITHDRAW'
}

$historyIdx = 0
$workflowIdx = 0
$actionIdx = 0

foreach ($key in $appData.Keys | Sort-Object) {
  $ad = $appData[$key]
  $path = $ad.path
  $appIdx = $ad.appIdx
  $piId = $ad.piId
  $finalStatus = $ad.finalStatus
  $isTerminal = $ad.isTerminal
  
  if ($path.Length -eq 0) { continue }  # DRAFT with no transitions
  
  # Workflow instance
  $workflowIdx++
  $currentStateId = if ($finalStatus -eq 'ARCHIVED') { 14 } elseif ($finalStatus -eq 'CLOSED') { 13 } elseif ($finalStatus -eq 'APPROVED') { 7 } elseif ($finalStatus -eq 'REJECTED') { 8 } elseif ($finalStatus -eq 'WITHDRAWN') { 12 } else { $path[-1].t }
  
  # Map status to workflow state ID
  $statusToStateId = @{
    'SUBMITTED' = 2
    'INITIAL_REVIEW' = 3
    'SCIENTIFIC_REVIEW' = 4
    'ETHICAL_REVIEW' = 5
    'COMMITTEE_REVIEW' = 6
    'APPROVED' = 7
    'REJECTED' = 8
    'RETURNED' = 9
    'AWAITING_CONDITIONS' = 10
    'EVIDENCE_REJECTED' = 11
    'WITHDRAWN' = 12
    'CLOSED' = 13
    'ARCHIVED' = 14
  }
  
  $currentStateId = $statusToStateId[$finalStatus]
  
  $wfStatusCode = if ($isTerminal) { 'COMPLETED' } else { 'ACTIVE' }
  
  $workflowSql += @"
INSERT INTO workflow.workflow_instances (workflow_id, entity_type, entity_id, current_state_id, started_at, status_code, created_by)
SELECT 1, 'Application', a.id, $currentStateId, a.created_at, '$wfStatusCode', 1
FROM core.applications a WHERE a.application_number = '$($ad.appNumber)';

"@
  
  # For each transition in the path, create history + action
  $lastDate = $ad.createDate
  $lastStatus = 'DRAFT'
  
  for ($t = 0; $t -lt $path.Length; $t++) {
    $trans = $path[$t]
    $historyIdx++
    
    $fromState = $stateNames[$trans.f]
    $toState = $stateNames[$trans.t]
    $actionType = $actionTypeNames[$trans.tr]
    
    # Generate incrementing dates (each step is 1-30 days later)
    $stepDays = Get-Random -Minimum 2 -Maximum 21
    $stepDate = $lastDate.AddDays($stepDays)
    $stepDateStr = $stepDate.ToString('yyyy-MM-dd HH:mm:ss') + '+03'
    
    # Action by: PI for SUBMIT/WITHDRAW/RESUBMIT, committee user for others
    $actionBy = if ($trans.tr -in @(1, 14, 23, 25, 26)) { $piId } else {
      switch ($trans.tr) {
        {$_ -in @(2, 3, 4, 15)} { 2 }  # ETHICS_ADMIN
        {$_ -in @(5, 6, 7, 8, 16)} { 6 }  # COMMITTEE_CHAIR
        {$_ -in @(9, 10, 11, 12, 13, 17, 18, 19)} { 8 } # CHAIR
        {$_ -in @(20, 21)} { 2 }  # ADMIN
        {$_ -in @(22, 24)} { 6 }  # CHAIR
        default { 1 }  # ADMIN
      }
    }
    
    $remarksAr = ''
    $remarksEn = ''
    
    switch ($trans.tr) {
      1  { $remarksAr = 'تقديم الطلب'; $remarksEn = 'Application submitted' }
      2  { $remarksAr = 'قبول الطلب للمراجعة الأولية'; $remarksEn = 'Accepted for initial review' }
      5  { $remarksAr = 'تحويل للمراجعة العلمية'; $remarksEn = 'Sent for scientific review' }
      7  { $remarksAr = 'تحويل للمراجعة الأخلاقية'; $remarksEn = 'Sent for ethical review' }
      9  { $remarksAr = 'تحويل لمراجعة اللجنة'; $remarksEn = 'Sent for committee review' }
      11 { $remarksAr = 'الموافقة على الطلب'; $remarksEn = 'Application approved' }
      12 { $remarksAr = 'رفض الطلب من قبل اللجنة'; $remarksEn = 'Application rejected by committee' }
      13 { $remarksAr = 'إعادة الطلب للتعديل'; $remarksEn = 'Application returned for revision' }
      14 { $remarksAr = 'إعادة تقديم الطلب بعد التعديل'; $remarksEn = 'Application resubmitted after revision' }
      18 { $remarksAr = 'موافقة مشروطة'; $remarksEn = 'Conditional approval granted' }
      19 { $remarksAr = 'تم استيفاء الشروط'; $remarksEn = 'Conditions have been met' }
      20 { $remarksAr = 'إغلاق الطلب'; $remarksEn = 'Application closed' }
      21 { $remarksAr = 'أرشفة الطلب'; $remarksEn = 'Application archived' }
      25 { $remarksAr = 'سحب الطلب من المسودة'; $remarksEn = 'Application withdrawn from draft' }
      26 { $remarksAr = 'سحب الطلب بعد التقديم'; $remarksEn = 'Application withdrawn after submission' }
      22 { $remarksAr = 'الشروط غير مستوفاة'; $remarksEn = 'Conditions not met' }
      23 { $remarksAr = 'تقديم أدلة جديدة'; $remarksEn = 'New evidence submitted' }
      24 { $remarksAr = 'رفض الطلب لعدم استيفاء الشروط'; $remarksEn = 'Rejected due to unmet conditions' }
      4  { $remarksAr = 'رفض الطلب بعد التقديم'; $remarksEn = 'Rejected after submission' }
      15 { $remarksAr = 'رفض الطلب من المراجعة الأولية'; $remarksEn = 'Rejected at initial review' }
      16 { $remarksAr = 'رفض الطلب من المراجعة العلمية'; $remarksEn = 'Rejected at scientific review' }
      6  { $remarksAr = 'إعادة للمراجعة الأولية'; $remarksEn = 'Returned to initial review' }
      8  { $remarksAr = 'إعادة من المراجعة العلمية'; $remarksEn = 'Returned from scientific review' }
      10 { $remarksAr = 'إعادة من المراجعة الأخلاقية'; $remarksEn = 'Returned from ethical review' }
      default { $remarksAr = 'تحديث حالة الطلب'; $remarksEn = 'Application status updated' }
    }

    $remarksSafe = $remarksEn -replace "'", "''"
    
    # History entry
    $historySql += @"
INSERT INTO core.application_history (application_id, action_type, old_value, new_value, action_by, action_at, remarks)
SELECT a.id, '$actionType', '$fromState', '$toState', $actionBy, '$stepDateStr'::timestamptz, '$remarksSafe'
FROM core.applications a WHERE a.application_number = '$($ad.appNumber)';

"@
    
    # Workflow action
    $actionIdx++
    $actionSql += @"
INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment, action_date)
SELECT wi.id, $($trans.tr), $actionBy, '$remarksSafe', '$stepDateStr'::timestamptz
FROM workflow.workflow_instances wi
JOIN core.applications a ON a.id = wi.entity_id AND wi.entity_type = 'Application'
WHERE a.application_number = '$($ad.appNumber)';

"@
    
    $lastDate = $stepDate
    $lastStatus = $toState
  }
}

$sql += $historySql -join ''
$sql += $workflowSql -join ''
$sql += $actionSql -join ''

# =============================================================================
# REVIEW ASSIGNMENTS
# =============================================================================

$sql += @'

-- =============================================================================
-- REVIEW ASSIGNMENTS
-- =============================================================================
-- Create review assignments for applications in review states
-- Scientific reviewers for SCIENTIFIC_REVIEW state
-- Ethics reviewers for ETHICAL_REVIEW state
-- =============================================================================

'@

# Define reviewer assignments per committee
# [committee_code, application_number, review_type, reviewer_id, assigned_by, due_date_days]
$reviewAssignments = @()

# Helper to get committee member IDs for a committee
function Get-CommitteeMembers {
  param($committeeCode)
  $cMembers = $members | Where-Object { $_.cc -eq $committeeCode -and $_.rid -eq 3 }
  return $cMembers | ForEach-Object { $_.uid }
}

# Helper to get committee chair IDs
function Get-CommitteeChairs {
  param($committeeCode)
  $cChairs = $members | Where-Object { $_.cc -eq $committeeCode -and $_.rid -eq 1 }
  if ($cChairs.Count -eq 0) { $cChairs = $members | Where-Object { $_.cc -eq $committeeCode -and $_.rid -eq 2 } }
  return $cChairs | ForEach-Object { $_.uid }
}

# Create review assignments for applications in review states
function Add-ReviewAssignment {
  param($appNumber, $committeeCode, $appType, $appIdx)
  
  $reviewerIds = Get-CommitteeMembers -committeeCode $committeeCode
  $chairIds = Get-CommitteeChairs -committeeCode $committeeCode
  
  if ($reviewerIds.Count -eq 0) { return @() }
  
  $assignments = @()
  
  # Scientific review: assign 2 reviewers
  if ($appType -eq 'SCIENTIFIC_REVIEW' -or $appType -in @('ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 'APPROVED', 'CLOSED', 'ARCHIVED', 'REJECTED', 'AWAITING_CONDITIONS', 'EVIDENCE_REJECTED')) {
    $sciReviewers = @($reviewerIds[0], $reviewerIds[1 % $reviewerIds.Count])
    foreach ($rv in $sciReviewers) {
      $assignments += @{
        appNumber = $appNumber
        reviewType = 'SCIENTIFIC'
        reviewerId = $rv
        assignedBy = if ($chairIds.Count -gt 0) { $chairIds[0] } else { 1 }
        dueDays = 21
      }
    }
  }
  
  # Ethics review: assign 2 reviewers (different from scientific)
  if ($appType -in @('ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 'APPROVED', 'CLOSED', 'ARCHIVED', 'REJECTED', 'AWAITING_CONDITIONS', 'EVIDENCE_REJECTED')) {
    $ethReviewers = @($reviewerIds[2 % $reviewerIds.Count], $reviewerIds[3 % $reviewerIds.Count])
    # Ensure different from scientific reviewers if possible
    foreach ($rv in $ethReviewers) {
      $assignments += @{
        appNumber = $appNumber
        reviewType = 'ETHICAL'
        reviewerId = $rv
        assignedBy = if ($chairIds.Count -gt 1) { $chairIds[1] } else { 1 }
        dueDays = 28
      }
    }
  }
  
  return $assignments
}

$reviewSql = @()

foreach ($key in $appData.Keys | Sort-Object) {
  $ad = $appData[$key]
  $appNumber = $ad.appNumber
  $committeeCode = $ad.committeeCode
  $finalStatus = $ad.finalStatus
  $appIdx = $ad.appIdx
  $piId = $ad.piId
  $path = $ad.path
  
  # Create review assignments based on final status
  $assigns = Add-ReviewAssignment -appNumber $appNumber -committeeCode $committeeCode -appType $finalStatus -appIdx $appIdx
  
  $raIdx = 0
  foreach ($ra in $assigns) {
    $raIdx++
    $dueDate = if ($ra.dueDays -gt 0) { "(a.created_at + interval '$($ra.dueDays) days')" } else { 'NULL' }
    $reviewSql += @"
INSERT INTO committee.review_assignments (application_id, reviewer_id, review_type, assigned_by, due_date)
SELECT a.id, $($ra.reviewerId), '$($ra.reviewType)', $($ra.assignedBy), $dueDate
FROM core.applications a WHERE a.application_number = '$appNumber'
AND NOT EXISTS (SELECT 1 FROM committee.review_assignments ra WHERE ra.application_id = a.id AND ra.reviewer_id = $($ra.reviewerId) AND ra.review_type = '$($ra.reviewType)');

"@
  }
}

$sql += $reviewSql -join ''

# =============================================================================
# SCIENTIFIC REVIEWS
# =============================================================================

$sql += @'

-- =============================================================================
-- SCIENTIFIC REVIEWS
-- =============================================================================

'@

$sciReviewSql = @()

foreach ($key in $appData.Keys | Sort-Object) {
  $ad = $appData[$key]
  $appNumber = $ad.appNumber
  $finalStatus = $ad.finalStatus
  $path = $ad.path
  
  if ($finalStatus -notin @('SCIENTIFIC_REVIEW', 'ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 'APPROVED', 'CLOSED', 'ARCHIVED', 'REJECTED', 'AWAITING_CONDITIONS', 'EVIDENCE_REJECTED', 'RETURNED')) {
    continue
  }
  
  $recommendation = switch ($finalStatus) {
    'REJECTED' { 'REJECTED' }
    'RETURNED' { 'REVISION' }
    default { 'APPROVED' }
  }
  
  $sciReviewSummary = 'Scientific review completed: methodology sound, statistical analysis appropriate, objectives clearly defined.'
  
  $sciReviewSql += @"
INSERT INTO committee.scientific_reviews (application_id, reviewer_id, review_status, recommendation, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  '$recommendation',
  '$sciReviewSummary',
  (a.created_at + interval '5 days')::timestamptz,
  (a.created_at + interval '15 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'SCIENTIFIC'
WHERE a.application_number = '$appNumber'
LIMIT 1;

"@
}

$sql += $sciReviewSql -join ''

# =============================================================================
# ETHICS REVIEWS
# =============================================================================

$sql += @'

-- =============================================================================
-- ETHICS REVIEWS
-- =============================================================================

'@

$ethReviewSql = @()

foreach ($key in $appData.Keys | Sort-Object) {
  $ad = $appData[$key]
  $appNumber = $ad.appNumber
  $finalStatus = $ad.finalStatus
  $path = $ad.path
  
  if ($finalStatus -notin @('ETHICAL_REVIEW', 'COMMITTEE_REVIEW', 'APPROVED', 'CLOSED', 'ARCHIVED', 'REJECTED', 'AWAITING_CONDITIONS', 'EVIDENCE_REJECTED')) {
    continue
  }
  
  $recommendation = switch ($finalStatus) {
    'REJECTED' { 'REJECTED' }
    'AWAITING_CONDITIONS' { 'CONDITIONAL' }
    default { 'APPROVED' }
  }
  
  $ethReviewSummary = 'Ethics review completed: informed consent adequate, risk-benefit favorable, privacy protections in place.'
  
  $ethReviewSql += @"
INSERT INTO committee.ethics_reviews (application_id, reviewer_id, review_status, recommendation, ethical_risk_assessment, summary, started_at, completed_at)
SELECT
  a.id,
  ra.reviewer_id,
  'COMPLETED',
  '$recommendation',
  'Risk level assessed as $((Get-Random -Minimum 1 -Maximum 3)). Adequate mitigation measures identified.',
  '$ethReviewSummary',
  (a.created_at + interval '7 days')::timestamptz,
  (a.created_at + interval '20 days')::timestamptz
FROM core.applications a
JOIN committee.review_assignments ra ON ra.application_id = a.id AND ra.review_type = 'ETHICAL'
WHERE a.application_number = '$appNumber'
LIMIT 1;

"@
}

$sql += $ethReviewSql -join ''

# =============================================================================
# APPLICATION CONDITIONS
# =============================================================================

$sql += @'

-- =============================================================================
-- APPLICATION CONDITIONS
-- =============================================================================

'@

$condSql = @()
$conditionIdx = 0

foreach ($key in $appData.Keys | Sort-Object) {
  $ad = $appData[$key]
  $appNumber = $ad.appNumber
  $finalStatus = $ad.finalStatus
  $path = $ad.path
  
  if ($finalStatus -notin @('AWAITING_CONDITIONS', 'EVIDENCE_REJECTED', 'CLOSED', 'APPROVED')) { continue }
  
  # Check if path goes through AWAITING_CONDITIONS
  $hasAwaiting = $false
  foreach ($trans in $path) {
    if ($trans.f -eq 10 -or $trans.t -eq 10) { $hasAwaiting = $true; break }
  }
  
  # Also add conditions for any app with conditional approval in path
  $hasConditional = $false
  foreach ($trans in $path) {
    if ($trans.tr -eq 18 -or $trans.tr -eq 19 -or $trans.tr -eq 22) { $hasConditional = $true; break }
  }
  
  if (-not $hasAwaiting -and -not $hasConditional) { continue }
  
  $conditionIdx++
  
  $conditionTexts = @(
    'Provide updated informed consent documents reflecting the revised protocol.',
    'Submit evidence of community engagement activities prior to study initiation.',
    'Provide certified translation of consent forms into Arabic.',
    'Submit detailed data protection and privacy plan.',
    'Provide proof of collaboration agreement with local health authorities.',
    'Appoint a qualified research nurse for participant monitoring.',
    'Submit amended protocol with clarified inclusion/exclusion criteria.',
    'Provide updated CVs for all coinvestigators.'
  )
  
  $categories = @('GENERAL', 'SCIENTIFIC', 'ETHICAL', 'ADMINISTRATIVE')
  $severities = @('MINOR', 'MAJOR')
  
  # 2-3 conditions per application
  $numConditions = Get-Random -Minimum 2 -Maximum 4
  
  for ($ci = 0; $ci -lt $numConditions; $ci++) {
    $conditionIdx++
    $condText = $conditionTexts[$ci % $conditionTexts.Length] -replace "'", "''"
    $category = $categories[$ci % $categories.Length]
    $severity = $severities[$ci % $severities.Length]
    
    # Determine if condition is resolved
    $resolved = $false
    if ($finalStatus -eq 'CLOSED' -or $finalStatus -eq 'APPROVED') {
      $resolved = $true
    } elseif ($finalStatus -eq 'EVIDENCE_REJECTED') {
      $resolved = ($ci -eq 0)  # First condition resolved, others not
    }
    
    $condStatus = if ($resolved) { 'MET' } else { 'OPEN' }
    $resolvedByVal = if ($resolved) { '6' } else { 'NULL' }
    $resolvedAtVal = if ($resolved) { "(a.created_at + interval '45 days')::timestamptz" } else { 'NULL' }
    
    $condSql += @"
INSERT INTO committee.application_conditions (application_id, condition_text, severity, category, due_date, status, created_by, resolved_by, resolved_at)
SELECT a.id, '$condText', '$severity', '$category', (a.created_at + interval '60 days')::timestamptz, '$condStatus', 1, $resolvedByVal, $resolvedAtVal
FROM core.applications a WHERE a.application_number = '$appNumber';

"@
  }
}

$sql += $condSql -join ''

# =============================================================================
# APPLICATION AMENDMENTS
# =============================================================================
# Create amendment records for AMENDMENT-type applications
# =============================================================================

$sql += @'

-- =============================================================================
-- APPLICATION AMENDMENTS
-- =============================================================================
-- Create amendment records linking amendment applications to their parent
-- =============================================================================

'@

$amendmentSql = @()
$parentIdx = 0

foreach ($amendment in $amendments) {
  $parentIdx++
  $parentPid = $amendment.pid
  
  # Find the parent application number (first app for this project)
  $parentApp = $null
  foreach ($key in $appData.Keys | Sort-Object) {
    $ad = $appData[$key]
    if ($ad.pid -eq $parentPid -and -not $ad.isAmendment) {
      $parentApp = $ad
      break
    }
  }
  
  # Find the amendment application for this project
  $amendmentApp = $null
  foreach ($key in $appData.Keys | Sort-Object) {
    $ad = $appData[$key]
    if ($ad.pid -eq $parentPid -and $ad.isAmendment) {
      $amendmentApp = $ad
      break
    }
  }
  
  if ($parentApp -and $amendmentApp) {
    $amendmentReasons = @(
      'Protocol amendment: addition of new study site',
      'Protocol amendment: revised inclusion criteria',
      'Protocol amendment: extended study duration',
      'Protocol amendment: added new biological sample collection',
      'Protocol amendment: revised data collection instruments',
      'Protocol amendment: added genetic analysis component',
      'Protocol amendment: modification of recruitment strategy'
    )
    $reason = $amendmentReasons[($parentIdx - 1) % $amendmentReasons.Length] -replace "'", "''"
    
    $amendmentNumber = "AMD-$($amendmentApp.appNumber.Substring(4))"
    $amendmentDesc = "Amendment to $($parentApp.appNumber): $reason" -replace "'", "''"
    $amendmentSql += @"
INSERT INTO core.application_amendments (application_id, amendment_number, amendment_reason, amendment_description, submitted_by, submitted_at, status_code)
SELECT a.id, '$amendmentNumber', '$reason', '$amendmentDesc', $($amendmentApp.piId), a.created_at, '$($amendmentApp.finalStatus)'
FROM core.applications a WHERE a.application_number = '$($amendmentApp.appNumber)';

"@
  }
}

$sql += $amendmentSql -join ''

# =============================================================================
# UPDATE SEQUENCES
# =============================================================================

$sql += @'

-- =============================================================================
-- UPDATE SEQUENCES TO MATCH INSERTED DATA
-- =============================================================================

SELECT setval('committee.committees_id_seq', (SELECT MAX(id) FROM committee.committees), true);
SELECT setval('committee.committee_members_id_seq', (SELECT MAX(id) FROM committee.committee_members), true);
SELECT setval('core.applications_id_seq', (SELECT MAX(id) FROM core.applications), true);
SELECT setval('core.application_history_id_seq', (SELECT MAX(id) FROM core.application_history), true);
SELECT setval('workflow.workflow_instances_id_seq', (SELECT MAX(id) FROM workflow.workflow_instances), true);
SELECT setval('workflow.workflow_actions_id_seq', (SELECT MAX(id) FROM workflow.workflow_actions), true);
SELECT setval('committee.review_assignments_id_seq', (SELECT MAX(id) FROM committee.review_assignments), true);
SELECT setval('committee.scientific_reviews_id_seq', (SELECT MAX(id) FROM committee.scientific_reviews), true);
SELECT setval('committee.ethics_reviews_id_seq', (SELECT MAX(id) FROM committee.ethics_reviews), true);
SELECT setval('committee.application_conditions_id_seq', (SELECT MAX(id) FROM committee.application_conditions), true);
SELECT setval('core.application_amendments_id_seq', (SELECT MAX(id) FROM core.application_amendments), true);

COMMIT;

'@

# =============================================================================
# WRITE OUTPUT
# =============================================================================
$sql | Out-File -FilePath $outputFile -Encoding utf8
Write-Host "Generated: $outputFile ($(($sql | Measure-Object -Line).Lines) lines)"
Write-Host "Applications: $appIdx (93 primary + 7 amendments)"
Write-Host "Workflow instances: $workflowIdx"
Write-Host "History entries: $historyIdx"
Write-Host "Workflow actions: $actionIdx"

# =============================================================================
# VERIFICATION
# =============================================================================
Write-Host "`nData Distribution:"
Write-Host "-----------------"
$statusCounts = @{}
foreach ($key in $appData.Keys) {
  $st = $appData[$key].finalStatus
  $statusCounts[$st] = ($statusCounts[$st] ?? 0) + 1
}
foreach ($st in $statusCounts.Keys | Sort-Object) {
  Write-Host ("{0,-25} {1,3}" -f $st, $statusCounts[$st])
}
