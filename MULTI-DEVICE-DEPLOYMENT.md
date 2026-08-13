# Multi-device deployment

## Source of truth

Create one private Git repository named `ai-skill-workflow-policy` from this folder. Commit the policy package, audit reports, overlays, and any direct local-Skill patch notes. Do not commit secrets, plugin caches, or the whole `.codex` directory.

## Per-device installation

1. Clone the private repository to a normal user-owned folder.
2. Copy only `skills/mvp-workflow-router`, `skills/mvp-coding-policy`, and `skills/skill-intake-auditor` to `<CODEX_HOME>/skills/`.
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
