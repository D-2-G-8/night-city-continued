# ADR-013: Save migrations are named, recorded in the save, and idempotent

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** P — Platform
- **Extends:** ADR-003 (versioning), ADR-004 (content is data)

## Context

The design so far carries a single integer `dataVersion` per release, with step migrations
(5→6→7, never a jump) and golden saves proving they work.

That is sufficient when every player runs the same set of modules. No player will. Modules
are independently versioned, packs and recipes are optional, and players add and remove them
in whatever order they like. A single counter cannot describe the state of a save where
`residents` was installed at release 0.4, removed at 0.6, and reinstalled at 0.9 — and
"re-run everything from 5 to 7" will corrupt data the second time it touches it.

Factorio, which has shipped a heavily modded game for over a decade, solves this with three
properties worth copying:

- migrations are **named files** in the mod, not a version number;
- each save **records by name** which migrations of which mods it has already had applied,
  and never applies the same one twice;
- adding a mod to an existing save runs all of that mod's migrations, and the engine raises a
  configuration-changed event when the game version, any mod version, or the **set of
  installed mods** changes — including removal.

Its documentation also states the rule that avoids most migrations entirely: do not rename
identifiers after publishing.

## Decision

**The unit of migration is a named migration, not a version number.**

1. A migration is a file under `<component>/migrations/`, named
   `NNNN-<slug>` where `NNNN` orders it within its own component.
2. **The save records applied migrations by their fully qualified name**
   (`<component>:<NNNN-slug>`). A migration already recorded is never run again, whatever
   the version numbers say.
3. Installing a component into an existing save runs every migration that component has, in
   order, that the save does not already record.
4. **Removal is an event.** A component declares `migrations/on-removed`, which runs when the
   component is no longer present and a save that used it is loaded. This is what makes
   "disableable without breaking a save" — already in the Definition of Done — something a
   component can actually implement.
5. `dataVersion` is kept, with a narrowed job: it is the **release-level compatibility
   marker** the launcher uses to decide whether to back up saves and which releases can
   interoperate. It no longer drives what runs.
6. **Identifiers are permanent once released.** Fact names, pack ids, module ids and verb
   names are not renamed after they ship. A rename is a new identifier plus a migration that
   copies the data and deprecates the old one.

Facts keep their existing protection: never deleted, marked deprecated, still read for at
least one major release.

## Consequences

- A save carries an accurate account of what happened to it, and that account is inspectable.
  `ncc logs --bundle` can include it, which turns a class of "my save is broken" reports into
  a readable list.
- Migrations must be genuinely idempotent in practice, because the recording is a safety net
  rather than a guarantee — a save restored from a backup can lose the record.
- The record grows with every migration ever applied. It is small text, and it is the
  cheapest part of a save.
- Golden saves must cover uninstall and reinstall paths, not only linear upgrades. That is
  more golden saves and more nightly lab time.
- Writing `on-removed` for a component whose data is entangled with another component's is
  genuinely hard, and the difficulty is a signal the two should not have been entangled.
- The no-rename rule will feel restrictive early, when names are still bad. It is cheaper
  than the alternative, and a rename remains possible with a migration.

## Alternatives considered

- **Keep the single integer.** Works only for a single linear upgrade path, which is not the
  situation any modded game is in.
- **Version per component, no names.** Better than one counter, and still cannot express "was
  removed and came back" or distinguish two different changes that shipped in one version.
- **Reconstruct state at load instead of migrating.** Avoids migrations and requires every
  reader to understand every historical layout forever.
