param(
  [ValidateSet('Backup','List','Restore','Verify','Delete')]
  [string]$Action = 'Backup',
  [string]$Name = '',
  [string]$Database = 'ethics_db',
  [string]$BackupDir = "$PSScriptRoot\..\backups",
  [string]$DbHost = 'localhost',
  [int]$Port = 5432,
  [string]$Username = 'postgres',
  [Parameter(Mandatory = $true)]
  [string]$Password
)

if (-not $env:PGPASSWORD -and -not $Password) {
  Write-Error "Password is required. Provide -Password parameter or set PGPASSWORD environment variable."
  exit 1
}

$env:PGPASSWORD = $Password
$pgDump = "pg_dump"
$pgRestore = "pg_restore"
$psql = "psql"

if (-not (Test-Path $BackupDir)) {
  New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
}

function Get-Timestamp { Get-Date -Format 'yyyyMMdd_HHmmss' }

function Get-BackupFiles {
  Get-ChildItem $BackupDir -Filter '*.dump' | Sort-Object LastWriteTime -Descending
}

function Write-BackupResult {
  param([string]$Status, [string]$Message, $Data = $null)
  $result = @{ status = $Status; message = $Message }
  if ($Data) { $result.data = $Data }
  return $result | ConvertTo-Json -Compress
}

