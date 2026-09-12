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

## Player experience

Errors are read by people who did not write this code. Say what happened, what it means,
and what to do — with the game version, the missing dependency, or the conflicting file named.

`ncc logs --bundle` must collect everything a maintainer needs: redscript, CET and RED4ext
logs, installed versions, and the manifest.

## Respecting mod authors

For `linked` recipes the launcher opens the author's own download page and verifies the
file the player fetched. Never proxy, mirror or hotlink those files — the download must
count for the author. See `recipes/AGENTS.md`.

## Testing

The launcher is tested in cloud CI against a fake game directory: install, update, rollback,
unknown build, corrupted archive, revoked release, interrupted download.
