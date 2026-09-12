# modules/

Feature modules: `residents/`, `narrative/`, `phone/`, `systems/<name>/`.

A module talks to the game only through the public core API (`core-api/N`) and declares
itself in `module.json`: version, required core range, what it provides, its facts
namespace, its save `dataVersion` range and its lab scenarios.

Rules:

- A module must be disableable without breaking an existing save.
- A module that writes save data needs a `dataVersion` bump and a migration.
- A module never hardcodes NPC behaviour. It extends what agents *can* do — see
  `services/brain/AGENTS.md` and ADR-008.
