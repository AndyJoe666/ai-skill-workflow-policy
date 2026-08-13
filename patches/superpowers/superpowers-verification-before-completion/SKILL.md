---
name: verification-before-completion
description: Use before reporting an implemented change as complete when the verification claim and its scope need to be stated accurately.
---

# Proportionate Verification

Evidence must match the claim. Report exactly what was checked, not “fully verified” by default.

| Mode | Required evidence |
|---|---|
| Direct | One relevant check when practical |
| MVP | Build/smoke, core happy path, and 1–3 named risk checks |
| Deep | The risk-specific release checks defined before implementation |

Do not rerun an unchanged check merely for reassurance. If evidence is missing, state the limitation and hand off to the user rather than attempting endless self-verification.
