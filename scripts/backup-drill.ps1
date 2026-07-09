<#
.SYNOPSIS
  Executes a full backup/restore/verify drill and reports results.
.DESCRIPTION
  Tests the complete backup and restore pipeline:
  1. Create a backup via API
  2. Verify the backup via API
  3. Measure end-to-end duration
  4. Report pass/fail status with metrics
.PARAMETER Base
  API base URL. Default: http://localhost:8080/api/v1
.PARAMETER Token
  Admin JWT token. If not provided, logs in with admin credentials.
.PARAMETER AdminUser
  Admin username for login. Default: admin
.PARAMETER AdminPass
  Admin password for login. DEFAULT: Admin@2026
.PARAMETER ReportFile
  Path to write drill report. Default: drill-report-<timestamp>.json
.PARAMETER SkipVerify
  Skip the verify step (create + delete only).
.PARAMETER SkipCleanup
  Keep the drill backup file after test.
.EXAMPLE
  .\backup-drill.ps1 -Base 'http://localhost:8080/api/v1' -Token 'eyJ...'
  .\backup-drill.ps1 -AdminPass 'admin123'
#>

param(
  [string]$Base = 'http://localhost:8080/api/v1',
  [string]$Token = '',
  [string]$AdminUser = 'admin',
  [string]$AdminPass = '',
  [string]$ReportFile = '',
  [switch]$SkipVerify,
  [switch]$SkipCleanup
)

$ErrorActionPreference = 'Stop'
$timestamp = Get-Date -Format 'yyyy-MM-ddTHH-mm-ss'
$reportFile = if ($ReportFile) { $ReportFile } else { "drill-report-$timestamp.json" }

# Auth
if (-not $Token) {
  if (-not $AdminPass) { $AdminPass = Read-Host -Prompt "Admin password for $AdminUser" -AsSecureString; $Bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($AdminPass); $AdminPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Bstr) }
  Write-Host "Logging in as $AdminUser..." -ForegroundColor Cyan
  $login = Invoke-RestMethod -Uri "$Base/security/auth/login" -Method Post -Body (@{ username = $AdminUser; password = $AdminPass } | ConvertTo-Json) -ContentType 'application/json' -ErrorAction Stop
  $Token = $login.data.accessToken
  if (-not $Token) { Write-Error "Login failed"; exit 1 }
  Write-Host "  Token acquired" -ForegroundColor Green
}

$headers = @{ Authorization = "Bearer $Token"; 'Content-Type' = 'application/json' }
$results = @{}
$allPassed = $true

# Step 1: Health check
Write-Host "`nStep 1: Pre-drill health check..." -ForegroundColor Cyan
try {
  $health = Invoke-RestMethod -Uri "$Base/monitoring/health" -Headers $headers -ErrorAction Stop
  $results.HealthPre = $health
  Write-Host "  Status: $($health.data.status)" -ForegroundColor Green
} catch {
  Write-Host "  FAILED: $_" -ForegroundColor Red
  $results.HealthPre = "FAILED: $_"
  $allPassed = $false
}

# Step 2: Create backup
Write-Host "`nStep 2: Creating drill backup..." -ForegroundColor Cyan
$createStart = Get-Date
try {
  $backup = Invoke-RestMethod -Uri "$Base/admin/backup" -Method Post -Headers $headers -Body (@{ label = "drill_$timestamp" } | ConvertTo-Json) -ErrorAction Stop
  $createDuration = [int](Get-Date).Subtract($createStart).TotalMilliseconds
  $backupName = $backup.data.name
  $backupSize = $backup.data.size
  $results.Create = @{ name = $backupName; size = $backupSize; duration_ms = $createDuration }
  Write-Host "  Created: $backupName ($([math]::Round($backupSize/1KB, 1)) KB, ${createDuration}ms)" -ForegroundColor Green
} catch {
  Write-Host "  FAILED: $_" -ForegroundColor Red
  $results.Create = "FAILED: $_"
  $allPassed = $false
}

