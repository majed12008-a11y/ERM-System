param(
  [string]$BackupDir = "$PSScriptRoot\..\backups",
  [switch]$SkipBackup,
  [switch]$Force,
  [string]$DbName = 'ethics_db',
  [string]$DbUser = 'postgres',
  [string]$ProjectDir = '.'
)

$ErrorActionPreference = 'Stop'
$exitCode = 0

function Write-Step($msg) { Write-Output "  $msg" }

function Write-Success($msg) { Write-Output "  $msg" }

function Write-Failure($msg) { Write-Output "  $msg" }

function Write-Warning($msg) { Write-Output "  $msg" }

function Get-Timestamp { Get-Date -Format 'yyyyMMdd_HHmmss' }

function Resolve-ProjectDir {
  $resolved = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
  if (-not (Test-Path (Join-Path $resolved 'docker-compose.yml'))) {
    throw "docker-compose.yml not found in '$resolved'. Use -ProjectDir to specify the project directory."
  }
  return $resolved
}

function Get-DockerComposePath {
  $resolved = Resolve-ProjectDir
  return (Join-Path $resolved 'docker-compose.yml')
}

function Get-ComposeDir {
  return Split-Path (Get-DockerComposePath) -Parent
}

function Test-DockerDaemon {
  try {
    $null = docker info 2>&1
    return $LASTEXITCODE -eq 0
  } catch {
    return $false
  }
}

function Get-ServiceStatus($service) {
  Push-Location (Get-ComposeDir)
  try {
    $output = docker compose ps --status all --format '{{.Name}}|{{.Status}}' 2>&1
    $match = $output | Where-Object { $_ -match "^$service\|" }
    if (-not $match) { return 'not_found' }
    $status = ($match -split '\|')[1]
    if ($status -match 'Up|running|healthy|starting') { return 'running' }
    if ($status -match 'Exited|stopped|paused') { return 'stopped' }
    return 'unknown'
  } finally {
    Pop-Location
  }
}

function Confirm-Action {
  param([string]$Message)
  if ($Force) { return $true }
  $response = Read-Host "$Message (y/N)"
  return $response -eq 'y' -or $response -eq 'Y'
}

function Invoke-Backup {
  $resolvedDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($BackupDir)
  if (-not (Test-Path $resolvedDir)) {
    New-Item -ItemType Directory -Path $resolvedDir -Force | Out-Null
    Write-Step "Created backup directory: $resolvedDir"
  }

  $timestamp = Get-Timestamp
  $backupFile = "ethics_db_pre_shutdown_$timestamp.dump"
  $backupPath = Join-Path $resolvedDir $backupFile
  $containerTmp = "/tmp/$backupFile"

  Write-Step "Creating pre-shutdown backup of '$DbName'..."

  Push-Location (Get-ComposeDir)
  try {
    $status = Get-ServiceStatus 'postgres'
    if ($status -ne 'running') {
      throw "PostgreSQL container is not running (status: $status). Backup cannot proceed."
    }

    $execResult = docker compose exec -T postgres pg_dump -U $DbUser -Fc -f $containerTmp $DbName 2>&1
    if ($LASTEXITCODE -ne 0) {
      throw "pg_dump failed (exit code: $LASTEXITCODE). Output: $execResult"
    }

    $cpResult = docker cp "postgres:$containerTmp" $backupPath 2>&1
    if ($LASTEXITCODE -ne 0) {
      throw "docker cp failed (exit code: $LASTEXITCODE). Output: $cpResult"
    }

    docker compose exec -T postgres rm -f $containerTmp 2>&1 | Out-Null

    if (Test-Path $backupPath) {
      $size = [math]::Round(((Get-Item $backupPath).Length / 1MB), 2)
      Write-Success "Backup completed: $backupFile ($size MB)"
    } else {
      throw "Backup file not found after copy."
    }
  } finally {
    Pop-Location
  }
}

function Stop-ServiceGracefully {
  param([string]$Service, [int]$Timeout)

  Write-Step "Stopping $Service..."
  Push-Location (Get-ComposeDir)
  try {
    $result = docker compose stop --timeout $Timeout $Service 2>&1
    if ($LASTEXITCODE -ne 0) {
      throw "Failed to stop $Service. Output: $result"
    }
    $status = Get-ServiceStatus $Service
    if ($status -eq 'stopped') {
      Write-Success "$Service stopped."
    } else {
      Write-Warning "$Service status after stop: $status"
    }
  } finally {
    Pop-Location
  }
}

function Confirm-Shutdown {
  param([string[]]$Services)

  Write-Step "Verifying shutdown..."
  $allStopped = $true
  foreach ($svc in $Services) {
    $status = Get-ServiceStatus $svc
    if ($status -eq 'stopped' -or $status -eq 'not_found') {
      Write-Success "  $($svc): $status"
    } else {
      Write-Warning "  $($svc): $status (expected: stopped)"
      $allStopped = $false
    }
  }
  return $allStopped
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

Write-Output "=== Ethics ERM Production Shutdown ==="
Write-Output "Started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Output ""

# 1. Validate prerequisites
Write-Step "Checking environment..."

if (-not (Test-DockerDaemon)) {
  Write-Error "Docker daemon is not running. Aborting."
  exit 1
}
Write-Success "Docker daemon: running"

$composeFile = Get-DockerComposePath
Write-Step "Using compose file: $composeFile"

if (-not $Force) {
  $confirmed = Confirm-Action -Message "This will stop all production services. Continue?"
  if (-not $confirmed) {
    Write-Output "Shutdown cancelled."
    exit 0
  }
}

# 2. Backup
if (-not $SkipBackup) {
  try {
    Invoke-Backup
  } catch {
    Write-Failure "BACKUP FAILED: $_"
    exit 1
  }
} else {
  Write-Warning "Backup skipped (-SkipBackup specified)."
}

# 3. Stop services
Write-Output ""

$services = @('frontend', 'backend', 'postgres')
$timeouts = @{ frontend = 30; backend = 60; postgres = 120 }

foreach ($svc in $services) {
  $status = Get-ServiceStatus $svc
  if ($status -eq 'not_found') {
    Write-Warning "Service '$svc' not found in compose configuration. Skipping."
    continue
  }
  if ($status -eq 'stopped') {
    Write-Warning "Service '$svc' is already stopped. Skipping."
    continue
  }
  try {
    Stop-ServiceGracefully -Service $svc -Timeout $timeouts[$svc]
  } catch {
    Write-Failure "SHUTDOWN FAILED: $_"
    $exitCode = 1
  }
}

# 4. Verify
Write-Output ""
$allStopped = Confirm-Shutdown -Services $services

# 5. Summary
Write-Output ""
if ($allStopped -and $exitCode -eq 0) {
  Write-Output "=== Shutdown completed successfully ==="
} else {
  Write-Output "=== Shutdown completed with warnings ==="
  Write-Output "Check service status above."
}
Write-Output "Finished: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

exit $exitCode
