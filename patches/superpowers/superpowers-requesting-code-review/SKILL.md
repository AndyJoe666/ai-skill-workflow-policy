---
name: requesting-code-review
description: Use when the user requests review or Deep-mode work has a named high-consequence risk that warrants an independent targeted review.
---

# Targeted Code Review

Review the changed behavior against the request and named risk. For normal MVP work, human acceptance is the default feedback loop; a formal code review is optional.

Use one review pass. Fix only findings that block the requested outcome, correctness, security, data integrity, or the stated release gate. Record non-blocking ideas for later; do not create a re-review loop unless a changed risk requires it.
