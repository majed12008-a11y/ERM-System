# canonical/extract-canonical.ps1
# Reads pg_dump output and generates canonical directory with organized SQL files

$dumpFile = "C:\ERM-System\backup_schema_dump.sql"
$canonical = "C:\ERM-System\database\canonical"
$dump = Get-Content $dumpFile -Raw

# Split the dump into sections based on comment headers
# Each section starts with "--\n-- Name:" — split on this boundary
$sections = $dump -split '(?<=\n--\r?\n)(?=-- Name:)'

# Track counts
$counts = @{}

# Process sections
$currentType = ""
$currentSchema = ""
$currentName = ""

# Buffer for multi-statement types (tables with constraints, etc.)
$typeBuffers = @{}

function Add-ToBuffer($type, $schema, $content) {
    $key = "$type|$schema"
    if (-not $typeBuffers.ContainsKey($key)) {
        $typeBuffers[$key] = ""
    }
    $typeBuffers[$key] += $content.Trim() + "`n`n"
}

function Flush-Buffer($type, $baseDir) {
    foreach ($key in $typeBuffers.Keys | Sort-Object) {
        $parts = $key -split '\|', 2
        $t = $parts[0]
        $schema = $parts[1]
        if ($t -ne $type) { continue }
        $content = $typeBuffers[$key]
        if ([string]::IsNullOrWhiteSpace($content)) { continue }
        
        # Sanitize schema name for filename
        $safeSchema = $schema -replace '[^a-zA-Z0-9_]', '_'
        if ([string]::IsNullOrWhiteSpace($safeSchema)) { $safeSchema = "public" }
        
        $dir = "$baseDir"
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        $file = "$dir\$safeSchema.sql"
        
        $header = @"
-- =========================================================================
-- $schema.$t — extracted from live database
-- Auto-generated, do not edit manually
-- =========================================================================

"@
        Add-Content -Path $file -Value "$header$content" -Encoding UTF8
        $typeBuffers.Remove($key)
    }
}

# Ensure all canonical output directories exist
$allDirs = @("schemas","tables","constraints","indexes","sequences","views","materialized_views","functions","procedures","triggers","policies","types","domains","extensions","comments")
foreach ($d in $allDirs) { New-Item -ItemType Directory -Path "$canonical\$d" -Force | Out-Null }

Write-Host "Parsing $($sections.Count) sections from pg_dump output..."
$startIndex = 0
for ($i = 0; $i -lt $sections.Count; $i++) {
    $section = $sections[$i]
    
    # Extract metadata from header
    if ($section -match '-- Name:\s+(.+?);\s+Type:\s+(.+?);\s+Schema:\s+(.+?);') {
        $currentName = $matches[1]
        $currentType = $matches[2]
        $currentSchema = $matches[3]
        if ($currentSchema -eq '-') { $currentSchema = '' }
        
        # Track counts
        $key = "$currentType|$currentSchema"
        if (-not $counts.ContainsKey($key)) { $counts[$key] = 0 }
        $counts[$key]++
        
        # Extract the DDL statement (everything after the header comment)
        $body = $section -replace '^.*?--\r?\n-- Name:.*?;\r?\n--\r?\n', ''
        $body = $body -replace '^\r?\n', ''
        $body = $body.Trim()
        
        if ([string]::IsNullOrWhiteSpace($body)) { continue }
        
        switch -Wildcard ($currentType) {
            "SCHEMA" {
                Add-ToBuffer "SCHEMA" $currentSchema $body
            }
            "EXTENSION" {
                $extFileSchema = if ([string]::IsNullOrWhiteSpace($currentSchema) -or $currentSchema -eq '-') { "global" } else { $currentSchema }
                $file = "$canonical\extensions\$extFileSchema.sql"
                Add-Content -Path $file -Value "$body`n" -Encoding UTF8
            }
            "DOMAIN" {
                Add-ToBuffer "DOMAIN" $currentSchema $body
            }
            "TYPE" {
                Add-ToBuffer "TYPE" $currentSchema $body
            }
            "TABLE" {
                # Tables go with their schema
                Add-ToBuffer "TABLE" $currentSchema $body
            }
            "DEFAULT" {
                Add-ToBuffer "DEFAULT" $currentSchema $body
            }
            "CONSTRAINT" {
                Add-ToBuffer "CONSTRAINT" $currentSchema $body
            }
            "FK CONSTRAINT" {
                Add-ToBuffer "FK_CONSTRAINT" $currentSchema $body
            }
            "INDEX" {
                Add-ToBuffer "INDEX" $currentSchema $body
            }
            "SEQUENCE" {
                Add-ToBuffer "SEQUENCE" $currentSchema $body
            }
            "SEQUENCE OWNED BY" {
                Add-ToBuffer "SEQUENCE" $currentSchema $body
            }
            "SEQUENCE SET" {
                # Skip sequence values - canonical schema only
            }
            "ROW SECURITY" {
                Add-ToBuffer "RLS_ENABLE" $currentSchema $body
            }
            "VIEW" {
                Add-ToBuffer "VIEW" $currentSchema $body
            }
            "MATERIALIZED VIEW" {
                Add-ToBuffer "MATERIALIZED_VIEW" $currentSchema $body
            }
            "FUNCTION" {
                Add-ToBuffer "FUNCTION" $currentSchema $body
            }
            "PROCEDURE" {
                Add-ToBuffer "PROCEDURE" $currentSchema $body
            }
            "TRIGGER" {
                Add-ToBuffer "TRIGGER" $currentSchema $body
            }
            "POLICY" {
                Add-ToBuffer "POLICY" $currentSchema $body
            }
            "COMMENT" {
                # Skip comments that are in the pg_dump — the COMMENT ON statements
                # are covered separately
                Add-ToBuffer "COMMENT" $currentSchema $body
            }
            "ACL" {
                # Skip ACLs — canonical schema-only excludes grants for portability
            }
            default {
                Write-Host "Unknown type: $currentType"
            }
        }
    } elseif ($section -match '^-- Name:\s+(.+?);\s+Type:\s+(.+?)$') {
        # Type without Schema
        $currentName = $matches[1]
        $currentType = $matches[2]
        $currentSchema = ""
        
        $body = $section -replace '^.*?--\r?\n-- Name:.*?;\r?\n--\r?\n', ''
        $body = $body -replace '^\r?\n', ''
        $body = $body.Trim()
        
        if ([string]::IsNullOrWhiteSpace($body)) { continue }
        
        switch ($currentType) {
            "EXTENSION" {
                $file = "$canonical\extensions\global.sql"
                if (-not (Test-Path $file)) { New-Item -ItemType File -Path $file -Force | Out-Null }
                Add-Content -Path $file -Value "$body`n" -Encoding UTF8
            }
        }
    }
}

