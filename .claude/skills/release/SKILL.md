---
name: release
description: Run the release train — freeze, manifest, signing, patch notes and publication. Invoke manually when cutting a beta or stable release.
disable-model-invocation: true
shell: powershell
---

# Release train

Never start this automatically. A release is a deliberate act.

## 1. Freeze

Branch `release/X.Y` from `dev`. Whatever is not in is not in — it rides the next train.

## 2. Verify

- Nightly full regression green on this revision
- Golden saves from every supported release load and continue
- License audit green, `THIRD_PARTY.md` current
- Compatibility with cyberpunk-vr-port, the Logitech wheel mod and AMM checked
- `deps.lock.md` unchanged since the last regression

## 3. Build and sign

```powershell
pwsh ./tools/release.ps1 -Release X.Y.Z -Channel beta
```

Produces `releases/X.Y.Z.json` with modules, recipes, `compat`, `dataVersion` and file
hashes, signed with minisign.

## 4. Patch notes — write them for players

Generate a draft from Conventional Commits, then rewrite it in human language. CD Projekt's
own patch notes are the model.

- ✅ "Residents of the pilot district now remember if you didn't pay them."
- ❌ "fix(brain): memory key collision in resident store"

Credit mod authors by name for anything coming from their recipes.

## 5. Publish

Beta → GitHub pre-release, two weeks. Stable → GitHub Release, then Nexus and a new
collection revision. Keep a 72-hour hotfix window for blockers.

## 6. After

Merge `release/X.Y` back into `dev`, tag `release-X.Y.Z`, update the roadmap and the
"What's new" screen.

## Rollback

If a release is bad, mark its manifest `"status": "revoked"` so the launcher offers a
rollback, then fix it on a `hotfix/X.Y.Z` branch. Never silently replace published files —
players have already verified those hashes.
