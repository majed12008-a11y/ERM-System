<#
.SYNOPSIS
  Reports the current state of seed file application.
.DESCRIPTION
  Queries the ops.seed_tracker table and compares against seed files on disk.
  Shows which seeds have been applied, which are pending, and which have changed.
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
.EXAMPLE
  .\seed-status.ps1 -Password 'postgres'
#>

param(
  [string]$SeedDir = (Resolve-Path "$PSScriptRoot/../backend/seed"),
  [string]$ConnString = '',
  [string]$DbHost = 'localhost',
  [int]$Port = 5432,
  [string]$Database = 'ethics_db',
  [string]$Username = 'postgres',
  [string]$Password = ''
)

$ErrorActionPreference = 'Stop'

if (-not $ConnString) {
  if (-not $Password) { $Password = Read-Host -Prompt "PostgreSQL password for $Username@$DbHost" -AsSecureString; $Bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password); $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Bstr) }
  $env:PGPASSWORD = $Password
  $PsqlArgs = "-h $DbHost -p $Port -U $Username -d $Database -At"
} else {
  $PsqlArgs = "-d `"$ConnString`" -At"
}

function Get-Checksum([string]$Path) {
  $hash = Get-FileHash -Path $Path -Algorithm SHA256
  return $hash.Hash.ToLower()
}

# Check if tracker table exists
$result = Invoke-Expression "psql $PsqlArgs -c ""SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'ops' AND table_name = 'seed_tracker')"""
$hasTracker = $result -match 't'

if (-not $hasTracker) {
  Write-Host "No seed tracker found. Run 00-seed-tracker.sql first." -ForegroundColor Yellow
  Write-Host "Seeds on disk ($(Get-ChildItem $SeedDir -Filter *.sql | Measure-Object | % { $_.Count })):" -ForegroundColor Cyan
  Get-ChildItem $SeedDir -Filter *.sql | Sort-Object Name | ForEach-Object {
    Write-Host "  $($_.Name) (pending)" -ForegroundColor Gray
  }
  exit 0
}

# Get tracked seeds
$tracked = @{}
$result = Invoke-Expression "psql $PsqlArgs -c ""SELECT filename, checksum, applied_at, duration_ms, status FROM ops.seed_tracker ORDER BY filename"""
if ($result) {
  $result -split "`n" | ForEach-Object {
    $parts = $_ -split '\|'
    if ($parts.Count -ge 5) {
      $tracked[$parts[0].Trim()] = @{
        Checksum = $parts[1].Trim()
        AppliedAt = $parts[2].Trim()
        Duration = $parts[3].Trim()
        Status = $parts[4].Trim()
      }
    }
  }
}

$files = Get-ChildItem -Path $SeedDir -Filter "*.sql" | Sort-Object Name
Write-Host "Seed Status Report" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
Write-Host ""

$ok = 0; $changed = 0; $pending = 0; $failed = 0

foreach ($file in $files) {
  $name = $file.Name
  $checksum = Get-Checksum $file.FullName
  $size = "{0:N0}" -f $file.Length

  if ($tracked.ContainsKey($name)) {
    $t = $tracked[$name]
    if ($t.Status -eq 'failed') {
      Write-Host "  [FAIL] $name  (${size}B)" -ForegroundColor Red
      $failed++
    } elseif ($t.Checksum -ne $checksum) {
      Write-Host "  [CHG]  $name  (${size}B — applied $($t.AppliedAt), ${t.Duration}ms)" -ForegroundColor Yellow
      $changed++
    } else {
      Write-Host "  [OK]   $name  (${size}B — applied $($t.AppliedAt), ${t.Duration}ms)" -ForegroundColor Green
      $ok++
    }
  } else {
    Write-Host "  [NEW]  $name  (${size}B — never applied)" -ForegroundColor Gray
    $pending++
  }
}

Write-Host ""
Write-Host "Summary: $ok applied, $changed changed, $pending pending, $failed failed" -ForegroundColor Cyan

# Show tracker table statistics
$stats = Invoke-Expression "psql $PsqlArgs -c ""SELECT COUNT(*), MIN(applied_at), MAX(applied_at) FROM ops.seed_tracker WHERE status = 'success'"""
Write-Host "Tracker stats: $stats" -ForegroundColor DarkGray