Write-Host "Flushing buffers to files..."

# Flush all buffers
$typeMap = @{
    "SCHEMA" = "schemas"
    "DOMAIN" = "domains"
    "TYPE" = "types"
    "TABLE" = "tables"
    "DEFAULT" = "sequences"
    "CONSTRAINT" = "constraints"
    "FK_CONSTRAINT" = "constraints"
    "INDEX" = "indexes"
    "SEQUENCE" = "sequences"
    "VIEW" = "views"
    "MATERIALIZED_VIEW" = "materialized_views"
    "FUNCTION" = "functions"
    "PROCEDURE" = "procedures"
    "TRIGGER" = "triggers"
    "POLICY" = "policies"
    "RLS_ENABLE" = "policies"
    "COMMENT" = "comments"
}

foreach ($key in $typeBuffers.Keys | Sort-Object) {
    $parts = $key -split '\|', 2
    $t = $parts[0]
    $schema = $parts[1]
    $content = $typeBuffers[$key]
    if ([string]::IsNullOrWhiteSpace($content)) { continue }
    
        $safeSchema = if ([string]::IsNullOrWhiteSpace($schema) -or $schema -eq '-') { "global" } else { $schema -replace '[^a-zA-Z0-9_]', '_' }
    
    $dirName = if ($typeMap.ContainsKey($t)) { $typeMap[$t] } else { "other" }
    $dir = "$canonical\$dirName"
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $file = "$dir\$safeSchema.sql"
    
    $header = @"
-- =========================================================================
-- $schema — $t
-- Extracted from live database — auto-generated
-- =========================================================================

"@
    Add-Content -Path $file -Value "$header$content" -Encoding UTF8
}

Write-Host ""
Write-Host "=== Extraction Summary ==="
# Group counts by type
$typeCounts = @{}
foreach ($key in $counts.Keys) {
    $parts = $key -split '\|', 2
    $t = $parts[0]
    if (-not $typeCounts.ContainsKey($t)) { $typeCounts[$t] = 0 }
    $typeCounts[$t] += $counts[$key]
}
foreach ($t in $typeCounts.Keys | Sort-Object) {
    Write-Host "$t`: $($typeCounts[$t])"
}

Write-Host "`nFiles created:"
foreach ($f in (Get-ChildItem -Path $canonical -Recurse -File | Sort-Object FullName)) {
    Write-Host "  $($f.FullName)"
}
