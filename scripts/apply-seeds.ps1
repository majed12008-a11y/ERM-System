<#
.SYNOPSIS
  Applies seed files with idempotent tracking.
.DESCRIPTION
  Reads seed files from backend/seed/ in numeric order, computes SHA-256
  checksums, and applies only new or changed files. Records results in
  the ops.seed_tracker table (created by 00-seed-tracker.sql).
.PARAMETER SeedDir
  Path to seed files directory. Default: ../backend/seed
.PARAMETER ConnString
  PostgreSQL connection string (overrides individual params).
.PARAMETER DbHost
  Database host. Default: localhost
.PARAMETER Port
  Database port. Default: 5432
.PARAMETER Database
  Database name. Default: ethics_db
.PARAMETER Username
  Database user. Default: postgres
.PARAMETER Password
  Database password (prompted if not provided).
.PARAMETER Force
  Re-apply seeds even if already tracked (skips checksum check).
.PARAMETER DryRun
  Show what would be applied without executing.
.EXAMPLE
  .\apply-seeds.ps1 -Password 'postgres'
  .\apply-seeds.ps1 -ConnString "postgres://postgres:postgres@localhost:5432/ethics_db" -DryRun
#>

param(
  [string]$SeedDir = (Resolve-Path "$PSScriptRoot/../backend/seed"),
  [string]$ConnString = '',
  [string]$DbHost = 'localhost',
  [int]$Port = 5432,
  [string]$Database = 'ethics_db',
  [string]$Username = 'postgres',
  [string]$Password = '',
  [switch]$Force,
  [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

# Determine connection
if (-not $ConnString) {
  if (-not $Password) { $Password = Read-Host -Prompt "PostgreSQL password for $Username@$DbHost" -AsSecureString; $Bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password); $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Bstr) }
  $env:PGPASSWORD = $Password
  $PsqlArgs = "-h $DbHost -p $Port -U $Username -d $Database"
} else {
  $PsqlArgs = "-d `"$ConnString`""
}

function RunPsql([string]$Sql, [switch]$NoPassword) {
  if ($DryRun) { Write-Host "[DRY-RUN] Would execute: $Sql" -ForegroundColor DarkYellow; return @{ ExitCode = 0; Stdout = ''; Stderr = '' } }
  $cmd = "psql $PsqlArgs -At -v ON_ERROR_STOP=1 -c `"$Sql`" 2>&1"
  $result = Invoke-Expression $cmd
  $exitCode = $LASTEXITCODE
  return @{ ExitCode = $exitCode; Stdout = $result; Stderr = '' }
}

function RunPsqlFile([string]$FilePath) {
  if ($DryRun) { Write-Host "[DRY-RUN] Would execute file: $FilePath" -ForegroundColor DarkYellow; return @{ ExitCode = 0 } }
  $cmd = "psql $PsqlArgs -v ON_ERROR_STOP=1 -f `"$FilePath`" 2>&1"
  $result = Invoke-Expression $cmd
  $exitCode = $LASTEXITCODE
  return @{ ExitCode = $exitCode; Stdout = $result }
}

function Get-Checksum([string]$Path) {
  $hash = Get-FileHash -Path $Path -Algorithm SHA256
  return $hash.Hash.ToLower()
}

# Ensure seed tracker table exists first
$trackerPath = Join-Path $SeedDir "00-seed-tracker.sql"
if (Test-Path $trackerPath) {
  Write-Host "Ensuring seed tracker table exists..." -ForegroundColor Cyan
  $result = RunPsqlFile $trackerPath
  if ($result.ExitCode -ne 0) { Write-Error "Failed to create seed tracker table"; exit 1 }
}

# Get currently tracked seeds
$tracked = @{}
$result = RunPsql "SELECT filename, checksum FROM ops.seed_tracker WHERE status = 'success'"
if ($result.ExitCode -eq 0 -and $result.Stdout) {
  $result.Stdout -split "`n" | ForEach-Object {
    $parts = $_ -split '\|'
    if ($parts.Count -ge 2) { $tracked[$parts[0].Trim()] = $parts[1].Trim() }
  }
}

# Process seed files in order
$files = Get-ChildItem -Path $SeedDir -Filter "*.sql" | Sort-Object Name
$total = $files.Count
$applied = 0; $skipped = 0; $failed = 0

Write-Host "Processing $total seed files..." -ForegroundColor Cyan

foreach ($file in $files) {
  $checksum = Get-Checksum $file.FullName
  $name = $file.Name

  if ($tracked.ContainsKey($name)) {
    if ($tracked[$name] -eq $checksum -and -not $Force) {
      Write-Host "  [SKIP] $name (unchanged)" -ForegroundColor Gray
      $skipped++
      continue
    } elseif ($tracked[$name] -ne $checksum) {
      Write-Host "  [CHANGED] $name (checksum mismatch)" -ForegroundColor Yellow
      if (-not $Force) {
        Write-Host "    Pass -Force to re-apply, or review manually." -ForegroundColor Yellow
        $skipped++
        continue
      }
    }
  }

  Write-Host "  [APPLY] $name ..." -ForegroundColor Green -NoNewline
  $start = Get-Date
  $result = RunPsqlFile $file.FullName
  $duration = [int](Get-Date).Subtract($start).TotalMilliseconds

  if ($result.ExitCode -eq 0) {
    Write-Host " OK (${duration}ms)" -ForegroundColor Green
    RunPsql "INSERT INTO ops.seed_tracker (filename, checksum, duration_ms, status)
             VALUES ('$name', '$checksum', $duration, 'success')
             ON CONFLICT (filename) DO UPDATE SET checksum = '$checksum', applied_at = NOW(), duration_ms = $duration, status = 'success', error = NULL" | Out-Null
    $applied++
  } else {
    Write-Host " FAILED (exit $($result.ExitCode))" -ForegroundColor Red
    $errorMsg = ($result.Stdout -replace "'", "''").Substring(0, [Math]::Min(2000, ($result.Stdout -replace "'", "''").Length))
    RunPsql "INSERT INTO ops.seed_tracker (filename, checksum, duration_ms, status, error)
             VALUES ('$name', '$checksum', $duration, 'failed', '$errorMsg')
             ON CONFLICT (filename) DO UPDATE SET checksum = '$checksum', applied_at = NOW(), duration_ms = $duration, status = 'failed', error = '$errorMsg'" | Out-Null
    $failed++
  }
}

Write-Host "`nSummary: $applied applied, $skipped skipped, $failed failed (of $total)" -ForegroundColor Cyan
if ($failed -gt 0) { exit 1 }
