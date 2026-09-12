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
- [ ] Save data: unchanged, **or** a named migration written, golden saves loading, and an
      `on-removed` path if the component can be uninstalled (ADR-013)
- [ ] The module, pack or recipe can be disabled without breaking a save
- [ ] Patch notes and docs updated
- [ ] License and attribution preserved

## Checks that apply here

- [ ] No third-party mod files were copied in outside the recipe system
- [ ] Recipe permissions checked and dated; no patches shipped where `modify` is not
      `allowed` (ADR-010)
- [ ] Nothing depends on an agent pathing inside a custom interior (ADR-021 is Proposed,
      not decided)
- [ ] No NPC behaviour was scripted — no schedules, behaviour trees, developer-set goals or
      action whitelists (ADR-008). World events are fine; steering a decision is not (ADR-015)
- [ ] `deps.lock.md` untouched, **or** this PR exists specifically to bump it (full regression)
- [ ] No lab threshold was raised to make a run go green
- [ ] Nothing was put behind money
- [ ] English throughout, and file names are lowercase kebab-case ASCII
      (`docs/guides/conventions.md`)

## Needs an RFC?

Core API, any schema, `dataVersion`, a new module, a system mechanic, or anything in
`governance/` needs an accepted RFC before merge.

- [ ] Not applicable
- [ ] RFC accepted: <!-- link -->
