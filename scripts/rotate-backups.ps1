param(
  [string]$BackupDir = "$PSScriptRoot\..\backups",
  [int]$DailyRetention = 7,
  [int]$WeeklyRetention = 4,
  [int]$MonthlyRetention = 3
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $BackupDir)) {
  Write-Error "Backup directory not found: $BackupDir"
  exit 1
}

$files = Get-ChildItem $BackupDir -Filter '*.dump' | Sort-Object LastWriteTime -Descending

# Group files
$daily    = @()
$weekly   = @()
$monthly  = @()
$toDelete = @()

foreach ($f in $files) {
  $age = [math]::Floor(((Get-Date) - $f.LastWriteTime).TotalDays)
  $isSunday = ($f.LastWriteTime.DayOfWeek -eq 'Sunday')
  $isFirstWeek = ($f.LastWriteTime.Day -le 7)
  $isMonthly = ($isSunday -and $isFirstWeek)

  if ($age -gt 28 -and $monthly.Count -lt $MonthlyRetention -and $isMonthly) {
    $monthly += $f
  } elseif ($age -gt 7 -and $weekly.Count -lt $WeeklyRetention -and $isSunday) {
    $weekly += $f
  } elseif ($age -le $DailyRetention) {
    $daily += $f
  } else {
    $toDelete += $f
  }
}

# Delete old files
if ($toDelete.Count -gt 0) {
  foreach ($f in $toDelete) {
    Remove-Item -Path $f.FullName -Force
    Write-Output "DELETED: $($f.Name) ($([math]::Round($f.Length/1MB,2)) MB)"
  }
} else {
  Write-Output "No files to delete."
}

$totalSize = (Get-ChildItem $BackupDir -Filter '*.dump' | Measure-Object Length -Sum).Sum
Write-Output "Retention applied. Kept: $($daily.Count) daily, $($weekly.Count) weekly, $($monthly.Count) monthly"
Write-Output "Total backup size: $([math]::Round($totalSize/1MB,2)) MB"