switch ($Action) {
  'Backup' {
    if ([string]::IsNullOrWhiteSpace($Name)) {
      $Name = "ethics_db_$(Get-Timestamp).dump"
    }
    if (-not ($Name.EndsWith('.dump'))) { $Name += '.dump' }
    $filePath = Join-Path $BackupDir $Name
    $start = Get-Date
    Write-Output "Starting backup to $filePath ..."
    & $pgDump -h $DbHost -p $Port -U $Username -d $Database -Fc -f $filePath 2>&1
    if ($LASTEXITCODE -eq 0) {
      $elapsed = [math]::Round(((Get-Date) - $start).TotalSeconds, 1)
      $size = (Get-Item $filePath).Length
      Write-Output "Backup completed in ${elapsed}s, size: $([math]::Round($size/1MB,2)) MB"
      Write-BackupResult -Status 'success' -Message "Backup created: $Name" -Data @{
        name = $Name; size = $size; created_at = (Get-Date -Format 'o')
      }
    } else {
      Write-BackupResult -Status 'error' -Message "Backup failed with exit code $LASTEXITCODE"
    }
    break
  }

  'List' {
    $files = Get-BackupFiles | ForEach-Object {
      @{ name = $_.Name; size = $_.Length; created_at = $_.LastWriteTime.ToString('o') }
    }
    Write-BackupResult -Status 'success' -Message "Found $($files.Count) backup(s)" -Data $files
    break
  }

  'Restore' {
    if ([string]::IsNullOrWhiteSpace($Name)) {
      Write-BackupResult -Status 'error' -Message 'Backup name required for restore'
      break
    }
    $filePath = Join-Path $BackupDir $Name
    if (-not (Test-Path $filePath)) {
      Write-BackupResult -Status 'error' -Message "Backup file not found: $Name"
      break
    }

    $preName = "pre_restore_$(Get-Timestamp).dump"
    $prePath = Join-Path -LiteralPath $BackupDir -ChildPath $preName
    Write-Output "Creating pre-restore backup: $preName ..."
    & $pgDump -h $DbHost -p $Port -U $Username -d $Database -Fc -f $prePath 2>&1
    if ($LASTEXITCODE -ne 0) {
      Write-BackupResult -Status 'error' -Message 'Pre-restore backup failed, aborting restore'
      break
    }

    Write-Output "Restoring from $Name ..."
    $start = Get-Date

    & $psql -h $DbHost -p $Port -U $Username -d postgres -c "DROP DATABASE IF EXISTS ${Database}_old;" 2>&1
    & $psql -h $DbHost -p $Port -U $Username -d postgres -c "ALTER DATABASE $Database RENAME TO ${Database}_old;" 2>&1
    & $psql -h $DbHost -p $Port -U $Username -d postgres -c "CREATE DATABASE $Database OWNER ethics_app;" 2>&1

    & $pgRestore -h $DbHost -p $Port -U $Username -d $Database -Fc $filePath 2>$null
    if ($LASTEXITCODE -le 1) {
      & $psql -h $DbHost -p $Port -U $Username -d postgres -c "DROP DATABASE IF EXISTS ${Database}_old;" 2>&1
      $elapsed = [math]::Round(((Get-Date) - $start).TotalSeconds, 1)
      Write-Output "Restore completed in ${elapsed}s"
      Write-BackupResult -Status 'success' -Message "Restore completed in ${elapsed}s" -Data @{
        backup = $Name; pre_restore_backup = $preName; duration_seconds = $elapsed
      }
    } else {
      Write-Output "Restore failed, reverting..."
      & $psql -h $DbHost -p $Port -U $Username -d postgres -c "DROP DATABASE IF EXISTS $Database;" 2>&1
      & $psql -h $DbHost -p $Port -U $Username -d postgres -c "ALTER DATABASE ${Database}_old RENAME TO $Database;" 2>&1
      Write-BackupResult -Status 'error' -Message "Restore failed with exit code $LASTEXITCODE, reverted to original"
    }
    break
  }

  'Verify' {
    if ([string]::IsNullOrWhiteSpace($Name)) {
      Write-BackupResult -Status 'error' -Message 'Backup name required for verify'
      break
    }
    $filePath = Join-Path $BackupDir $Name
    if (-not (Test-Path $filePath)) {
      Write-BackupResult -Status 'error' -Message "Backup file not found: $Name"
      break
    }

    $verifyDb = "verify_restore_$(Get-Timestamp)"
    Write-Output "Verifying backup: restoring to temp database '$verifyDb' ..."

    & $psql -h $DbHost -p $Port -U $Username -d postgres -c "CREATE DATABASE $verifyDb OWNER ethics_app;" 2>&1
    $start = Get-Date
    & $pgRestore -h $DbHost -p $Port -U $Username -d $verifyDb -Fc $filePath 2>$null
    if ($LASTEXITCODE -ge 2) {
      & $psql -h $DbHost -p $Port -U $Username -d postgres -c "DROP DATABASE IF EXISTS $verifyDb;" 2>&1
      Write-BackupResult -Status 'error' -Message "Verify failed: pg_restore exit code $LASTEXITCODE"
      break
    }

    $queries = @(
      @{ label = 'Users'; sql = "SELECT COUNT(*) as count FROM security.users" }
      @{ label = 'Projects'; sql = "SELECT COUNT(*) as count FROM core.projects" }
      @{ label = 'Applications'; sql = "SELECT COUNT(*) as count FROM core.applications" }
      @{ label = 'Committees'; sql = "SELECT COUNT(*) as count FROM committee.committees" }
      @{ label = 'Audit Logs'; sql = "SELECT COUNT(*) as count FROM audit.audit_logs" }
    )
    $results = New-Object System.Collections.ArrayList
    foreach ($q in $queries) {
      $count = & $psql -h $DbHost -p $Port -U $Username -d $verifyDb -At -c $q.sql 2>$null
      $countVal = 0
      [int]::TryParse(($count -replace '[^0-9]',''), [ref]$countVal) | Out-Null
      $null = $results.Add([PSCustomObject]@{ entity = $q.label; row_count = $countVal })
    }

    & $psql -h $DbHost -p $Port -U $Username -d postgres -c "DROP DATABASE IF EXISTS $verifyDb;" 2>&1

    $elapsed = [math]::Round(((Get-Date) - $start).TotalSeconds, 1)
    Write-Output "Verification completed in ${elapsed}s"
    Write-BackupResult -Status 'success' -Message "Backup verified in ${elapsed}s" -Data @{
      backup = $Name; duration_seconds = $elapsed; entities = $results
    }
    break
  }

  'Delete' {
    if ([string]::IsNullOrWhiteSpace($Name)) {
      Write-BackupResult -Status 'error' -Message 'Backup name required for delete'
      break
    }
    $filePath = Join-Path $BackupDir $Name
    if (-not (Test-Path $filePath)) {
      Write-BackupResult -Status 'error' -Message "Backup file not found: $Name"
      break
    }
    Remove-Item $filePath -Force
    Write-BackupResult -Status 'success' -Message "Backup deleted: $Name"
    break
  }
}
