# ADR-003: Monorepo, SemVer per module, releases pinned by a manifest

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** P — Platform

## Context

The project is a core, several modules, content packs, recipes for third-party mods, a
launcher, an SDK and a test lab — and they all have to be consistent with each other at the
moment a release ships. A player installs one thing and gets a set of components that were
tested together.

A change to the core API can break three modules. A lab run has to test the combination, not
the pieces.

## Decision

**One repository** holding all of it.

**SemVer per module**, independent of the release number: `residents 1.2.0` can ship in
release `0.4.1`.

**A release is defined by its manifest** — `releases/X.Y.Z.json` lists exactly which module
and recipe versions it contains, which game patches it supports, and the hash of every file.
The manifest is signed; the launcher installs from it and nothing else.

Schemas are versioned separately from releases: `core-api/N`, `ncc-pack/N`, `ncc-recipe/N`,
`brain api: vN`. A pack built against `/1` keeps working on every release that supports `/1`,
and support is dropped no sooner than one major release after a deprecation notice.

## Consequences

- An atomic change across the core and three modules is one PR, one review, one lab run.
- The lab tests the real combination players receive.
- The repository will get large, especially with golden saves. Git LFS for `tests/golden-saves/`.
- Every contributor clones everything, including parts they will never touch.
- CI must build only what changed, or PR runs become unusable as the repo grows.
- An outside author who owns one recipe still works inside our repository rather than their
  own. CODEOWNERS gives them authority over their directory; it does not give them their own
  release cycle.

## Alternatives considered

- **A repository per module.** Better isolation for individual authors, and a much worse
  integration story: the combination only gets tested at release time, which is when it is
  most expensive to fix.
- **Submodules.** Rejected — the complexity lands on contributors, most of whom are modders
  rather than full-time engineers.
