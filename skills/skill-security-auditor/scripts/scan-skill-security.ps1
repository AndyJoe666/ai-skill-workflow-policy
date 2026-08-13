param(
    [Parameter(Mandatory = $true)]
    [string]$SkillRoot,
    [ValidateSet('Markdown', 'Object')]
    [string]$Format = 'Markdown'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $SkillRoot -PathType Container)) {
    throw "Skill root does not exist: $SkillRoot"
}

$resolvedRoot = (Resolve-Path -LiteralPath $SkillRoot).Path
$scannerPath = [IO.Path]::GetFullPath($PSCommandPath)
$findings = [System.Collections.Generic.List[object]]::new()

function Add-Finding {
    param(
        [string]$Severity,
        [string]$Category,
        [string]$Skill,
        [string]$Path,
        [string]$Evidence,
        [string]$Action
    )

    $findings.Add([pscustomobject]@{
            Severity = $Severity
            Category = $Category
            Skill    = $Skill
            Path     = $Path
            Evidence = $Evidence
            Action   = $Action
        })
}

$skillFiles = @(Get-ChildItem -LiteralPath $resolvedRoot -Filter 'SKILL.md' -File -Recurse)
if ($skillFiles.Count -eq 0) {
    throw "No SKILL.md files found below: $resolvedRoot"
}

