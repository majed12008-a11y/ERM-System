# Generate Commit 5 - Yemen Applications Document Portfolio
# Output: backend/seed/54-yemen-documents.sql

param(
  [string]$outputFile = "C:\ERM-System\backend\seed\54-yemen-documents.sql"
)

function Get-Psql {
  param([string]$q, [string]$db = "ethics_db", [string]$user = "postgres")
  $r = & psql -U $user -d $db -At -F "`t" -c $q 2>&1
  return ($r | Where-Object { $_ -and $_ -notmatch '^(WARNING|NOTICE)' })
}

#==============================================================================
# LOAD APPLICATION & COMMITTEE DATA FROM DATABASE
#==============================================================================

Write-Host "Loading application data from database..."
$appRows = Get-Psql -q @"
SELECT a.application_number, a.current_status, a.application_type,
       COALESCE(a.submitted_by, (SELECT principal_investigator_id FROM core.projects WHERE id = a.project_id), 1),
       COALESCE(p.title_en, p.title_ar),
       COALESCE(c.committee_code, 'SUREC_31')
FROM core.applications a
JOIN core.projects p ON p.id = a.project_id
LEFT JOIN committee.committees c ON c.id = a.target_committee_id
ORDER BY a.id
"@

Write-Host "  Found $($appRows.Count) applications"

$apps = @()
foreach ($row in $appRows) {
  $parts = $row -split "`t"
  $apps += @{
    appNumber = $parts[0]
    status = $parts[1]
    appType = $parts[2]
    piId = if ($parts[3] -and $parts[3] -ne '') { [int]$parts[3] } else { 1 }
    title = $parts[4]
    committeeCode = $parts[5]
  }
}

# Get committee members with REVIEWER role (role_id = 3)
$memberRows = Get-Psql -q @"
SELECT cm.user_id, c.committee_code
FROM committee.committee_members cm
JOIN committee.committees c ON c.id = cm.committee_id
WHERE cm.role_id = 3
"@

$commMembers = @{}
foreach ($row in $memberRows) {
  $parts = $row -split "`t"
  $uid = [int]$parts[0]
  $cc = $parts[1]
  if (-not $commMembers.ContainsKey($cc)) { $commMembers[$cc] = @() }
  $commMembers[$cc] += $uid
}

Write-Host "  Found committee members for $($commMembers.Keys.Count) committees"

#==============================================================================
# DOCUMENT GENERATION HELPERS
#==============================================================================

