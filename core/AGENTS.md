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

1. `dataVersion` bumped in the release manifest and in `core`
2. A step migration (5→6→7, never a jump)
3. Golden saves in `tests/golden-saves/` loading and continuing
4. A lab scenario covering the migration

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

## Conventions

- Fact namespace: `ncc_` for core, `ncc_<module>_` for modules, `ncc_pack_<id>_` for packs.
- Every core feature must be disableable without breaking a save.
- Modules talk to core only through the public API — never reach into internals.
