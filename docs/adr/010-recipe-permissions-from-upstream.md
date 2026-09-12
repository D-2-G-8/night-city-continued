# ADR-010: Recipe tiers follow upstream permissions, not the license alone

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** E — Ecosystem
- **Extends:** ADR-005 (recipes, not copies)

## Context

ADR-005 picks a recipe's tier from its license: a license in the allowlist, or written
permission, makes a mod eligible for `included`; otherwise it is `linked` or `compat`.

That is only half of what authors actually grant. Nexus Mods — where most of this ecosystem
lives — lets an author set several permissions **independently**, and a permissive stance on
one says nothing about the others. Wabbajack, which faced the same problem, does not invent
its own tiers: it reads the upstream fields and refuses the operations they forbid.

| Upstream permission | What it governs |
|---|---|
| Upload | whether the files may be hosted anywhere but the author's own page |
| **Modification** | **whether the files may be altered, patched or unpacked** |
| Conversion | whether the mod may be ported to another game version |
| Asset use | whether the mod's assets may be reused elsewhere |

Our recipes carry `patches/` at every tier, including `linked`. **A patch is a
modification.** A mod can be freely downloadable, which makes it `linked` under ADR-005,
while its author has explicitly forbidden modification — and we would still be applying our
compatibility patch to it on the player's machine.

Applying a patch locally is not redistribution, and it is exactly the behaviour Skyrim
authors objected to when Wabbajack's binary patching routed around their stated "no
modifications" setting.

## Decision

**A recipe records upstream permissions as data, and the validator derives what we are
allowed to do from them.**

`recipe.yaml` gains a `permissions` block:

```yaml
permissions:
  redistribute: denied      # allowed | denied | unknown
  modify: denied
  convert: unknown
  assets: denied
  source: "https://www.nexusmods.com/cyberpunk2077/mods/<id>?tab=permissions"
  checkedOn: 2026-09-12
  checkedBy: "<maintainer>"
```

Derived rules, enforced by the validator in CI:

| Operation | Requires |
|---|---|
| Tier `included` | `redistribute: allowed`, via the license allowlist or a permission document |
| Shipping anything in `patches/` | `modify: allowed` |
| Unpacking or repacking upstream archives | `modify: allowed` |
| A recipe for a mod ported to another game patch | `convert: allowed` |
| Reusing a mod's assets in our content | `assets: allowed` |

**`unknown` is treated as `denied`** for every operation above. A permission nobody checked
is not a permission.

A mod whose author forbids modification can still be `linked`: we pin it, verify its hash,
send the player to the author's page, and declare lab scenarios for it. What we cannot do is
patch it. Where a patch would be required to make it work, the recipe becomes `compat` and
the incompatibility is recorded publicly, with the reason.

The escape hatch is the normal one: ask the author, and record the answer in
`governance/permissions/<mod-id>.md`.

## Consequences

- Some mods that ADR-005 alone would have placed at `linked` land at `compat` instead. This
  shrinks what the distribution can promise and keeps it inside what authors actually allowed.
- Adding a recipe now requires reading the author's permissions page, not just identifying a
  license. `checkedOn` and `checkedBy` make that a dated, attributable act.
- Permissions change. `checkedOn` ages, and CI warns when it is older than a release cycle.
- `unknown` defaulting to denied means a mod with no stated permissions is maximally
  restricted. That is the correct reading of copyright law and the conservative one for us.
- Our patches become a privilege rather than a given, which raises the value of getting them
  merged upstream. Rule 4 in `recipes/AGENTS.md` already requires offering them upstream.
- The permission fields are transcribed by a human from a page we do not control. They can be
  transcribed wrongly. `source` makes every claim checkable by anyone, including the author.

## Alternatives considered

- **Infer everything from the license.** What ADR-005 did alone. Works for mods that carry a
  real license and misreads the majority of Nexus mods, which carry permission settings
  instead.
- **Ask every author individually before any recipe.** Safest and does not scale; it also
  blocks `compat`, which exists precisely so that unreachable authors are not a dead end.
- **Treat local patching as outside the author's permissions**, on the grounds that nothing
  is redistributed. Defensible legally and against the plain intent of an author who wrote
  "no modifications". The project does not need that argument.
