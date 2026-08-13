# Compatibility patch registry

These are policy overrides, not edits to vendor/system Skill files.

| Source Skill | Risk | Local compatibility rule |
|---|---|---|
| `.system/skill-creator` | High | Forward-test only when the Skill is risky, tool-integrated, or repeatedly fails in use. One representative trial is sufficient for a normal Skill; do not default to a multi-agent evaluation campaign. |
| `documents` | Medium | Render once when layout matters. Iterate only for visible defects that block the requested use; “flawless” is not an MVP requirement. |
| `presentations` / `spreadsheets` / `pdf` | Medium | Verify the requested artefact and core path, not every page, sheet, or possible output mode unless the request is production-critical. |
| Any plugin Skill with “always”, “full suite”, “repeat until”, or “review every task” | Medium–High | Router mode wins: Direct and MVP use their stated gates. Deep follows the plugin process only where the extra verification directly addresses the named risk. |

Record future accepted overlays here with: source path, version/hash, observed conflict, and a narrowly scoped replacement rule.
