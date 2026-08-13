---
name: skill-security-auditor
description: Use before enabling, updating, linking, or locally adapting an AI Skill when it may introduce powerful tools, executable scripts, remote downloads, credential access, persistence hooks, encoded payloads, or unclear provenance.
---

# Skill Security Auditor

Audit a Skill before it is enabled. This is a static triage aid, not proof that a Skill is safe.

## Workflow

1. Identify the source repository, revision, and exact Skill directory. Do not execute its bundled scripts to inspect them.
2. Run the bundled scanner against the candidate root.
3. Review each finding in source context. Separate capability signals from evidence of harmful behavior.
4. Block or ask the user before enabling a Skill with unexplained high-risk findings, unclear provenance, or code that the user cannot inspect.
5. After the security decision, run `skill-intake-auditor` for workflow-cost localization. Security review does not replace the MVP/process audit.
6. Record the decision, revision, and any local overlay. Stop for human acceptance before installation.

## Command

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File scripts/scan-skill-security.ps1 `
  -SkillRoot C:\path\to\candidate-skills `
  -Format Markdown
```

## Interpretation

- **High:** privileged or dynamic behavior needs explicit source-level review before enablement.
- **Medium:** a capability needs a stated purpose and scoped safeguards.
- **Low:** an inventory or provenance concern; review if the Skill will be trusted broadly.

Never treat a clean report as a guarantee. The scanner does not execute code, resolve every dependency, or establish author trust.
