param(
    [Parameter(Mandatory = $true)]
    [string]$FixtureRoot
)

$scriptPath = Join-Path $PSScriptRoot '..\scripts\audit-skills.ps1'
try {
    $report = & $scriptPath -SkillRoot $FixtureRoot -Format Markdown -ErrorAction Stop
} catch {
    throw "The auditor exited unsuccessfully: $($_.Exception.Message)"
}

if ($report -notmatch '# Skill Audit Report') { throw 'The report header is missing.' }
if ($report -notmatch '\| Risk \|') { throw 'The report table is missing.' }
if ($report -notmatch 'test-driven-development') { throw 'The fixture Skill was not inventoried.' }

Write-Output 'PASS: auditor contract'
