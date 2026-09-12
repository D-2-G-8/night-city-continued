---
name: license-audit
description: Audit licenses and attribution across recipes and dependencies, resolve ScanCode findings and regenerate THIRD_PARTY.md. Use before a release, when adding a dependency, or when a license check fails in CI.
shell: powershell
---

# License audit

A license mistake is the one failure mode that can end this project: a takedown plus the
loss of trust from the exact modders we want to bring in.

## Run the audit

```powershell
scancode --license --copyright --json-pp .\out\scancode.json .\recipes
dotnet run --project sdk/Validator -- validate recipes
```

Delegate noisy output to the `license-reviewer` subagent.

## Resolve findings

For each recipe, check that:

- the detected SPDX id matches `license.spdx` in the recipe;
- the author's LICENSE file travels with any `included` files;
- attribution is present in the recipe, `THIRD_PARTY.md`, the launcher and the
  contributors page;
- nothing was relicensed under our MIT;
- any `included` mod without an allowlist license has a permission document in
  `governance/permissions/<id>.md`, with link, date and scope.

Ambiguity is not a tie-break in our favour. Drop the tier and ask the author.

## Also check

- New .NET and tooling dependencies: license compatible and recorded in `THIRD_PARTY.md`
- No extracted game assets shipped as standalone files
- Every content pack declares a license and authors

## Output

Regenerate `THIRD_PARTY.md` from recipes and dependencies. Report anything unresolved as
a blocking issue, not a footnote.
