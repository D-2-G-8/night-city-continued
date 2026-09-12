# content/ — agent rules

Content packs: districts (`content/districts/`) and stories (`content/stories/`).

## Packs are data

A pack contains no code. It declares what it adds, and core loads it. This is what lets
outside authors ship content that CI can validate automatically — and it is the measure of
whether the platform actually works: a new district must ship without touching core.

Allowed: `pack.json`, world sectors, meshes, TweakXL YAML, questphase/scene files, agent
biographies, localisation.

## `pack.json` requirements

- `schema: ncc-pack/1`
- `factsNamespace` unique and prefixed `ncc_pack_<id>_`
- `claimsVanillaNodes` — every vanilla node the pack removes or replaces. The registry in
  `sdk/registry/nodes.json` rejects two packs claiming the same node. Skipping this is how
  you silently break someone else's location.
- `lab.points` — at least one, so the lab can see the pack
- `license` and `authors`

## Agent biographies

`agents/*.yaml` says **who a person is and where they came from** — background,
relationships, what they own. It never says what they will do. No schedules, no goals, no
routines: the agent decides. See `services/brain/AGENTS.md`.

## World editing

Follow the runbook in `docs/runbooks/facade-to-interior.md`. The parts most often missed:

- Copy a vanilla mesh to your own path before editing. Overwriting the original changes
  every building in the city that uses it.
- Removing the visible mesh is not enough — the collider and the occluders are separate nodes.
- New interiors have no navmesh. Design around workspots until that is solved.
