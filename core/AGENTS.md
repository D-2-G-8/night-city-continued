# core/ — agent rules

The platform's foundation: redscript API for modules, the fact system, save migrations,
the pack and recipe loader, and the action vocabulary in `core/verbs/`.

## Stability contract

`core-api/1` is a promise to every module, pack and recipe author. A pack built against
schema `/1` must keep working on every release that supports `/1`.

- Adding API: fine.
- Changing or removing API: needs an RFC, a deprecation notice, and support for at least
  one more major release.
- Core must never know about a specific district, story, module or mod. If you find yourself
  writing `if (district == "watson")` in core, the logic belongs in a pack or module.

## Save data — the rule that protects players

Any change to facts or persisted structures requires, in the same PR:

1. A **named migration** in `<component>/migrations/`, `NNNN-<slug>`
2. Golden saves in `tests/golden-saves/` loading and continuing
3. A lab scenario covering the migration
4. `dataVersion` bumped where the release-level compatibility marker moves

Migrations are named, not numbered (ADR-013). The save records which migrations it has had
applied, by fully qualified name, and never runs one twice. This is what survives a player
installing a module, removing it, and installing it again — which no single counter can
describe.

A component also declares `migrations/on-removed`, which runs when a save that used the
component is loaded without it. That is what makes "disableable without breaking a save"
implementable rather than aspirational.

**Identifiers are permanent once released.** Fact names, pack ids, module ids and verb names
are never renamed after they ship. A rename is a new identifier plus a migration that copies
the data and deprecates the old one.

Facts are never deleted. Mark them deprecated and keep reading them for at least one
major release. Removing a fact silently breaks saves that reference it.

## The action vocabulary (`core/verbs/`)

Each verb describes what an NPC body **can physically do** in the engine — arguments,
feasibility check, how the engine executes it, what result goes back to the agent.

A verb is a capability, not a permission. Never add limits, cooldowns or conditions whose
purpose is to stop an agent from choosing something. The only legitimate constraints are
physical: the engine cannot do it, or the agent lacks the resources.

Adding a verb is how this project grows — check `unmet_intents` for what agents actually
want to do but cannot.

## Game patches stop here (ADR-014)

`core-api/N` is a stable surface over an unstable one. When a game patch moves an engine
symbol, path or structure that core exposes, **core absorbs it and the public API keeps its
shape** — a module built against `core-api/1` is not expected to know a patch happened.

Patch-specific code paths in core are dated and removed one major release after the patch
they compensate for. Otherwise core silently accumulates permanent sediment.

## Conventions

- Fact namespace: `ncc_` for core, `ncc_<module>_` for modules, `ncc_pack_<id>_` for packs.
- Every core feature must be disableable without breaking a save.
- Modules talk to core only through the public API — never reach into internals.
