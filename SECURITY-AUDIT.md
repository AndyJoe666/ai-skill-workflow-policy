# Skill security review

`skill-security-auditor` is a local static review layer for candidate Skills. It complements, but does not replace, `skill-intake-auditor`:

1. Review provenance and code capability first.
2. Localize process rules only after that security decision.
3. Require human acceptance before enabling a changed or linked Skill.

The scanner reads runtime-facing files and reports signals. It does not execute candidate scripts, install dependencies, fetch remote content, modify the candidate, or prove trustworthiness. Test and fixture directories are excluded because they are not normally enabled as part of a Skill; review them separately before choosing to run them.

## Signals

| Signal | Default response |
|---|---|
| Wildcard/write-capable tools, hooks, dynamic execution, credential paths, install hooks, persistence | Review source before enabling; require an explicit decision for high findings. |
| Network access or encoded content | Confirm purpose, endpoint, integrity, and whether the capability is needed. |
| No findings | Still confirm source, revision, and relevant dependencies. |

## Run it

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File .\skills\skill-security-auditor\scripts\scan-skill-security.ps1 `
  -SkillRoot 'C:\path\to\candidate-skills' `
  -Format Markdown
```

For a small contract check:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File .\skills\skill-security-auditor\tests\test-security-scanner-contract.ps1
```