foreach ($skillFile in $skillFiles) {
    $skillDirectory = $skillFile.Directory.FullName
    $skillName = $skillFile.Directory.Name
    $skillText = Get-Content -LiteralPath $skillFile.FullName -Raw
    $frontMatter = [regex]::Match($skillText, '(?ms)\A---\s*\r?\n(.*?)\r?\n---').Groups[1].Value

    if ([string]::IsNullOrWhiteSpace($frontMatter)) {
        Add-Finding -Severity 'Medium' -Category 'Metadata' -Skill $skillName -Path $skillFile.FullName -Evidence 'No readable YAML frontmatter.' -Action 'Confirm the trigger and permissions manually.'
    }
    elseif ($frontMatter -match '(?im)^\s*allowed-tools\s*:\s*.*\*') {
        Add-Finding -Severity 'High' -Category 'Tool access' -Skill $skillName -Path $skillFile.FullName -Evidence 'Wildcard tool access is declared.' -Action 'Require an explicit user decision and replace with the smallest practical tool set.'
    }
    elseif ($frontMatter -match '(?im)^\s*allowed-tools\s*:\s*.*\b(Bash|Shell|Write|Edit)\b') {
        Add-Finding -Severity 'Medium' -Category 'Tool access' -Skill $skillName -Path $skillFile.FullName -Evidence 'Shell or write-capable tools are declared.' -Action 'Confirm why write access is necessary and which paths it can affect.'
    }

    if ($skillText -match '(?im)\b(PreToolUse|PostToolUse|UserPromptSubmit)\b') {
        Add-Finding -Severity 'High' -Category 'Hooks' -Skill $skillName -Path $skillFile.FullName -Evidence 'Lifecycle hook terminology appears in Skill instructions.' -Action 'Inspect the referenced configuration and every hook command before enablement.'
    }

    $files = @(Get-ChildItem -LiteralPath $skillDirectory -File -Recurse -Force)
    foreach ($file in $files) {
        if ([IO.Path]::GetFullPath($file.FullName) -eq $scannerPath) {
            continue
        }

        $relativePath = $file.FullName.Substring($skillDirectory.Length).TrimStart('\\')
        if ($relativePath -match '^(tests?|fixtures)[\\/]') {
            continue
        }

        if ($file.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            Add-Finding -Severity 'Medium' -Category 'Filesystem link' -Skill $skillName -Path $file.FullName -Evidence 'A linked file is included in the Skill.' -Action 'Resolve the link target and review it as part of the Skill.'
        }

        if ($file.Name -eq 'package.json') {
            $packageText = Get-Content -LiteralPath $file.FullName -Raw
            if ($packageText -match '(?i)"(preinstall|install|postinstall|prepare)"\s*:') {
                Add-Finding -Severity 'High' -Category 'Install hook' -Skill $skillName -Path $file.FullName -Evidence 'A package lifecycle hook is declared.' -Action 'Review the hook and its dependencies before installing packages.'
            }
        }

        if ($file.Extension -notin @('.ps1', '.py', '.js', '.mjs', '.cjs', '.sh', '.bash', '.zsh', '.bat', '.cmd')) {
            continue
        }

        $scriptText = Get-Content -LiteralPath $file.FullName -Raw
        if ($scriptText -match '(?is)(Invoke-WebRequest|Invoke-RestMethod|curl(?:\.exe)?|wget|DownloadString|WebClient).{0,300}(Invoke-Expression|\biex\b|\beval\s*\(|\bexec\s*\()') {
            Add-Finding -Severity 'High' -Category 'Remote execution' -Skill $skillName -Path $file.FullName -Evidence 'A download mechanism appears near dynamic execution.' -Action 'Do not run it until the payload source and execution path are reviewed.'
        }
        elseif ($scriptText -match '(?i)\b(Invoke-WebRequest|Invoke-RestMethod|curl(?:\.exe)?|wget|DownloadString|WebClient)\b') {
            Add-Finding -Severity 'Medium' -Category 'Network access' -Skill $skillName -Path $file.FullName -Evidence 'A network download/client mechanism appears.' -Action 'Confirm the endpoint, integrity check, and user authorization.'
        }

        if ($scriptText -match '(?i)\b(Invoke-Expression|iex)\b|\beval\s*\(|\bexec\s*\(|shell\s*=\s*True|\bcmd(?:\.exe)?\s+/c\b') {
            Add-Finding -Severity 'High' -Category 'Dynamic execution' -Skill $skillName -Path $file.FullName -Evidence 'Dynamic command execution appears.' -Action 'Review exact inputs and replace with fixed commands where possible.'
        }
        if ($scriptText -match '(?i)(\.ssh[\\/]|\.aws[\\/]|authorized_keys|id_rsa|credentials(?:\.json)?|\.env\b)') {
            Add-Finding -Severity 'High' -Category 'Credential access' -Skill $skillName -Path $file.FullName -Evidence 'Credential or environment-file paths appear.' -Action 'Confirm necessity and prevent collection, logging, or transmission of secrets.'
        }
        if ($scriptText -match '(?i)(schtasks|crontab|\.bashrc|\.zshrc|PostToolUse|PreToolUse|git\s+config\s+--global)') {
            Add-Finding -Severity 'High' -Category 'Persistence or global configuration' -Skill $skillName -Path $file.FullName -Evidence 'A persistence or global-configuration mechanism appears.' -Action 'Require explicit user approval and a reversible, scoped change.'
        }
        if ($scriptText -match '(?i)(FromBase64String|Convert\.FromBase64String|base64\s+-d)') {
            Add-Finding -Severity 'Medium' -Category 'Encoded payload' -Skill $skillName -Path $file.FullName -Evidence 'Encoded-content decoding appears.' -Action 'Decode and inspect the content before execution.'
        }
    }
}

if ($Format -eq 'Object') {
    $findings
    return
}

$high = @($findings | Where-Object Severity -eq 'High').Count
$medium = @($findings | Where-Object Severity -eq 'Medium').Count
$low = @($findings | Where-Object Severity -eq 'Low').Count
"# Skill security scan"
""
"Scanned $($skillFiles.Count) Skill(s) under ``$resolvedRoot``. Findings are static signals, not a safety guarantee."
""
"- High: $high"
"- Medium: $medium"
"- Low: $low"
""
if ($findings.Count -eq 0) {
    "No configured signals found. Confirm source provenance and inspect relevant code before enabling."
    return
}

"| Severity | Category | Skill | Evidence | Action |"
"|---|---|---|---|---|"
foreach ($finding in $findings) {
    "| $($finding.Severity) | $($finding.Category) | $($finding.Skill) | $($finding.Evidence) | $($finding.Action) |"
}
