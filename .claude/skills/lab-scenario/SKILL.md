---
name: lab-scenario
description: Write or update a test-lab scenario or pack point so a change is actually exercised in-game. Use when adding a module, pack or recipe, or when a change has no lab coverage.
paths: lab/**,content/**,recipes/**
---

# Write a lab scenario

A change the lab cannot see is a change nobody verified. Every module, pack and recipe
declares at least one scenario or point.

## Two kinds of coverage

**Points** (packs) — a place to stand and look, declared in `pack.json`:

```json
{ "id": "pilot_entrance", "pos": [0.0, 0.0, 0.0], "yaw": 0, "time": "22:00" }
```

**Scenarios** (modules, recipes, systems) — a short sequence in
`lab/scenarios/<name>.json`: load a golden save, teleport, set time and weather, wait for
streaming, signal, capture.

## Rules

- **Deterministic.** Fixed save, fixed time, fixed weather, fixed position. A scenario that
  varies run to run produces screenshot diffs nobody can interpret, and then the whole
  report gets ignored.
- **Short.** PR runs are serialised on one GPU. Seconds, not minutes.
- **Wait for streaming** before capturing, or you will screenshot a half-loaded world and
  file a bug against yourself.
- **Capture what the change touches**, not a generic city view.
- For agent or `brain` changes, cover the simulation metrics run as well as visuals.

## Register it

Reference the scenario in the module's `module.json`, the recipe's `lab.scenarios` or the
pack's `lab.points`, then validate:

```powershell
dotnet run --project sdk/Validator -- validate <path>
```
