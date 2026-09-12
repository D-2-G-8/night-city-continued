# recipes/ — agent rules

How community mods enter this project. **Read this before touching anything here.**

## The legal reality

Open source does not mean "no copyright". Code stays the author's; a license grants
specific permissions. Concretely:

- A public GitHub repo **without a license** grants no right to copy, distribute or modify it.
- Mods on Nexus are **not open source by default** — each author sets their own permissions,
  often "not allowed under any circumstances".
- Game assets inside a mod belong to CD Projekt Red, not the modder.

So we do not copy mods. We store **recipes**, the way a Linux distribution does.

## Three tiers

| Tier | Condition | What we store |
|---|---|---|
| `included` | License in the allowlist, or written permission in `governance/permissions/<id>.md` | Source/files with the author's LICENSE, attribution and our patches |
| `linked` | We may not redistribute, but the mod is free to download | Recipe only: upstream URL, hash, compatibility patches, lab scenarios |
| `compat` | Author declined or did not respond | A compatibility-table entry and a lab scenario. Nothing else |

Allowlist for `included`: MIT, BSD-2-Clause, BSD-3-Clause, Apache-2.0, MPL-2.0, ISC,
GPL-3.0, LGPL-3.0, CC BY 4.0, CC BY-SA 4.0 (non-code).

## Permissions are separate from the license (ADR-010)

A license is not the whole grant. Upstream platforms let authors set permissions
independently, and a permissive stance on one says nothing about the others. Record them in
`recipe.yaml`:

```yaml
permissions:
  redistribute: denied      # allowed | denied | unknown
  modify: denied
  convert: unknown
  assets: denied
  source: "<link to the page that says so>"
  checkedOn: 2026-09-12
  checkedBy: "<maintainer>"
```

| To do this | You need |
|---|---|
| Tier `included` | `redistribute: allowed` |
| **Ship anything in `patches/`** | **`modify: allowed`** |
| Unpack or repack upstream archives | `modify: allowed` |
| Recipe for a mod ported to another game patch | `convert: allowed` |
| Reuse the mod's assets in our content | `assets: allowed` |

**`unknown` counts as `denied`.** A permission nobody checked is not a permission.

A mod whose author forbids modification can still be `linked` — pinned, hash-verified, with
lab scenarios. It just cannot carry our patches. If it needs a patch to work, it is `compat`,
and the reason is recorded publicly.

## Authors can leave (ADR-011)

An author may have their mod removed at any tier, including `compat`, at any time, without
giving a reason. No review, no appeal, no negotiation, and we keep no archival copy to keep a
release installable.

Removed from `dev` the next working day and from the next release. Record the withdrawal in
`governance/permissions/<mod-id>.md` next to any earlier grant, with its date, so the next
person to touch the recipe does not reopen it.

## Upstream files move (ADR-009)

Authors update files in place and take them down. Both change the hash, and neither is a
problem with the author.

- `linked` entries are `required: false` in the release manifest. The launcher installs
  everything else and reports the gap.
- Re-pinning a `linked` recipe is a signed `releases/X.Y.Z.pins.json` addendum, not a new
  release.
- CI re-checks `linked` upstreams on a schedule and opens an issue when one stops matching.

## Rules

1. **No license detected → cannot be `included`.** CI blocks it. Ask the author instead.
2. **Never relicense.** The author's license travels with their files. Our MIT does not apply to them.
3. **Attribution everywhere:** recipe, `THIRD_PARTY.md`, launcher, contributors page.
4. **Our changes are patches**, in `patches/`, and they get offered upstream. Record the PR link.
5. **Permission is a document**, not a memory: `governance/permissions/<id>.md` with a link
   to the message, the date, and exactly what was granted.
6. **Protect the author's income.** Moving here never requires leaving Nexus, changing a
   license, or giving up their donation links. For `linked` mods the launcher sends the
   player to the author's page so the download counts for them. Never route around that.
7. **Authors control their own recipe.** They may downgrade a tier or remove it at any time,
   without giving a reason. See ADR-011 and `governance/author-rights.md`.
8. **Check permissions, not just the license**, and date the check. See ADR-010.
9. **An author declining is never a reason to build our own version of their mod.** `compat`
   needs nothing from them, so a refusal never blocks compatibility testing. The narrow cases
   where we do build something overlapping, and the rules that apply then, are in ADR-022.

## Workflow

Branch `recipe/<mod-id>`, run the `new-recipe` skill, validate locally:

```powershell
dotnet run --project sdk/Validator -- validate recipes/<id>
scancode --license --copyright --json-pp .\out\scancode.json .\recipes\<id>
```

Every recipe declares at least one lab scenario or point.
