# ADR-005: Third-party mods are distributed as recipes, never as copies

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** E — Ecosystem

## Context

The project is a distribution: a player should be able to install one thing and get a curated,
tested set of community mods. The obvious implementation — vendor every mod into the
repository — is not legally available, and would damage the thing the project depends on most.

The facts that constrain this:

- **Open source does not mean "no copyright".** A license is permission on stated terms.
- **A public repository with no license grants no rights at all** — not to copy, not to
  redistribute, not to make derivative works.
- **Mods on Nexus are not open source by default.** Each author sets their own permissions,
  and "not under any circumstances" is a common setting.
- **Game assets inside a mod belong to CD Projekt Red**, not to the mod's author, so the
  author could not grant us rights to them even if they wanted to.
- Authors' downloads on their own pages are how they earn reputation and donations. A
  distribution that mirrors their files takes that away.

## Decision

**The repository stores recipes, not copies.**

A recipe (`recipes/<mod-id>/recipe.yaml`) records the upstream source, a pinned ref, a
SHA-256, the license, the author and their links (including donations), our compatibility
patches, and the lab scenarios that prove it works.

Files land in the repository **only** when the license permits it, or when the author has
given written permission recorded in `governance/permissions/<mod-id>.md`.

Three tiers:

| Tier | Condition | What we store |
|---|---|---|
| `included` | License from the allowlist, or written permission | The files, with the author's LICENSE and attribution |
| `linked` | Not redistributable, but free to download | The recipe only |
| `compat` | Author declined, or never answered | A compatibility entry and a lab scenario |

Rules that follow: relicensing is forbidden; attribution travels with the files; our changes
are patches proposed upstream; a recipe with no recognised license cannot be `included` and
CI blocks it; extracted game assets are never redistributed on their own.

## Consequences

- Installing is slower for `linked` mods: the launcher opens the author's page, waits for the
  file, checks the hash. The download counts for the author, which is what this tier exists to
  preserve.
- The launcher has to handle a semi-manual install path, which is real work and real support
  burden.
- An author can drop their tier or delete their recipe at any time, and a release can lose a
  component. Accepted — authors keep control.
- The license audit (ScanCode) becomes a merge gate, which will occasionally block a
  legitimate mod because its license text is unusual. A permission file is the escape hatch.
- We can never promise a player "one click installs everything".

## Alternatives considered

- **Vendor everything and ask forgiveness.** Rejected: it is copyright infringement, it
  violates Nexus rules, and it would make the project an adversary of the people it exists
  to support.
- **Only include permissively licensed mods.** Too narrow — most of the ecosystem is not
  permissively licensed, and `linked` and `compat` let the lab and the launcher still be
  useful for those mods.