function Get-FileSize {
  param([string]$mimeType, [int]$seed)
  $seed = [Math]::Abs($seed)
  if ($mimeType -eq 'application/pdf') { return 50000 + ($seed * 12345) % 5000000 }
  if ($mimeType -eq 'image/jpeg') { return 200000 + ($seed * 7890) % 1800000 }
  if ($mimeType -eq 'image/png') { return 150000 + ($seed * 4567) % 1000000 }
  if ($mimeType -eq 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') { return 30000 + ($seed * 1111) % 300000 }
  return 100000 + ($seed * 9999) % 2000000
}

function Get-Checksum {
  param([int]$seed, [int]$salt)
  $hex = '0123456789abcdef'
  $hash = ''
  $s = [Math]::Abs($seed * 31 + $salt * 17)
  for ($i = 0; $i -lt 64; $i++) {
    $hash += $hex[($s + $i * 13) -band 15]
  }
  return $hash
}

#==============================================================================
# DOCUMENT TEMPLATES PER WORKFLOW STATE
#==============================================================================

function Get-DocsForApp {
  param([hashtable]$app, [int]$idx)
  
  $status = $app.status
  $appNumber = $app.appNumber
  $title = $app.title -replace "'", "''"
  $seed = $idx * 7 + 42
  
  # Base document descriptors: each is [typeCode, titleAr, fileName, mimeType]
  $docs = @()
  
  switch ($status) {
    'DRAFT' {
      if (($idx + 1) % 3 -ne 0) { $docs += @('PROTOCOL', "بروتوكول البحث - $title (مسودة)", "protocol_draft_${appNumber}.pdf", 'application/pdf') }
      if ($idx % 2 -eq 0) { $docs += @('ICF', "نموذج الموافقة المستنيرة - $title (مسودة)", "icf_draft_${appNumber}.pdf", 'application/pdf') }
      if ($idx % 3 -ne 0) { $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf') }
    }
    
    'SUBMITTED' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "نموذج الموافقة المستنيرة - $title", "icf_ar_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $qType = if ($idx % 2 -eq 0) { 'QUESTIONNAIRE' } else { 'CRF' }
      $qTitle = if ($qType -eq 'QUESTIONNAIRE') { "استبيان - $title" } else { "نموذج تقرير الحالة - $title" }
      $docs += @($qType, $qTitle, "$($qType.ToLower())_${appNumber}.pdf", 'application/pdf')
    }
    
    'INITIAL_REVIEW' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "نموذج الموافقة المستنيرة - $title", "icf_ar_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $docs += @('STUDY_PROPOSAL', "مقترح الدراسة - $title", "proposal_${appNumber}.pdf", 'application/pdf')
      $docs += @('IRB_APPROVAL', "خطاب موافقة المؤسسة - $title", "irb_approval_${appNumber}.pdf", 'application/pdf')
    }
    
    'SCIENTIFIC_REVIEW' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "نموذج الموافقة المستنيرة (عربي) - $title", "icf_ar_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "Informed Consent Form (English) - $title", "icf_en_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - باحث مشارك", "cv_coi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $docs += @('STUDY_PROPOSAL', "مقترح الدراسة - $title", "proposal_${appNumber}.pdf", 'application/pdf')
      $docs += @('IRB_APPROVAL', "خطاب موافقة المؤسسة - $title", "irb_approval_${appNumber}.pdf", 'application/pdf')
      $docs += @('FUNDING', "وثيقة التمويل - $title", "funding_${appNumber}.pdf", 'application/pdf')
      $docs += @('BUDGET', "الميزانية - $title", "budget_${appNumber}.xlsx", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      $qType = if ($idx % 2 -eq 0) { 'QUESTIONNAIRE' } else { 'CRF' }
      $qTitle = if ($qType -eq 'QUESTIONNAIRE') { "استبيان - $title" } else { "نموذج تقرير الحالة - $title" }
      $docs += @($qType, $qTitle, "$($qType.ToLower())_${appNumber}.pdf", 'application/pdf')
      $docs += @('DATA_COLLECTION', "أداة جمع البيانات - $title", "data_collection_${appNumber}.xlsx", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    }
    
    'ETHICAL_REVIEW' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "نموذج الموافقة المستنيرة (عربي) - $title", "icf_ar_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "Informed Consent Form (English) - $title", "icf_en_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - باحث مشارك", "cv_coi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $docs += @('STUDY_PROPOSAL', "مقترح الدراسة - $title", "proposal_${appNumber}.pdf", 'application/pdf')
      $docs += @('IRB_APPROVAL', "خطاب موافقة المؤسسة - $title", "irb_approval_${appNumber}.pdf", 'application/pdf')
      $docs += @('FUNDING', "وثيقة التمويل - $title", "funding_${appNumber}.pdf", 'application/pdf')
      $docs += @('BUDGET', "الميزانية - $title", "budget_${appNumber}.xlsx", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      $docs += @('SOP', "الإجراءات التشغيلية القياسية - $title", "sop_${appNumber}.pdf", 'application/pdf')
      $qType = if ($idx % 2 -eq 0) { 'QUESTIONNAIRE' } else { 'CRF' }
      $qTitle = if ($qType -eq 'QUESTIONNAIRE') { "استبيان - $title" } else { "نموذج تقرير الحالة - $title" }
      $docs += @($qType, $qTitle, "$($qType.ToLower())_${appNumber}.pdf", 'application/pdf')
      $docs += @('DATA_COLLECTION', "أداة جمع البيانات - $title", "data_collection_${appNumber}.xlsx", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    }
    
    'COMMITTEE_REVIEW' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "نموذج الموافقة المستنيرة (عربي) - $title", "icf_ar_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "Informed Consent Form (English) - $title", "icf_en_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - باحث مشارك", "cv_coi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $docs += @('STUDY_PROPOSAL', "مقترح الدراسة - $title", "proposal_${appNumber}.pdf", 'application/pdf')
      $docs += @('IRB_APPROVAL', "خطاب موافقة المؤسسة - $title", "irb_approval_${appNumber}.pdf", 'application/pdf')
      $docs += @('FUNDING', "وثيقة التمويل - $title", "funding_${appNumber}.pdf", 'application/pdf')
      $docs += @('BUDGET', "الميزانية - $title", "budget_${appNumber}.xlsx", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      $docs += @('SOP', "الإجراءات التشغيلية القياسية - $title", "sop_${appNumber}.pdf", 'application/pdf')
      $docs += @('MEETING_MINUTES', "محضر اجتماع اللجنة - $title", "minutes_${appNumber}.pdf", 'application/pdf')
    }
    
    'APPROVED' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      if ($idx % 3 -eq 0) { $docs += @('PROTOCOL', "بروتوكول البحث - $title (النسخة المعدلة)", "protocol_v2_${appNumber}.pdf", 'application/pdf') }
      $docs += @('ICF', "نموذج الموافقة المستنيرة (عربي) - $title", "icf_ar_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "Informed Consent Form (English) - $title", "icf_en_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - باحث مشارك", "cv_coi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $docs += @('IRB_APPROVAL', "خطاب موافقة المؤسسة - $title", "irb_approval_${appNumber}.pdf", 'application/pdf')
      $docs += @('FUNDING', "وثيقة التمويل - $title", "funding_${appNumber}.pdf", 'application/pdf')
      $docs += @('BUDGET', "الميزانية - $title", "budget_${appNumber}.xlsx", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      $docs += @('ETHICS_DECISION', "قرار اللجنة - $title (موافقة)", "ethics_decision_${appNumber}.pdf", 'application/pdf')
      $docs += @('APPROVAL_CERTIFICATE', "شهادة الاعتماد - $title", "certificate_${appNumber}.pdf", 'application/pdf')
      $docs += @('DATA_COLLECTION', "أداة جمع البيانات - $title", "data_collection_${appNumber}.xlsx", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    }
    
    'CLOSED' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      if ($idx % 4 -eq 0) { $docs += @('PROTOCOL', "بروتوكول البحث - $title (النسخة المعدلة)", "protocol_v2_${appNumber}.pdf", 'application/pdf') }
      $docs += @('ICF', "نموذج الموافقة المستنيرة (عربي) - $title", "icf_ar_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "Informed Consent Form (English) - $title", "icf_en_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - باحث مشارك", "cv_coi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $docs += @('IRB_APPROVAL', "خطاب موافقة المؤسسة - $title", "irb_approval_${appNumber}.pdf", 'application/pdf')
      $docs += @('FUNDING', "وثيقة التمويل - $title", "funding_${appNumber}.pdf", 'application/pdf')
      $docs += @('BUDGET', "الميزانية - $title", "budget_${appNumber}.xlsx", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      $docs += @('ETHICS_DECISION', "قرار اللجنة - $title (موافقة)", "ethics_decision_${appNumber}.pdf", 'application/pdf')
      $docs += @('APPROVAL_CERTIFICATE', "شهادة الاعتماد - $title", "certificate_${appNumber}.pdf", 'application/pdf')
      $docs += @('FINAL_REPORT', "التقرير النهائي - $title", "final_report_${appNumber}.pdf", 'application/pdf')
      $docs += @('DATA_COLLECTION', "أداة جمع البيانات - $title", "data_collection_${appNumber}.xlsx", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      if ($idx % 2 -eq 0) { $docs += @('PUBLICATION', "منشور علمي - $title", "publication_${appNumber}.pdf", 'application/pdf') }
    }
    
    'ARCHIVED' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title (النسخة الأصلية)", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      $docs += @('PROTOCOL', "بروتوكول البحث - $title (النسخة النهائية)", "protocol_v2_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "نموذج الموافقة المستنيرة (عربي) - $title", "icf_ar_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "Informed Consent Form (English) - $title", "icf_en_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "نموذج الموافقة المستنيرة - $title (النسخة المعدلة)", "icf_v2_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - باحث مشارك", "cv_coi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $docs += @('STUDY_PROPOSAL', "مقترح الدراسة - $title", "proposal_${appNumber}.pdf", 'application/pdf')
      $docs += @('IRB_APPROVAL', "خطاب موافقة المؤسسة - $title", "irb_approval_${appNumber}.pdf", 'application/pdf')
      $docs += @('FUNDING', "وثيقة التمويل - $title", "funding_${appNumber}.pdf", 'application/pdf')
      $docs += @('BUDGET', "الميزانية - $title", "budget_${appNumber}.xlsx", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      $docs += @('ETHICS_DECISION', "قرار اللجنة - $title (موافقة)", "ethics_decision_${appNumber}.pdf", 'application/pdf')
      $docs += @('MEETING_MINUTES', "محضر اجتماع اللجنة - $title", "minutes_${appNumber}.pdf", 'application/pdf')
      $docs += @('APPROVAL_CERTIFICATE', "شهادة الاعتماد - $title", "certificate_${appNumber}.pdf", 'application/pdf')
      $docs += @('FINAL_REPORT', "التقرير النهائي - $title", "final_report_${appNumber}.pdf", 'application/pdf')
      $docs += @('DATA_COLLECTION', "أداة جمع البيانات - $title", "data_collection_${appNumber}.xlsx", 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      $docs += @('PUBLICATION', "منشور علمي - $title", "publication_${appNumber}.pdf", 'application/pdf')
    }
    
    'REJECTED' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "نموذج الموافقة المستنيرة - $title", "icf_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $docs += @('ETHICS_DECISION', "قرار اللجنة - $title (رفض)", "rejection_${appNumber}.pdf", 'application/pdf')
    }
    
    'WITHDRAWN' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "نموذج الموافقة المستنيرة - $title", "icf_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $docs += @('STUDY_PROPOSAL', "مقترح الدراسة - $title", "proposal_${appNumber}.pdf", 'application/pdf')
      $docs += @('OTHER', "خطاب سحب الطلب - $title", "withdrawal_${appNumber}.pdf", 'application/pdf')
    }
    
    'AWAITING_CONDITIONS' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "نموذج الموافقة المستنيرة (عربي) - $title", "icf_ar_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "Informed Consent Form (English) - $title", "icf_en_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $docs += @('IRB_APPROVAL', "خطاب موافقة المؤسسة - $title", "irb_approval_${appNumber}.pdf", 'application/pdf')
      $docs += @('ETHICS_DECISION', "قرار اللجنة - $title (موافقة مشروطة)", "conditional_approval_${appNumber}.pdf", 'application/pdf')
      $docs += @('EVIDENCE_DOC', "إثبات استيفاء الشروط - $title", "evidence_${appNumber}.pdf", 'application/pdf')
    }
    
    'EVIDENCE_REJECTED' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "نموذج الموافقة المستنيرة (عربي) - $title", "icf_ar_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "Informed Consent Form (English) - $title", "icf_en_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $docs += @('IRB_APPROVAL', "خطاب موافقة المؤسسة - $title", "irb_approval_${appNumber}.pdf", 'application/pdf')
      $docs += @('ETHICS_DECISION', "قرار اللجنة - $title (موافقة مشروطة)", "conditional_approval_${appNumber}.pdf", 'application/pdf')
      $docs += @('EVIDENCE_DOC', "إثبات استيفاء الشروط - $title (مرفوض)", "evidence_rejected_${appNumber}.pdf", 'application/pdf')
    }
    
    'RETURNED' {
      $docs += @('PROTOCOL', "بروتوكول البحث - $title", "protocol_v1_${appNumber}.pdf", 'application/pdf')
      $docs += @('ICF', "نموذج الموافقة المستنيرة - $title", "icf_${appNumber}.pdf", 'application/pdf')
      $docs += @('CV', "السيرة الذاتية - الباحث الرئيسي", "cv_pi_${appNumber}.pdf", 'application/pdf')
      $docs += @('PIS', "نشرة معلومات المشارك - $title", "pis_${appNumber}.pdf", 'application/pdf')
      $docs += @('ETHICS_DECISION', "قرار اللجنة - $title (إعادة للمراجعة)", "return_${appNumber}.pdf", 'application/pdf')
    }
  }
  
  # Add amendment package for amendment-type apps
  if ($app.appType -eq 'AMENDMENT' -and $status -in @('APPROVED','CLOSED','SUBMITTED','COMMITTEE_REVIEW','SCIENTIFIC_REVIEW','ETHICAL_REVIEW')) {
    $docs += @('AMENDMENT_PKG', "حزمة التعديل - $title", "amendment_${appNumber}.pdf", 'application/pdf')
    $docs += @('PROTOCOL', "بروتوكول البحث المعدل - $title", "protocol_amendment_${appNumber}.pdf", 'application/pdf')
  }
  
  return $docs
}

#==============================================================================
# SQL GENERATION
#==============================================================================

$sql = @"
-- =============================================================================
-- Commit 5: Yemen Applications — Document Portfolio
-- Populates documents for all 100 applications from Commit 4
-- =============================================================================

BEGIN;
SELECT set_config('app.user_id', '1', true);

"@

# 1. New document types
$sql += @"
-- =============================================================================
-- 1. NEW DOCUMENT TYPES
-- =============================================================================

"@

$newTypes = @(
  @('PIS', 'معلومات المشارك', 'Participant Information Sheet'),
  @('BUDGET', 'وثيقة الميزانية', 'Budget Document'),
  @('CRF', 'نموذج تقرير الحالة', 'Case Report Form'),
  @('SOP', 'الإجراءات التشغيلية القياسية', 'Standard Operating Procedure'),
  @('ETHICS_DECISION', 'قرار اللجنة الأخلاقية', 'Ethics Committee Decision'),
  @('MEETING_MINUTES', 'محضر اجتماع اللجنة', 'Committee Meeting Minutes'),
  @('AMENDMENT_PKG', 'حزمة التعديل', 'Amendment Package'),
  @('FINAL_REPORT', 'التقرير النهائي', 'Final Report'),
  @('PUBLICATION', 'منشور علمي', 'Publication'),
  @('DATA_COLLECTION', 'أداة جمع البيانات', 'Data Collection Tool'),
  @('STUDY_PROPOSAL', 'مقترح الدراسة', 'Study Proposal')
)

foreach ($nt in $newTypes) {
$sql += @"
INSERT INTO documents.document_types (type_code, type_name_ar, type_name_en, is_required)
SELECT '$($nt[0])', '$($nt[1])', '$($nt[2])', false
WHERE NOT EXISTS (SELECT 1 FROM documents.document_types WHERE type_code = '$($nt[0])');

"@
}

# 2. Documents per application
$sql += @"
-- =============================================================================
-- 2. DOCUMENTS PER APPLICATION
-- =============================================================================

"@

$docCount = 0
foreach ($app in $apps) {
  $idx = [array]::IndexOf($apps, $app)
  $docs = Get-DocsForApp -app $app -idx $idx
  if ($docs.Count -eq 0) { continue }
  
  $piId = $app.piId
  # Process docs in groups of 4 (typeCode, title, fileName, mimeType)
  for ($di = 0; $di -lt $docs.Count; $di += 4) {
    $tc = $docs[$di]; $tt = $docs[$di+1]; $fn = $docs[$di+2]; $mt = $docs[$di+3]
    $fs = Get-FileSize -mimeType $mt -seed ($idx * 3 + $di)
    $cs = Get-Checksum -seed ($idx * 3 + $di) -salt 7
    $sp = "uploads/documents/$fn"
    $uploadOffset = $di * 2 + 1
    
$sql += @"
INSERT INTO documents.documents (document_type_id, entity_type, entity_id, document_title, file_name, original_file_name, mime_type, file_size_bytes, storage_path, checksum_sha256, uploaded_by, uploaded_at, is_active)
SELECT dt.id, 'Application', a.id, '$tt', '$fn', '$fn', '$mt', $fs, '$sp', '$cs', $piId, a.created_at + interval '$uploadOffset hours', true
FROM documents.document_types dt
CROSS JOIN core.applications a
WHERE dt.type_code = '$tc'
AND a.application_number = '$($app.appNumber)';

"@
    $docCount++
  }
}

# 3. Document versions
$sql += @"
-- =============================================================================
-- 3. DOCUMENT VERSIONS
-- =============================================================================

"@

$versionCount = 0
foreach ($app in $apps) {
  $idx = [array]::IndexOf($apps, $app)
  $st = $app.status
  $an = $app.appNumber
  
  $addVer = ($st -eq 'ARCHIVED') -or ($st -eq 'APPROVED' -and $idx % 3 -eq 0) -or ($st -eq 'CLOSED' -and $idx % 4 -eq 0)
  if (-not $addVer) { continue }
  
  $verNotes = 'Original version'
  $fileNameLike = '%v1%'
  
  if ($st -eq 'ARCHIVED') {
    $verNotes = 'Original submitted version'
$sql += @"
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', '$verNotes'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = '$an'
AND d.file_name LIKE '%v1%';

"@
    $versionCount++
  } else {
$sql += @"
INSERT INTO documents.document_versions (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, uploaded_at, version_notes)
SELECT d.id, 1, d.file_name, d.storage_path, d.checksum_sha256, d.uploaded_by, a.created_at + interval '1 day', '$verNotes'
FROM documents.documents d
JOIN documents.document_types dt ON dt.id = d.document_type_id
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE dt.type_code = 'PROTOCOL' AND a.application_number = '$an'
AND d.file_name LIKE '%v1%'
LIMIT 1;

"@
    $versionCount++
  }
}

# 4. Approval certificates
$sql += @"
-- =============================================================================
-- 4. APPROVAL CERTIFICATES
-- =============================================================================

"@

$certCount = 0
foreach ($app in $apps) {
  if ($app.status -notin @('APPROVED','CLOSED','ARCHIVED')) { continue }
  $certCount++
  $idx = [array]::IndexOf($apps, $app)
  $serialNumber = "ERC-$(2024 + ($idx % 2))-$("{0:D5}" -f $idx)"

$sql += @"
INSERT INTO documents.approval_certificates (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, issued_at)
SELECT a.id, '$serialNumber', 1, 'ISSUED', a.submitted_by, 1, a.created_at + interval '$($idx + 15) days'
FROM core.applications a WHERE a.application_number = '$($app.appNumber)';

"@
}

# 5. Document access grants
$sql += @"
-- =============================================================================
-- 5. DOCUMENT ACCESS — REVIEWER GRANTS
-- =============================================================================

"@

$accessCount = 0
foreach ($app in $apps) {
  $cc = $app.committeeCode
  $reviewers = $commMembers[$cc]
  if (-not $reviewers) { continue }
  
  foreach ($rv in $reviewers) {
    $accessCount++
$sql += @"
INSERT INTO documents.document_access (document_id, user_id, access_type, granted_by, granted_at)
SELECT d.id, $rv, 'VIEW', 1, a.created_at + interval '3 days'
FROM documents.documents d
JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
WHERE a.application_number = '$($app.appNumber)'
  AND d.is_active = true
  AND NOT EXISTS (SELECT 1 FROM documents.document_access da WHERE da.document_id = d.id AND da.user_id = $rv);

"@
  }
}

# 6. Reset sequences
$sql += @"
-- =============================================================================
-- 6. RESET SEQUENCES
-- =============================================================================

SELECT setval('documents.documents_id_seq', COALESCE((SELECT MAX(id) FROM documents.documents), 0) + 1, false);
SELECT setval('documents.document_types_id_seq', COALESCE((SELECT MAX(id) FROM documents.document_types), 0) + 1, false);
SELECT setval('documents.document_versions_id_seq', COALESCE((SELECT MAX(id) FROM documents.document_versions), 0) + 1, false);
SELECT setval('documents.document_access_id_seq', COALESCE((SELECT MAX(id) FROM documents.document_access), 0) + 1, false);
SELECT setval('documents.approval_certificates_id_seq', COALESCE((SELECT MAX(id) FROM documents.approval_certificates), 0) + 1, false);

COMMIT;
"@

# Write output
$sql | Set-Content -Path $outputFile -Encoding UTF8

# Summary
Write-Host ""
Write-Host "Generated: $outputFile ($($sql.Length) characters)"
Write-Host "Document records: $docCount"
Write-Host "Version records: $versionCount"
Write-Host "Certificate records: $certCount"
Write-Host "Access grant records: $accessCount"
Write-Host ""

Write-Host "Document Distribution:"
$dist = @{}
$categories = @{}
foreach ($app in $apps) {
  $s = $app.status
  if (-not $dist.ContainsKey($s)) { $dist[$s] = 0 }
  $dist[$s]++
}
foreach ($s in ($dist.Keys | Sort-Object)) {
  Write-Host "  $s : $($dist[$s])"
}
Write-Host ""
Write-Host "Average documents per application: $([Math]::Round($docCount / 100, 1))"
