<#
.SYNOPSIS
  Restores the development database to the verified Gate 0 baseline.

.DESCRIPTION
  After integration testing the local database accumulates test data
  (test documents, generated PDFs, workflow instances, form instances,
  audit rows, mutated reference rows).

  This script deterministically restores the development database to the
  verified Gate 0 baseline snapshot:

    1. Restores the verified baseline dump
       (backend/backups/gate0-baseline-*.dump) via scripts/backup.ps1
       Restore (creates a pre-restore safety backup, then atomically
       swaps the database).
    2. Applies any NEW seed files added since the baseline was captured
       (apply-seeds.ps1 WITHOUT -Force - the baseline's seed tracker
       marks every historical seed as applied, so the legacy seed suite
       is never replayed).
    3. Removes generated PDF files under backend/uploads/generated-documents.
    4. Prints a verification summary.

  NOTE: The historical seed suite (backend/seed/*.sql) is NOT fully
  re-runnable end-to-end (see AGENTS.md "Seed suite re-run limitation").
  That is why this script restores a snapshot instead of replaying seeds.

  DESTRUCTIVE: run only against a development database. Stop the backend
  server first (open connections block the database swap).

.PARAMETER BaselineDump
  Path to the verified Gate 0 baseline dump.
  Default: backend/backups/gate0-baseline-2026-08-04.dump
.PARAMETER DbHost
  Database host. Default: localhost
.PARAMETER Port
  Database port. Default: 5432
.PARAMETER Database
  Database name. Default: ethics_db
.PARAMETER Username
  Database user (superuser, e.g. postgres). Default: postgres
.PARAMETER Password
  Database password (prompted if not provided).
.PARAMETER NoCleanGeneratedFiles
  Do not delete generated PDF files under backend/uploads/generated-documents.
.PARAMETER DryRun
  Show what would be executed without running anything.

.EXAMPLE
  .\reset-dev-db.ps1 -Password 'postgres'
#>

param(
  [string]$BaselineDump = (Resolve-Path "$PSScriptRoot/../backend/backups/gate0-baseline-2026-08-04.dump"),
  [string]$DbHost = 'localhost',
  [int]$Port = 5432,
  [string]$Database = 'ethics_db',
  [string]$Username = 'postgres',
  [string]$Password = '',
  [switch]$NoCleanGeneratedFiles,
  [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$ScriptDir = $PSScriptRoot

if (-not $Password) {
  $Password = Read-Host -Prompt "PostgreSQL password for $Username@$DbHost" -AsSecureString
  $Bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
  $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Bstr)
}

# ── Step 1: validate baseline and restore it ──────────────────────────────
if (-not (Test-Path $BaselineDump)) {
  throw "Baseline dump not found: $BaselineDump`nCapture one with: scripts/backup.ps1 -Action Backup -Name gate0-baseline-<date>.dump"
}
$DumpDir = Split-Path $BaselineDump
$DumpName = Split-Path $BaselineDump -Leaf

Write-Host "`n==> Step 1/3: Restore verified Gate 0 baseline ($DumpName)" -ForegroundColor Cyan
$backupScript = Join-Path $ScriptDir "backup.ps1"
if (-not (Test-Path $backupScript)) { throw "Missing $backupScript" }

if ($DryRun) {
  Write-Host "  [DRY-RUN] $backupScript -Action Restore -Name $DumpName -BackupDir $DumpDir -Database $Database -Username $Username" -ForegroundColor DarkYellow
} else {
  & $backupScript -Action Restore -Name $DumpName -BackupDir $DumpDir -Database $Database -Username $Username -Password $Password | Select-Object -Last 3
  if ($LASTEXITCODE -ne 0) { throw "Baseline restore failed (exit $LASTEXITCODE)" }
}

# ── Step 2: apply seeds added since the baseline was captured ─────────────
Write-Host "`n==> Step 2/3: Apply seeds added since baseline (apply-seeds.ps1, no -Force)" -ForegroundColor Cyan
$applySeeds = Join-Path $ScriptDir "apply-seeds.ps1"
if (Test-Path $applySeeds) {
  if ($DryRun) {
    Write-Host "  [DRY-RUN] $applySeeds -Password <given>" -ForegroundColor DarkYellow
  } else {
    & $applySeeds -Password $Password -DbHost $DbHost -Port $Port -Database $Database -Username $Username
    if ($LASTEXITCODE -ne 0) { throw "apply-seeds failed (exit $LASTEXITCODE)" }
  }
}

# ── Step 3: clean generated PDF files ─────────────────────────────────────
if (-not $NoCleanGeneratedFiles) {
  Write-Host "`n==> Step 3/3: Remove generated PDF files" -ForegroundColor Cyan
  $genDir = Join-Path (Resolve-Path "$ScriptDir/..") "backend/uploads/generated-documents"
  if (Test-Path $genDir) {
    $files = Get-ChildItem -Path $genDir -Filter "*.pdf" -ErrorAction SilentlyContinue
    if ($files) {
      Write-Host "  Removing $($files.Count) generated PDF file(s)" -ForegroundColor DarkCyan
      if (-not $DryRun) { $files | Remove-Item -Force }
    } else {
      Write-Host "  No generated PDF files to remove" -ForegroundColor Gray
    }
  }
}

# ── Verification ───────────────────────────────────────────────────────────
Write-Host "`n==> Verification" -ForegroundColor Cyan
if (-not $DryRun) {
  $env:PGPASSWORD = $Password
  $sql = @'
SELECT 'users' AS item, COUNT(*)::text AS n FROM security.users
UNION ALL SELECT 'documents', COUNT(*)::text FROM documents.documents
UNION ALL SELECT 'document_types', COUNT(*)::text FROM documents.document_types
UNION ALL SELECT 'retention_rules', COUNT(*)::text FROM documents.document_retention_rules
UNION ALL SELECT 'lifecycle_states', COUNT(*)::text FROM documents.document_lifecycle_states
UNION ALL SELECT 'watermark_configs', COUNT(*)::text FROM documents.document_watermark_config
UNION ALL SELECT 'form_instances', COUNT(*)::text FROM forms.form_instances
UNION ALL SELECT 'verification_log', COUNT(*)::text FROM documents.document_verification_log;
'@
  $cmd = "psql -h $DbHost -p $Port -U $Username -d $Database -At -c `"$sql`" 2>&1"
  Invoke-Expression $cmd | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
}

Write-Host "`nDone." -ForegroundColor Green
