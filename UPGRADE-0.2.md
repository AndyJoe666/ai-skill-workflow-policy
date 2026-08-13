# Upgrade to v0.2

## What changed

- Added `skill-security-auditor` and a read-only static scanner for candidate Skill capability signals.
- Added `-InstallMode Link` to `install-policy.ps1` for directory-junction installation from a local Git clone.
- Kept copy installation as the default for compatibility and for devices with existing local policy folders.

## New-device setup

1. Clone a reviewed revision of this repository into a normal user-owned directory.
2. Run the link installer from the clone:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-policy.ps1 -InstallMode Link
```

3. Merge `OPERATING-MANUAL.md` into the device's global `AGENTS.md` without removing local instructions.
4. Restart Codex or start a new task, then confirm that the four policy Skills appear.

## Existing-device migration

The installer does not overwrite a normal directory in link mode. This is intentional. For each of the four policy Skills, choose one:

- Keep `-InstallMode Copy` and update with the installer after reviewing a repository revision.
- Back up or move only the confirmed policy Skill folder, then rerun with `-InstallMode Link`.

Do not migrate vendor, `.system`, or plugin-cache Skills by moving their directories. Preserve them and use the compatibility registry instead.

## Regular updates

1. Fetch and inspect the desired repository revision.
2. Before accepting a new external Skill, run the security scan, then the workflow-cost audit.
3. For linked installs, check out the reviewed revision. For copied installs, rerun the installer.
4. Perform one normal MVP task and provide human acceptance feedback before treating a policy change as settled.

## Versioning

`POLICY-VERSION.json` identifies the package format and managed Skill set. Create a Git tag for each reviewed release; a device can remain on an earlier tag or commit when a newer policy revision needs more evaluation.
