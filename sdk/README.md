# sdk/

What third-party pack and recipe authors need, and what CI validates against.

| Path | Contents |
|---|---|
| `schemas/` | JSON Schema for `ncc-pack/1`, `ncc-recipe/1`, `module.json`, the release manifest, `brain api/v1` and lab scenarios |
| `templates/` | Starting points for a content pack and a recipe |
| `Validator/` | .NET CLI that validates a pack, recipe, module or manifest |

Run it locally before opening a PR — CI runs the same check:

```powershell
dotnet run --project sdk/Validator -- validate content/districts/<name>
dotnet run --project sdk/Validator -- validate recipes/<mod-id>
```

Schemas are versioned independently of releases. A pack built against `/1` keeps working
on every release that still supports `/1`; support is dropped no sooner than one major
release after it is marked deprecated.

That promise is the answer to a real fear: modders have watched frameworks refactor out from
under them and split their communities. Say it plainly in author-facing documentation rather
than leaving it in the tech doc.

## What the validator must catch

- Schema conformance for packs, recipes, modules and manifests.
- **Declared conflicts:** two packs claiming the same vanilla node (`claimsVanillaNodes`).
- **Actual conflicts:** two components touching the same resource without either declaring
  it. The registry only catches components that are honest about what they touch, and
  third-party mods in recipes do not know the registry exists. Detection has to run against
  built artifacts, not manifests alone.
- **Permission consistency** (ADR-010): patches present with `modify` not `allowed`, tier
  `included` with `redistribute` not `allowed`, a `checkedOn` date older than a release cycle.
- A missing lab scenario or point on any pack, module or recipe.
- A module that depends on a `linked` recipe without declaring what it does when that recipe
  is unavailable (ADR-009).
- A pack declaring agent movement inside a custom interior while ADR-021 is unresolved.

## Cost of entry is a metric

Version and dependency problems are the largest single category of technical obstacle
reported by mod developers, and every framework we add spends some of an author's patience.
Track **how many steps stand between a new contributor and their first green lab run**, and
treat a rise in that number as a regression in the SDK.
