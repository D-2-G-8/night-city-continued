---
name: new-recipe
description: Add or update a community mod in the distribution — determine its license tier, write recipe.yaml, declare lab coverage and open the PR. Use when integrating, updating or re-tiering any third-party mod.
paths: recipes/**
shell: powershell
---

# Add a mod as a recipe

Read `recipes/AGENTS.md` first. The legal rules there are not optional.

## 1. Identify the mod

Upstream URL, author, current version, where it is published (GitHub, Nexus, both).

## 2. Determine the tier — this decides everything else

```powershell
scancode --license --copyright --json-pp .\out\scancode.json .\path\to\mod
```

- License in the allowlist → `included`
- No license file, a license outside the allowlist, or Nexus permissions that forbid
  redistribution → `linked` (if free to download) or `compat`
- Written permission exists → `included`, recorded in `governance/permissions/<id>.md`

**A public repo with no license is not permission.** When in doubt, take the lower tier
and ask the author.

## 3. Write the recipe

Copy `sdk/templates/recipe.yaml` to `recipes/<id>/recipe.yaml`. Fill in `tier`, `upstream`
(url, ref, sha256), `license` (spdx, file, permission), `authors` with their Nexus and
donation links, `gamePatch`, `requires`, `lab.scenarios`.

For `included`: copy the files together with the author's LICENSE. Never edit their files
in place — changes go in `patches/` and get offered upstream.

## 4. Declare lab coverage

At least one scenario or point, so the lab actually exercises the mod. Use the
`lab-scenario` skill.

## 5. Validate and open the PR

```powershell
dotnet run --project sdk/Validator -- validate recipes/<id>
pwsh ./tools/build.ps1 -Target recipe:<id>
```

Branch `recipe/<id>`, commit `recipe(<id>): add at tier <tier>`.

## 6. Tell the author

Even for `linked` and `compat`. What we did, why, what it gives them — free lab runs,
compatibility reports when the game patches, a contributors page linking to their
donations — and that nothing is required of them. This step is outreach as much as
engineering.
