# Multi-device deployment

## v0.2 linked mode

Use a normal clone as the shared source on each device. After reviewing the desired Git revision, install the four policy Skills with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-policy.ps1 -InstallMode Link
```

The installer creates directory junctions only when the target does not already exist. It refuses to replace a normal directory or a link that points somewhere else. This makes migration explicit: preserve an existing device-local Skill by keeping copy mode, or move only that confirmed policy Skill directory aside before running link mode.

Linked Skills follow the checked-out files in the clone. Pin a device by checking out a reviewed tag or commit; update it with `git fetch --tags`, inspect the change, choose the target revision, and restart Codex or start a new task. Do not link the whole `.codex` directory, plugin caches, credentials, or device-specific configuration.

`AGENTS.md` is intentionally not linked or overwritten by default. Merge the shared Operating Manual once, then retain device-specific paths and constraints in a clearly marked local section.

## Source of truth

Use one reviewed Git repository named `ai-skill-workflow-policy` as the source of truth. A public repository is suitable only for policy, audit reports, overlays, and user-owned patch notes. Do not commit secrets, plugin caches, device paths, or the whole `.codex` directory.

## Per-device installation

1. Clone the private repository to a normal user-owned folder.
2. Copy or link only `skills/mvp-workflow-router`, `skills/mvp-coding-policy`, `skills/skill-intake-auditor`, and `skills/skill-security-auditor` to `<CODEX_HOME>/skills/`.
3. Add the concise Operating Manual to `<CODEX_HOME>/AGENTS.md`; preserve any device-specific instructions below a clearly marked section.
4. Keep vendor/plugin Skills untouched. Store differences in `overlays/SKILL-PATCH-REGISTRY.md`.
5. Restart the Codex client or begin a new task so its Skill catalogue is refreshed.

## Updating a device

1. Pull the policy repository.
2. Run the intake auditor on the proposed Skill or update.
3. Review the report and accept, reject, or tailor the suggested overlay.
4. Copy the policy Skills only if their hashes changed.
5. Run the one auditor contract check and manually try one normal MVP task.

## Conflict rule

The repository owns shared operating policy. A device owns only paths, tools, credentials, and project-specific instructions. If they conflict, keep the shared policy intact and add the smallest device-specific exception rather than forking the entire manual.
