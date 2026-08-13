param(
    [string]$CodexHome = (Join-Path $env:USERPROFILE '.codex'),
    [switch]$InstallUserOwnedPatches,
    [switch]$InstallGlobalManual,
    [switch]$Force
)

$bundleRoot = Split-Path -Parent $PSCommandPath
$skillsTarget = Join-Path $CodexHome 'skills'
New-Item -ItemType Directory -Force -Path $skillsTarget | Out-Null

foreach ($name in @('mvp-workflow-router', 'mvp-coding-policy', 'skill-intake-auditor')) {
    $source = Join-Path $bundleRoot "skills\$name"
    $target = Join-Path $skillsTarget $name
    Copy-Item -LiteralPath $source -Destination $target -Recurse -Force
    Write-Output "Installed policy Skill: $name"
}

if ($InstallGlobalManual) {
    $manual = Get-Content -LiteralPath (Join-Path $bundleRoot 'OPERATING-MANUAL.md') -Raw
    $agentPath = Join-Path $CodexHome 'AGENTS.md'
    $existing = if (Test-Path -LiteralPath $agentPath) { Get-Content -LiteralPath $agentPath -Raw } else { '' }
    if ($existing.Trim() -and -not $Force) {
        throw "Refusing to overwrite non-empty $agentPath. Review and merge OPERATING-MANUAL.md, or rerun with -Force."
    }
    Set-Content -LiteralPath $agentPath -Value $manual -Encoding utf8
    Write-Output "Installed global manual: $agentPath"
}

if ($InstallUserOwnedPatches) {
    $patchRoot = Join-Path $bundleRoot 'patches\superpowers'
    Get-ChildItem -LiteralPath $patchRoot -Directory | Where-Object { $_.Name -ne 'README.md' } | ForEach-Object {
        $source = $_.FullName
        $target = Join-Path $skillsTarget $_.Name
        Copy-Item -LiteralPath $source -Destination $target -Recurse -Force
        Write-Output "Applied user-owned patch: $($_.Name)"
    }
}
