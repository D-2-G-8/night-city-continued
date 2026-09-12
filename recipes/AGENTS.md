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
7. **Authors control their own recipe.** They may downgrade a tier or remove it at any time.

## Workflow

Branch `recipe/<mod-id>`, run the `new-recipe` skill, validate locally:

```powershell
dotnet run --project sdk/Validator -- validate recipes/<id>
scancode --license --copyright --json-pp .\out\scancode.json .\recipes\<id>
```

Every recipe declares at least one lab scenario or point.
