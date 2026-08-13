$ErrorActionPreference = 'Stop'

$bundleRoot = Split-Path -Parent $PSScriptRoot
$installer = Join-Path $bundleRoot 'install-policy.ps1'
$testHome = Join-Path ([IO.Path]::GetTempPath()) "policy-install-contract-$PID"
$linkHome = Join-Path ([IO.Path]::GetTempPath()) "policy-link-contract-$PID"
$expectedSkills = @('mvp-workflow-router', 'mvp-coding-policy', 'skill-intake-auditor', 'skill-security-auditor')

try {
    & $installer -CodexHome $testHome
    & $installer -CodexHome $testHome

    foreach ($name in $expectedSkills) {
        $skillFile = Join-Path $testHome "skills\\$name\\SKILL.md"
        if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
            throw "Missing installed Skill: $name"
        }
        $nested = Join-Path $testHome "skills\\$name\\$name\\SKILL.md"
        if (Test-Path -LiteralPath $nested -PathType Leaf) {
            throw "Unexpected nested Skill directory: $nested"
        }
    }

    $allSkillFiles = @(Get-ChildItem -LiteralPath (Join-Path $testHome 'skills') -Filter 'SKILL.md' -File -Recurse)
    if ($allSkillFiles.Count -ne $expectedSkills.Count) {
        throw "Expected $($expectedSkills.Count) installed SKILL.md files; found $($allSkillFiles.Count)."
    }

    & $installer -CodexHome $linkHome -InstallMode Link
    foreach ($name in $expectedSkills) {
        $target = Join-Path $linkHome "skills\\$name"
        $item = Get-Item -LiteralPath $target -Force
        if (-not ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            throw "Expected a directory link for: $name"
        }
        if (-not (Test-Path -LiteralPath (Join-Path $target 'SKILL.md') -PathType Leaf)) {
            throw "Linked Skill cannot be read: $name"
        }
    }

    Write-Output 'Install policy contract passed.'
}
finally {
    if (Test-Path -LiteralPath $testHome) {
        Remove-Item -LiteralPath $testHome -Recurse -Force
    }
    if (Test-Path -LiteralPath $linkHome) {
        Remove-Item -LiteralPath $linkHome -Recurse -Force
    }
}
