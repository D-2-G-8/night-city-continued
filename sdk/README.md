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
