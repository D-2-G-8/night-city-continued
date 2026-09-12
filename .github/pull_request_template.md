## What this changes

<!-- One or two sentences. Link the issue or RFC. -->

Closes #

## Type

- [ ] Feature (`feat`)
- [ ] Fix (`fix`)
- [ ] Recipe — adding or updating a community mod (`recipe`)
- [ ] Documentation (`docs`)
- [ ] Spike / research (`research`)

## Lab coverage

<!-- Which scenarios or points exercise this. Every pack, module and recipe declares at
     least one. "None" needs a reason. -->

## Definition of Done

- [ ] Cloud CI green: build, schemas, vanilla-node registry, license audit
- [ ] Lab: declared scenarios passed, report attached
- [ ] No new errors in the redscript, CET or RED4ext logs
- [ ] Save data: unchanged, **or** `dataVersion` bumped with a migration and golden saves loading
- [ ] The module, pack or recipe can be disabled without breaking a save
- [ ] Patch notes and docs updated
- [ ] License and attribution preserved

## Checks that apply here

- [ ] No third-party mod files were copied in outside the recipe system
- [ ] No NPC behaviour was scripted — no schedules, behaviour trees, developer-set goals or
      action whitelists (ADR-008)
- [ ] `deps.lock.md` untouched, **or** this PR exists specifically to bump it (full regression)
- [ ] No lab threshold was raised to make a run go green
- [ ] Nothing was put behind money

## Needs an RFC?

Core API, any schema, `dataVersion`, a new module, a system mechanic, or anything in
`governance/` needs an accepted RFC before merge.

- [ ] Not applicable
- [ ] RFC accepted: <!-- link -->