# Step 3: List backups (verify backup appears)
Write-Host "`nStep 3: Listing backups..." -ForegroundColor Cyan
try {
  $list = Invoke-RestMethod -Uri "$Base/admin/backup" -Headers $headers -ErrorAction Stop
  $found = $list.data | Where-Object { $_.name -eq $backupName }
  if ($found) {
    Write-Host "  Backup confirmed in list" -ForegroundColor Green
    $results.List = "OK"
  } else {
    Write-Host "  Backup NOT found in list" -ForegroundColor Red
    $results.List = "NOT FOUND"
    $allPassed = $false
  }
} catch {
  Write-Host "  FAILED: $_" -ForegroundColor Red
  $results.List = "FAILED: $_"
  $allPassed = $false
}

# Step 4: Verify backup integrity
if (-not $SkipVerify -and $backupName) {
  Write-Host "`nStep 4: Verifying backup integrity..." -ForegroundColor Cyan
  $verifyStart = Get-Date
  try {
    $verify = Invoke-RestMethod -Uri "$Base/admin/backup/$backupName/verify" -Method Post -Headers $headers -ErrorAction Stop
    $verifyDuration = [int](Get-Date).Subtract($verifyStart).TotalMilliseconds
    $entityCount = ($verify.data.entities | ForEach-Object { "$($_.entity)=$($_.row_count)" }) -join ', '
    $results.Verify = @{ duration_ms = $verifyDuration; entities = $verify.data.entities; duration_seconds = $verify.data.duration_seconds }
    Write-Host "  Verified (${verifyDuration}ms, restore ${verify.data.duration_seconds}s)" -ForegroundColor Green
    Write-Host "  Entities: $entityCount" -ForegroundColor DarkGray
    Write-Host "  Overall: $([math]::Round($verifyDuration/1000,1))s API + $($verify.data.duration_seconds)s restore vs 53.3s baseline" -ForegroundColor Gray

    $allRowsNonZero = ($verify.data.entities | Where-Object { $_.row_count -eq 0 }).Count -eq 0
    if (-not $allRowsNonZero) {
      Write-Host "  WARNING: Some entity counts are zero" -ForegroundColor Yellow
    }
  } catch {
    Write-Host "  FAILED: $_" -ForegroundColor Red
    $results.Verify = "FAILED: $_"
    $allPassed = $false
  }
} else {
  Write-Host "`nStep 4: Verify skipped" -ForegroundColor Gray
  $results.Verify = "SKIPPED"
}

# Step 5: Cleanup
if (-not $SkipCleanup -and $backupName) {
  Write-Host "`nStep 5: Cleaning up drill backup..." -ForegroundColor Cyan
  try {
    Invoke-RestMethod -Uri "$Base/admin/backup/$backupName" -Method Delete -Headers $headers -ErrorAction Stop | Out-Null
    Write-Host "  Deleted: $backupName" -ForegroundColor Green
    $results.Cleanup = "OK"
  } catch {
    Write-Host "  FAILED: $_" -ForegroundColor Red
    $results.Cleanup = "FAILED: $_"
  }
} else {
  Write-Host "`nStep 5: Cleanup skipped (backup kept: $backupName)" -ForegroundColor Gray
  $results.Cleanup = "SKIPPED"
}

# Post-drill health check
Write-Host "`nStep 6: Post-drill health check..." -ForegroundColor Cyan
try {
  $health = Invoke-RestMethod -Uri "$Base/monitoring/health" -Headers $headers -ErrorAction Stop
  $results.HealthPost = $health
  Write-Host "  Status: $($health.data.status)" -ForegroundColor Green
} catch {
  Write-Host "  FAILED: $_" -ForegroundColor Red
  $results.HealthPost = "FAILED: $_"
  $allPassed = $false
}

# Report
$report = @{
  timestamp = $timestamp
  base_url = $Base
  results = $results
  passed = $allPassed
  summary = if ($allPassed) { "ALL PASSED" } else { "SOME CHECKS FAILED" }
}
$report | ConvertTo-Json -Depth 10 | Out-File $reportFile -Encoding utf8
Write-Host "`nReport written to: $reportFile" -ForegroundColor Cyan

if ($allPassed) {
  Write-Host "`nDRILL RESULT: PASS ✅" -ForegroundColor Green
} else {
  Write-Host "`nDRILL RESULT: FAIL ❌" -ForegroundColor Red
  exit 1
}
