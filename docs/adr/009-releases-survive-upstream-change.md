# ADR-009: A release survives an upstream file changing or disappearing

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** P — Platform
- **Extends:** ADR-003 (signed release manifest), ADR-005 (recipes, not copies)

## Context

ADR-003 makes a release a signed, immutable manifest with the hash of every file. ADR-005
means `linked` components are not our files: the player fetches them from the author's page,
and the manifest pins them by `sha256`.

These two decisions interact badly, and the interaction is not hypothetical. Wabbajack — the
closest existing system to ours — documents the result:

> Links break when mod authors update files, delete resources or take them down for
> maintenance, altering the required cryptographic hash. When a mod is unavailable, the
> modlist cannot be installed until its author recompiles it without that mod.

Two ordinary, entirely legitimate author actions — **updating a file in place** and
**taking a mod down** — make a published release uninstallable. Not degraded: uninstallable.
The author has done nothing wrong, and under ADR-005 they are explicitly entitled to do both.

Without a decision here, the fix for every such event is cutting and signing a new release,
which means a release's lifetime is bounded by the most volatile third party in it.

## Decision

**A `linked` component is optional at install time. Its absence degrades a release; it never
blocks one.**

Three mechanisms:

### 1. Components are classified in the manifest

Every entry carries `required: true | false`.

- `core`, modules, and `included` recipes are `required: true` — they are our own release
  artifacts and cannot vanish.
- `linked` recipes are `required: false`.

If a `required: false` component cannot be fetched or its hash does not match, `ncc`
installs everything else, records the component as **unavailable**, and completes. The
install is marked `degraded` and names what is missing and why.

### 2. Pins can be updated without re-cutting the release

`releases/X.Y.Z.pins.json` is a signed addendum carrying only upstream refs and hashes for
`linked` recipes, plus a monotonically increasing `revision`.

The launcher accepts an addendum when its signature verifies, its `release` matches the
installed release, and its `revision` is higher than the one it already has. The release
manifest itself stays immutable and its signature stays valid.

An author publishing version 1.4.3 of their mod is therefore a pins update, not a release.

### 3. Unavailability is visible before it bites

- `ncc doctor` reports degraded components and what they disable.
- CI re-checks every `linked` upstream on a schedule and opens an issue when a hash stops
  matching or a URL stops resolving.
- The public compatibility table records the component as unavailable, with the date.

## Consequences

- A player installing an older release gets a working game with a named gap, instead of a
  failed install with a hash error.
- `required: false` means a release's behaviour depends on what was reachable at install
  time. Two players on the same release version may have different component sets, and bug
  reports must therefore carry `ncc doctor` output. The issue template already requires it.
- Modules that depend on an unavailable `linked` recipe must degrade rather than fail. A
  module declaring a `linked` recipe in `requires` needs a stated behaviour for its absence,
  and the validator enforces that the field exists.
- The signing key is now used for two artifact types. The pins addendum is a strictly
  narrower document — refs and hashes only — and the launcher rejects an addendum containing
  anything else, so a compromised pins file cannot introduce a component.
- Scheduled upstream re-checks make outbound network requests to authors' hosts on a timer.
  Keep the interval polite and the user agent identifying.
- The lab needs a scenario where a `linked` component is unavailable. Without it, the
  degraded path is never exercised until a player finds it.

## Alternatives considered

- **Mirror `linked` files so they cannot vanish.** Directly contradicts ADR-005 and removes
  the author's download. This is the choice Nexus made for Collections, and it cost them
  authors (see ADR-011).
- **Accept any hash for `linked` components.** Removes the failure and also removes the
  integrity check, which is the thing protecting a player from a substituted file.
- **Cut a new release whenever an upstream file changes.** Correct but unaffordable: release
  cadence would be driven by every third-party author's upload schedule.
- **Pin to a range of known-good hashes.** Helps with in-place updates and does nothing for
  removal. The pins addendum covers both.
