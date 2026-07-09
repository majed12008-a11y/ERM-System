# generate-bootstrap.ps1
# Compiles canonical files into bootstrap deployment SQL files

$canonical = "C:\ERM-System\database\canonical"
$bootstrap = "C:\ERM-System\database\bootstrap"

Write-Host "Generating bootstrap from canonical..."

# 00_extensions.sql
Write-Host "  00_extensions.sql"
$extFile = "$canonical\extensions\global.sql"
$content = "-- =========================================================================
-- 00_extensions.sql — PostgreSQL extensions
-- Auto-generated from canonical extraction
-- Dependencies: none
-- =========================================================================

"
if (Test-Path $extFile) { $content += (Get-Content $extFile -Raw) + "`n" }
else { $content += "-- No extensions found`n" }
Set-Content -Path "$bootstrap\00_extensions.sql" -Value $content -Encoding UTF8

# 01_domains.sql
Write-Host "  01_domains.sql"
$content = "-- =========================================================================
-- 01_domains.sql — Custom domains
-- Auto-generated from canonical extraction
-- =========================================================================

"
foreach ($f in (Get-ChildItem "$canonical\domains\*.sql")) {
    $content += (Get-Content $f.FullName -Raw) + "`n"
}
Set-Content -Path "$bootstrap\01_domains.sql" -Value $content -Encoding UTF8

# 02_types.sql — schemas + types
Write-Host "  02_types.sql"
$content = "-- =========================================================================
-- 02_types.sql — Schemas and custom types
-- Auto-generated from canonical extraction
-- =========================================================================

"
# Schemas first
$schemaFile = "$canonical\schemas\global.sql"
if (Test-Path $schemaFile) { $content += (Get-Content $schemaFile -Raw) + "`n" }

# Types
$typeFiles = Get-ChildItem "$canonical\types\*.sql" -ErrorAction SilentlyContinue
foreach ($f in $typeFiles) { $content += (Get-Content $f.FullName -Raw) + "`n" }

Set-Content -Path "$bootstrap\02_types.sql" -Value $content -Encoding UTF8

# 03_tables.sql
Write-Host "  03_tables.sql — building..."
$content = "-- =========================================================================
-- 03_tables.sql — All table definitions
-- Auto-generated from canonical extraction (209 tables, 6 test_rls excluded)
-- Order: sorted by schema, respecting FK dependencies
-- =========================================================================

"
# Schema-level ALTER DEFAULT and sequences
$seqDir = "$canonical\sequences"
foreach ($f in (Get-ChildItem "$seqDir\*.sql" | Sort-Object Name)) {
    $raw = Get-Content $f.FullName -Raw
    $content += $raw + "`n"
}

# Tables - ordered by schema to respect FK dependencies
# Reference data first, then dependent schemas
$tableOrder = @('audit', 'public', 'reference', 'security', 'core', 'documents', 'committee', 'communication', 'workflow', 'integration', 'monitoring', 'reporting', 'safety', 'system')
$tableDir = "$canonical\tables"
foreach ($schema in $tableOrder) {
    $f = "$tableDir\$schema.sql"
    if (Test-Path $f) {
        $content += (Get-Content $f -Raw) + "`n"
    }
}
Set-Content -Path "$bootstrap\03_tables.sql" -Value $content -Encoding UTF8

# 04_constraints.sql
Write-Host "  04_constraints.sql — building..."
$content = "-- =========================================================================
-- 04_constraints.sql — Foreign keys, unique constraints, check constraints
-- Auto-generated from canonical extraction (239 FK + 307 constraints)
-- =========================================================================

"
$conDir = "$canonical\constraints"
foreach ($f in (Get-ChildItem "$conDir\*.sql" | Sort-Object Name)) {
    $raw = Get-Content $f.FullName -Raw
    $content += $raw + "`n"
}
Set-Content -Path "$bootstrap\04_constraints.sql" -Value $content -Encoding UTF8

