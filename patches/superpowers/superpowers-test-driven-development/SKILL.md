---
name: test-driven-development
description: Use when Deep-mode software behavior is stable, consequential, and easier to specify through a focused failing test before implementation.
---

# Risk-Based Test-First Development

Test-first development is one option, not the default for every edit. Use it for a difficult bug, stable business rule, security-sensitive behavior, regression-prone contract, or when a focused failing test will clarify the design.

For Direct work, use one relevant check when practical. For MVP work, use build/smoke, the core happy path, and 1–3 checks for named new risks. Do not require a test for every method, coverage targets, exhaustive edge cases, mocks, or a full suite unless Deep risk justifies them.

Write the smallest code and test set that provides meaningful evidence. Re-run a check only after the relevant code, input, environment, or hypothesis changed. Stop at the human acceptance gate for MVP work.
