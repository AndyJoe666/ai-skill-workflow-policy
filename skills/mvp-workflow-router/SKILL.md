---
name: mvp-workflow-router
description: Use when a software, automation, or Skill task may trigger planning, testing, reviewing, refactoring, or multi-agent workflows and its delivery depth must be chosen.
---

# MVP Workflow Router

Choose one mode before invoking heavyweight process Skills.

| Mode | Observable predicate | Use |
|---|---|---|
| Direct | Local, well-defined change; no public contract, security, data-loss, payment, or migration risk | Inspect → change → one relevant check → deliver |
| MVP | Default for ordinary feature work | Minimum implementation → build/smoke → core happy path → 1–3 named risk checks → STOP for human acceptance |
| Deep | User requests rigor, or work affects security, payments, irreversible data, a public contract, or production release | Write a short task-specific plan and choose only risk-relevant tests/reviews |

## Routing rules

- Search for existing code, templates, and Skills before creating a new solution.
- Prefer the least costly mode that covers the real consequence of failure.
- Planning, broad refactoring, a worktree, code review, full regression, and multi-agent execution are Deep-only unless the user explicitly requests them.
- A failed check earns one changed-hypothesis retry. If it still fails, stop and report evidence rather than retrying the same action.
- On an MVP pass, state the core path tested and ask the user to accept or redirect the next iteration.
