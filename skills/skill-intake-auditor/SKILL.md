---
name: skill-intake-auditor
description: Use when installing, updating, or locally reviewing an AI Skill and its workflow may add excessive planning, testing, verification, retries, refactoring, agents, scope expansion, or omit reuse and MVP gates.
---

# Skill Intake Auditor

Audit before enabling a new or updated Skill. This is a decision aid, not an automatic installer.

## Workflow

1. Inventory every `SKILL.md` below the supplied root and identify the source/version.
2. Run `skill-security-auditor` first when the candidate is new, updated, linked from another repository, or includes scripts/dependencies. Resolve high-risk findings before enabling it.
3. Run `scripts/audit-skills.ps1` and read its workflow-cost flags in context.
4. Classify each finding:
   - **Keep:** already proportional.
   - **Condition:** add an observable trigger.
   - **Downgrade:** replace broad verification with a targeted gate.
   - **Move-Deep:** retain only for production/high-risk work.
   - **Remove:** no stable benefit.
5. For a user-owned Skill, propose a small direct patch. For a system or plugin Skill, add a row to the compatibility registry; do not edit vendor cache.
6. Validate with the relevant scanner contract check and one representative audit. Stop for human acceptance before enabling a behavioral patch.

## Required audit dimensions

- forced planning;
- exhaustive or test-first defaults;
- duplicated verification/review;
- unbounded retry, self-review, or fix loops;
- speculative refactoring/abstraction or scope expansion;
- default multi-agent dispatch;
- Search-Before-Create and Reuse-First coverage;
- MVP-first and human-acceptance coverage.

## Commands

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/audit-skills.ps1 -SkillRoot C:\path\to\skills -Format Markdown
powershell -NoProfile -ExecutionPolicy Bypass -File tests/test-auditor-contract.ps1 -FixtureRoot C:\path\to\skills
```
