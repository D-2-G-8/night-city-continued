# lab/scenarios/

Scenario definitions the harness executes, as JSON validated against the SDK schema.

`smoke` is the one that always runs: the game reached the main menu, the golden save loaded,
60 seconds in the city without a crash.

Everything else is selected from the diff — a changed pack brings its `lab.points`, a changed
module or recipe brings its `lab.scenarios`. Every pack, module and recipe must declare at
least one scenario or point, otherwise its change ships untested.

## Shape of a scenario

A scenario is a list of **self-contained steps** plus a **relaunch budget** (ADR-012). Each
step loads what it needs — save, position, time of day — and waits for streaming before it
signals ready. A step that assumes the previous step left the game in some state cannot be
resumed into after a crash, and the schema rejects it.

## Scenarios that must exist

- `smoke` — main menu, golden save, 60 seconds in the city.
- **Crowd** — several agents active near the player at once. This is where comparable
  LLM-NPC systems fail first, so it is standing coverage rather than a later addition.
- **Degraded install** — a `linked` component unavailable, and one whose hash changed
  (ADR-009). Without it, that path is first exercised by a player.
- **Migration** — including uninstall and reinstall, not only linear upgrades (ADR-013).

## What a visual check looks for

Name the defect, not the pixels. Black faces, gaps at the neck, missing meshes or textures,
holes in a facade, an interior visible through a wall. A bare "SSIM changed" is noise, and
noise trains reviewers to ignore the report.
