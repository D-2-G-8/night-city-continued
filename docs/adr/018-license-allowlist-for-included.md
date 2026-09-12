# ADR-018: License allowlist for the `included` tier

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** E — Ecosystem
- **Extends:** ADR-005 (recipes, not copies), ADR-010 (permissions)

## Context

A mod reaches the `included` tier — where the project ships the author's files as part of a
release — when its license permits redistribution, or when the author has given written
permission. CI blocks the tier otherwise, so the allowlist is a gate that runs on every pull
request and has to be unambiguous.

Two licence families need conditions rather than a yes or no. Copyleft licences permit
redistribution and attach obligations that travel. Share-alike content licences do the same
for assets. Listing them as bare SPDX identifiers would record the permission and lose the
obligation.

## Decision

### Allowed unconditionally

MIT, MIT-0, BSD-2-Clause, BSD-3-Clause, Apache-2.0, ISC, 0BSD, MPL-2.0, CC0-1.0, Unlicense.

For non-code assets: CC-BY-4.0.

### Allowed with conditions

**GPL-3.0, LGPL-3.0** — permitted for mods shipped as **separate artifacts**, which is mere
aggregation. **Our own code never links against them.** The platform is MIT, and linking core
to a copyleft component would propagate obligations onto the platform. The validator records
the condition; a proposal to link core against a GPL component needs an RFC and will be
refused.

**CC-BY-SA-4.0** (non-code) — permitted while we ship the assets as the author released them.
The moment we create a derivative asset, share-alike applies to that derivative and it must
be released on the same terms. Creating derivatives of CC-BY-SA assets is therefore a
deliberate act, recorded in the recipe, not a side effect of content work.

### Never allowed at any tier

- **Any `-NC` (non-commercial) licence.** Not because the project earns anything, but because
  "non-commercial" is contested territory next to donations and fiscal hosting, and the
  project does not need an argument it can avoid by declining the mod.
- **Any `-ND` (no-derivatives) licence.** Incompatible with compatibility patches, and
  ambiguous about packaging.
- **No licence at all.** A public repository without a licence grants nothing. This is not an
  omission to be interpreted generously.

### Interaction with permissions

The allowlist decides what the **licence** permits. ADR-010 decides what the **author's stated
permissions** permit, separately, and both must pass. A permissively licensed mod whose author
has set "no modification" still cannot carry our patches.

Written permission in `governance/permissions/<mod-id>.md` substitutes for a licence on the
allowlist, and only for the scope the author actually granted.

## Consequences

- The gate is mechanical: CI can decide the licence half of tier eligibility without a human,
  and the human question becomes "did we read the permissions right".
- Adding the strictly-permissive licences (CC0, Unlicense, 0BSD, MIT-0) costs nothing and
  removes false blocks on mods that are more permissive than MIT.
- The GPL condition means a genuinely useful GPL library can never become part of core. That
  is a real limit, accepted so that the platform's own licence stays simple for everyone
  building on it.
- Excluding NC licences will occasionally exclude a mod whose author meant nothing more than
  "don't sell it" — which is also our position. The remedy is to ask for written permission,
  which the author can give in a sentence.
- `THIRD_PARTY.md` must carry the conditions, not only the identifiers. A reader needs to see
  that a GPL component is aggregated rather than linked.

## Alternatives considered

- **Permissive licences only.** Simplest, and it excludes GPL mods that are legitimately
  redistributable, shrinking the distribution for a problem that a stated condition solves.
- **Accept any licence permitting redistribution, obligations handled case by case.** Moves
  the decision from CI to a human on every pull request, which is where this kind of rule
  quietly stops being applied.
- **Allow NC licences since the project is free.** Would be arguing about what "commercial"
  means, in public, with a fiscal host involved. Declining is cheaper.
