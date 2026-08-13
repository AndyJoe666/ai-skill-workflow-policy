---
name: mvp-coding-policy
description: Use when implementing or changing software behavior and a proportional MVP-first verification budget, scope boundary, and human acceptance gate are needed.
---

# MVP Coding Policy

## Scope first

State the requested behavior and the smallest affected surface. Search before creating; reuse an adequate project pattern. Do not add abstraction, cleanup, tests, dependencies, or features unrelated to that behavior.

## Test budget

| Mode | Machine checks | Stop condition |
|---|---|---|
| Direct | Build/type check or one focused behavior check when practical | Requested local change is demonstrably usable |
| MVP | Build/smoke, one happy-path core flow, and 1–3 checks for named risks introduced by the change | Hand off for human acceptance |
| Deep | A written, risk-specific verification set; add integration/regression/security checks only when their failure consequence justifies them | Defined release gate passes |

Coverage targets, exhaustive edge cases, repeated unchanged checks, and full suites are not MVP gates. A test-first cycle is useful when it clarifies a stable behavior; it is not required for low-risk configuration, prototypes, or straightforward local edits.

## Human acceptance

After the MVP gate, stop. Tell the user how to exercise the core path and what was checked. Continue only from user feedback or a stated Deep gate.

## Retry and review

Repeat a check only after code, environment, input, or hypothesis changes. Use one targeted review for a Deep risk or user request; do not self-review indefinitely or dispatch agents by default.
