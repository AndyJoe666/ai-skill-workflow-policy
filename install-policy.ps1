param(
    [string]$CodexHome = (Join-Path $env:USERPROFILE '.codex'),
    [ValidateSet('Copy', 'Link')]
    [string]$InstallMode = 'Copy',
    [switch]$InstallUserOwnedPatches,
    [switch]$InstallGlobalManual,
    [switch]$Force
)

$bundleRoot = Split-Path -Parent $PSCommandPath
$skillsTarget = Join-Path $CodexHome 'skills'
New-Item -ItemType Directory -Force -Path $skillsTarget | Out-Null

function Copy-SkillContents {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,
        [Parameter(Mandatory = $true)]
        [string]$Target
    )

    New-Item -ItemType Directory -Force -Path $Target | Out-Null
    Get-ChildItem -LiteralPath $Source -Force | Copy-Item -Destination $Target -Recurse -Force
}

function Link-SkillDirectory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,
        [Parameter(Mandatory = $true)]
        [string]$Target
    )

    if (Test-Path -LiteralPath $Target) {
        $item = Get-Item -LiteralPath $Target -Force
        if (-not ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            throw "Refusing to replace existing non-link directory: $Target. Keep -InstallMode Copy, or move this confirmed policy Skill aside before linking it."
        }

        $linkTarget = @($item.Target)[0]
        if ([string]::IsNullOrWhiteSpace($linkTarget)) {
            throw "Cannot confirm the destination of existing link: $Target"
        }

        $expected = (Resolve-Path -LiteralPath $Source).Path.TrimEnd('\\')
        $actual = (Resolve-Path -LiteralPath $linkTarget).Path.TrimEnd('\\')
        if ($actual -ne $expected) {
            throw "Existing link points elsewhere: $Target -> $linkTarget. Refusing to replace it."
        }

        return
    }

    New-Item -ItemType Junction -Path $Target -Target $Source | Out-Null
}

function Install-SkillDirectory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,
        [Parameter(Mandatory = $true)]
        [string]$Target
    )

    if ($InstallMode -eq 'Link') {
        Link-SkillDirectory -Source $Source -Target $Target
    }
    else {
        Copy-SkillContents -Source $Source -Target $Target
    }
}

foreach ($name in @('mvp-workflow-router', 'mvp-coding-policy', 'skill-intake-auditor', 'skill-security-auditor')) {
    $source = Join-Path $bundleRoot "skills\$name"
    $target = Join-Path $skillsTarget $name
    Install-SkillDirectory -Source $source -Target $target
    Write-Output "Installed policy Skill ($InstallMode): $name"
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
        Install-SkillDirectory -Source $source -Target $target
        Write-Output "Applied user-owned patch ($InstallMode): $($_.Name)"
    }
}
