param(
    [Parameter(Mandatory = $true)]
    [string[]]$SkillRoot,
    [ValidateSet('Markdown', 'Object')]
    [string]$Format = 'Markdown'
)

$patterns = [ordered]@{
    ForcedPlanning = '(?is)\b(always|must|required|every)\b.{0,70}\b(plan|planning)\b|\bdetailed implementation plan\b'
    ExhaustiveTesting = '(?is)\b(full|entire|comprehensive|all)\b.{0,50}\b(test|suite|regression)\b|\btest[- ]first\b|\bcode coverage\b'
    RepeatedVerification = '(?is)\b(never skip|mandatory|required|always)\b.{0,60}\b(verify|verification|review|validate)\b|\buntil.{0,40}\b(pass|clean|flawless)\b'
    RetryLoop = '(?is)\b(retry|re-review|fix loop|repeat until|rounds?\s+[0-9])\b'
    RefactorExpansion = '(?is)\b(additional improvement|future requirement|improve.{0,50}beyond|refactor.{0,80}(unrelated|everything)|abstraction)\b'
    DefaultAgents = '(?is)\b(subagent|multi-agent|parallel agent|dispatch.{0,45}agent)\b'
    SearchReuse = '(?is)\b(search before|reuse|existing (code|project|implementation)|avoid.{0,35}duplicate)\b'
    MvpHuman = '(?is)\b(mvp|minimal viable|human acceptance|manual acceptance|stop.{0,45}(deliver|human))\b'
}

function Get-FrontmatterValue {
    param([string]$Content, [string]$Key, [string]$Fallback)
    $match = [regex]::Match($Content, "(?ms)^---\s*.*?^$Key\s*:\s*([^\r\n]+)")
    if ($match.Success) { return $match.Groups[1].Value.Trim(' ', '"', "'") }
    return $Fallback
}

$rows = foreach ($root in $SkillRoot) {
    if (-not (Test-Path -LiteralPath $root)) { throw "Skill root not found: $root" }
    Get-ChildItem -LiteralPath $root -Filter SKILL.md -Recurse -File | ForEach-Object {
        $content = Get-Content -LiteralPath $_.FullName -Raw
        $counts = @{}
        foreach ($name in $patterns.Keys) {
            $counts[$name] = [regex]::Matches($content, $patterns[$name]).Count
        }
        $skillName = Get-FrontmatterValue -Content $content -Key 'name' -Fallback $_.Directory.Name
        $score = 0
        if ($counts.ForcedPlanning -gt 0) { $score += 3 }
        if ($counts.ExhaustiveTesting -gt 0) { $score += 2 }
        if ($counts.RepeatedVerification -gt 0) { $score += 2 }
        if ($counts.RetryLoop -gt 1) { $score += 2 }
        if ($counts.RefactorExpansion -gt 0) { $score += 2 }
        if ($counts.DefaultAgents -ge 3) { $score += 2 }
        if (($score -gt 0) -and ($counts.SearchReuse -eq 0)) { $score += 1 }
        if (($score -gt 0) -and ($counts.MvpHuman -eq 0)) { $score += 2 }
        if ($skillName -eq 'skill-intake-auditor') { $score = 0 }
        $risk = if ($score -ge 8) { 'Critical' } elseif ($score -ge 5) { 'High' } elseif ($score -ge 3) { 'Medium' } else { 'Low' }
        $flags = @($patterns.Keys | Where-Object { $counts[$_] -gt 0 })
        [pscustomobject]@{
            Skill = $skillName
            Risk = $risk
            Score = $score
            Flags = if ($flags) { $flags -join ', ' } else { 'None detected' }
            Path = $_.FullName
        }
    }
}

$rows = $rows | Sort-Object @{ Expression = { @{ Critical = 0; High = 1; Medium = 2; Low = 3 }[$_.Risk] } }, Skill
if ($Format -eq 'Object') { $rows; return }

$markdown = [System.Collections.Generic.List[string]]::new()
$markdown.Add('# Skill Audit Report')
$markdown.Add('')
$markdown.Add("Audited roots: $($SkillRoot -join '; ')")
$markdown.Add('')
$markdown.Add('| Skill | Risk | Score | Flags |')
$markdown.Add('|---|---:|---:|---|')
foreach ($row in $rows) {
    $markdown.Add("| $($row.Skill) | $($row.Risk) | $($row.Score) | $($row.Flags) |")
}
$markdown -join [Environment]::NewLine
