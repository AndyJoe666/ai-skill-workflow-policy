---
name: writing-plans
description: Use when Deep-mode work has multiple dependent steps, material architecture decisions, or a user explicitly requests an implementation plan.
---

# Proportionate Implementation Plans

Write a short plan only when routing selects Deep or the user asks for one. The plan states the outcome, affected files or components, dependency order, named risks, and the smallest verification gate for each stage.

Do not create a plan for a small, local, well-defined change. Do not prescribe worktrees, commits, subagents, test-first cycles, or a review after every task unless the selected risk specifically needs them.

Plans end with either an MVP handoff for human acceptance or a stated Deep release gate. They do not authorize speculative refactoring or scope expansion.
