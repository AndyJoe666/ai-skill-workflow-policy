# Local AI Skill Audit

## Scope and method

Audited on 2026-08-13: 61 enabled Skills — 39 under `C:\Users\hp\.codex\skills` and 22 from enabled plugin versions. Excluded cache backups, staging copies, and unenabled marketplace content.

The scanner flags workflow language; final ratings below are a manual contextual review. A domain Skill mentioning statistical “tests”, for example, is not treated as a software-test workflow merely because it contains that word. Ratings describe **risk of unnecessary process cost for normal work**, not usefulness or domain quality.

| Rating | Meaning |
|---|---|
| Critical | A default rule can routinely force planning, exhaustive testing, review/retry loops, or agents. Localized immediately. |
| High | A rule can impose costly process in common cases. Patched or overlaid with a Router condition. |
| Medium | Legitimate but should run only in Deep mode or on named risk. Router limits it. |
| Low | No material default conflict found; still inherits the Operating Manual for any coding subtask. |

## Complete inventory and final rating

| Rating | Skills | Disposition |
|---|---|---|
| Critical (6) | `using-superpowers`, `brainstorming`, `writing-plans`, `test-driven-development`, `subagent-driven-development`, `writing-skills` | Replaced in the user-owned Superpowers directory with lean MVP-first versions. |
| High (9) | `dispatching-parallel-agents`, `finishing-a-development-branch`, `requesting-code-review`, `systematic-debugging`, `verification-before-completion`, `.system/skill-creator`, `documents`, `Presentations`, `excel-live-control` | The five user-owned Superpowers Skills were replaced; the three plugin Skills and `.system/skill-creator` use compatibility overlays. |
| Medium (9) | `executing-plans`, `receiving-code-review`, `using-git-worktrees`, `.system/plugin-creator`, `sites-building`, `sites-hosting`, `pdf`, `Spreadsheets`, `template-creator` | Retained, but only use their heavier steps when Router selects Deep or the user asks. |
| Low (37) | `.system/imagegen`, `.system/openai-docs`, `.system/review-agent`, `.system/skill-installer`; `bulk-rnaseq`, `ensembl-database`, `graduate-research-mentor`, `kegg-database`, `metabolomics-workbench-database`, `nature-experiment-log`, `nature-figure`, `ncbi-sequence-fetch`, `networkx`, `pathway-enrichment`, `ppt-master`, `reactome-database`, `scientific-visualization`, `scikit-learn`, `shap`, `statistical-analysis`, `statsmodels`, `string-database`, `uniprot-database`; `control-in-app-browser`, `computer-use`, `visualize`; five Google Calendar Skills; six Slack Skills | Keep unchanged. They are domain/tool Skills and do not impose an ordinary software-development loop. |

## Findings and applied fixes

| Risk dimension | Affected high-risk Skills | Local rule now in force |
|---|---|---|
| Forced planning | `using-superpowers`, `brainstorming`, `writing-plans`, `subagent-driven-development` | Plan only for Deep work, material uncertainty, or an explicit user request. |
| Over-fine testing | `test-driven-development`, `writing-skills`, `verification-before-completion` | Direct: one relevant check. MVP: build/smoke + happy path + 1–3 named risk checks. Deep: risk-specific verification. |
| Repeated verification / self-review | `subagent-driven-development`, `requesting-code-review`, `verification-before-completion`, `documents` | One review/fix pass only when named risk warrants it; no unchanged re-runs. |
| Retry loops | `subagent-driven-development`, `systematic-debugging`, `excel-live-control` | A retry must change hypothesis, input, code, or environment. After one meaningful retry, surface evidence. |
| Refactoring / scope growth | `brainstorming`, `writing-plans`, `test-driven-development`, `writing-skills` | No unrelated cleanup, abstraction, dependencies, or future features without direction. |
| Default multi-agent behavior | `using-superpowers`, `dispatching-parallel-agents`, `subagent-driven-development`, `requesting-code-review` | Only user-requested delegation or Deep work with at least three independent, non-overlapping items. |
| Search / reuse gap | Most workflow Skills | Search the existing project and Skills before creating. Reuse an adequate solution. |
| Missing MVP / human gate | All workflow Skills | Minimum implementation → build/smoke → core path → STOP → human acceptance. |

## Direct local edits

The following files were user-owned and patched. Their pre-change SHA-256 values are retained for traceability.

| Skill | Pre-change SHA-256 |
|---|---|
| `superpowers-using-superpowers` | `55379FE7C1C473A02C61961C822996BFF30E1320D6921D9062509BC508482C05` |
| `superpowers-brainstorming` | `4A54A4858B99807F3155ED1614B2F116E35EA5C1B788E793F565DD837FD3891F` |
| `superpowers-writing-plans` | `72190C88B2B5A67A96B91D66AA72B9161913E10E8769DA3F28A226F4CC7B99D0` |
| `superpowers-test-driven-development` | `BF1B8216E523851A411E91D429A7C1C2A173E79D88957BC78E348218D50EDD54` |
| `superpowers-subagent-driven-development` | `517197B438567E074A780FBA11C33C46BAF50093E3DE6ED2B299F7B197E24C73` |
| `superpowers-dispatching-parallel-agents` | `F0DF13F584049059CC5619F90061405B89DCC6E28AB3F2A8517D27D99C7A46A6` |
| `superpowers-requesting-code-review` | `1017CCDD5BC61FAB67C654CF118CBDB520464B313073A0A6B9A6B9AA647A3AD6` |
| `superpowers-verification-before-completion` | `2BEFE7FC55BCADAA3D97DD9E8EFEB633D2561C0EBE74C5A8B17C4D9E7E4520B3` |
| `superpowers-writing-skills` | `6B8D08FE863318BE8480AE8428E169640309FA9208DF84BB0510012764454146` |

No `.system` or plugin-cache file was edited. Their localization rules are in `overlays/SKILL-PATCH-REGISTRY.md`.