# 05_indexes.sql
Write-Host "  05_indexes.sql — building..."
$content = "-- =========================================================================
-- 05_indexes.sql — All indexes (excludes PK/unique constraint indexes)
-- Auto-generated from canonical extraction (273 indexes)
-- =========================================================================

"
$idxDir = "$canonical\indexes"
foreach ($f in (Get-ChildItem "$idxDir\*.sql" | Sort-Object Name)) {
    $raw = Get-Content $f.FullName -Raw
    $content += $raw + "`n"
}
Set-Content -Path "$bootstrap\05_indexes.sql" -Value $content -Encoding UTF8

# 06_functions.sql
Write-Host "  06_functions.sql — building..."
$content = "-- =========================================================================
-- 06_functions.sql — User-defined functions (excludes extension functions)
-- Auto-generated from canonical extraction (30 functions)
-- =========================================================================

"
$fnDir = "$canonical\functions"
foreach ($f in (Get-ChildItem "$fnDir\*.sql" | Sort-Object Name)) {
    $raw = Get-Content $f.FullName -Raw
    $content += $raw + "`n"
}
Set-Content -Path "$bootstrap\06_functions.sql" -Value $content -Encoding UTF8

# 07_triggers.sql
Write-Host "  07_triggers.sql — building..."
$content = "-- =========================================================================
-- 07_triggers.sql — All triggers (225 total, 6 test_rls excluded)
-- Auto-generated from canonical extraction
-- =========================================================================

"
$trgDir = "$canonical\triggers"
foreach ($f in (Get-ChildItem "$trgDir\*.sql" | Sort-Object Name)) {
    $raw = Get-Content $f.FullName -Raw
    $content += $raw + "`n"
}
Set-Content -Path "$bootstrap\07_triggers.sql" -Value $content -Encoding UTF8

# 08_policies.sql
Write-Host "  08_policies.sql — building..."
$content = "-- =========================================================================
-- 08_policies.sql — RLS policies (256 policies, 77 RLS enables)
-- Auto-generated from canonical extraction
-- =========================================================================

"
$polDir = "$canonical\policies"
foreach ($f in (Get-ChildItem "$polDir\*.sql" | Sort-Object Name)) {
    $raw = Get-Content $f.FullName -Raw
    $content += $raw + "`n"
}
Set-Content -Path "$bootstrap\08_policies.sql" -Value $content -Encoding UTF8

# 09_views.sql
Write-Host "  09_views.sql"
$content = "-- =========================================================================
-- 09_views.sql — Views and materialized views
-- Auto-generated from canonical extraction
-- =========================================================================

"
# Regular views
$viewDir = "$canonical\views"
foreach ($f in (Get-ChildItem "$viewDir\*.sql" | Sort-Object Name)) {
    $raw = Get-Content $f.FullName -Raw
    $content += $raw + "`n"
}
# Materialized views
$mvDir = "$canonical\materialized_views"
foreach ($f in (Get-ChildItem "$mvDir\*.sql" | Sort-Object Name)) {
    $raw = Get-Content $f.FullName -Raw
    $content += $raw + "`n"
}
Set-Content -Path "$bootstrap\09_views.sql" -Value $content -Encoding UTF8

# 10_seed_reference.sql — comments (schema documentation)
Write-Host "  10_comments.sql"
$content = "-- =========================================================================
-- 10_comments.sql — Database object comments
-- Auto-generated from canonical extraction (570 comments)
-- =========================================================================

"
$comDir = "$canonical\comments"
foreach ($f in (Get-ChildItem "$comDir\*.sql" | Sort-Object Name)) {
    $raw = Get-Content $f.FullName -Raw
    $content += $raw + "`n"
}
Set-Content -Path "$bootstrap\10_comments.sql" -Value $content -Encoding UTF8

Write-Host "`nBootstrap files generated:"
Get-ChildItem "$bootstrap\*.sql" | Sort-Object Name | ForEach-Object { Write-Host "  $($_.Name) ($( [math]::Round($_.Length/1KB) ) KB)" }
