# launcher/ — agent rules

`ncc`, the .NET tool players use to install, update and roll back — like a game patch.
Console first; GUI later.

## Non-negotiable

- **Always verify the release manifest signature (minisign) and every file hash.**
  Never add a skip flag, a "dev mode" bypass, or a silent fallback on failure.
- **Always snapshot before writing**, and keep the last two installs for rollback.
- **Always back up saves before running a data migration.**
- **Refuse unknown game builds.** If the executable does not match a `compat` entry, block
  the install and say so plainly. A newer patch breaks native plugins; installing anyway
  makes the player's game unlaunchable.
- **Never auto-install over Vortex or MO2.** Detect them and switch to check-only mode.

## A missing `linked` mod degrades, it does not block (ADR-009)

Authors update files in place and take them down, and both change the hash. Neither is the
author's fault and neither may make a release uninstallable.

- Manifest entries carry `required: true | false`. `core`, modules and `included` recipes are
  required; `linked` recipes are not.
- If a `required: false` component cannot be fetched or its hash does not match, install
  everything else, record it as **unavailable**, and finish. Mark the install `degraded` and
  name what is missing and why.
- Accept a signed `releases/X.Y.Z.pins.json` addendum that updates `linked` refs and hashes,
  when its signature verifies, its release matches, and its `revision` is higher. Reject an
  addendum that contains anything but refs and hashes — it can never introduce a component.
- `ncc doctor` reports degraded components and what they disable.

**This is not a relaxation of hash checking.** A `required: false` component whose hash does
not match is not installed. It is never installed anyway.

## Player experience

Errors are read by people who did not write this code. Say what happened, what it means,
and what to do — with the game version, the missing dependency, or the conflicting file named.

`ncc logs --bundle` must collect everything a maintainer needs: redscript, CET and RED4ext
logs, installed versions, and the manifest.

## Respecting mod authors

For `linked` recipes the launcher opens the author's own download page and verifies the
file the player fetched. Never proxy, mirror or hotlink those files — the download must
count for the author. See `recipes/AGENTS.md`.

Never cache, mirror or retain a `linked` file to survive it disappearing upstream. An author
who removes their mod has exercised a right this project guarantees (ADR-011); keeping a copy
so our release keeps working is exactly what that guarantee forbids.

Attribution appears wherever a component is listed, including in the degraded-install report.

## Testing

The launcher is tested in cloud CI against a fake game directory: install, update, rollback,
unknown build, corrupted archive, revoked release, interrupted download, **a `linked`
component that is unavailable, one whose hash changed, and a pins addendum** — valid, stale
revision, wrong release, and one carrying fields it should not.
