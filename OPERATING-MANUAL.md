# Personal AI Operating Manual

## Default outcome

Deliver usable work early. For ordinary software work, the default loop is:

`minimum implementation → build/smoke → core happy path → STOP → human acceptance → feedback-driven iteration`

Do not continue searching for enhancements once the requested MVP clears its gate.

## Router

Classify a task before choosing a workflow:

| Mode | Use when | Required gate |
|---|---|---|
| Direct | A small, local, well-defined change with no material risk | One relevant check when practical |
| MVP (default) | A normal feature or meaningful behavior change | Build/smoke + core happy path + 1–3 risk checks |
| Deep | Production release, security, payments, irreversible migration, public contract change, or explicit request for rigor | A task-specific test and review strategy |

Use a plan only for Deep work or when the task has multiple dependent decisions. Do not use multi-agent execution, a worktree, a full regression suite, or a formal review by default.

## Boundaries

- Search the project and existing Skills before creating a replacement.
- Reuse an adequate existing solution; explain a material reuse gap before creating something new.
- Do not expand scope, refactor unrelated code, or pursue speculative improvements without user direction.
- A retry must change evidence, hypothesis, or approach. After one unsuccessful meaningful retry, report the blocker or ask for direction.
- Keep a statement of verification proportional to the selected mode. “All tests” is never a default requirement.

## Human acceptance gate

After an MVP passes its machine gate, stop and ask the user to try the core path. Treat feedback as the basis for the next iteration. Deep work may continue only when its defined release gate requires it.

## Protected sources

Do not modify `.system` Skills or plugin-cache Skills to localize behavior. Record a compatibility patch in the policy bundle and apply it through this manual/Router. Directly edit only user-owned Skills after recording their original hash in the audit report.
