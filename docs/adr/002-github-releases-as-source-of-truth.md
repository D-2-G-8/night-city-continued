# ADR-002: GitHub Releases is the distribution source of truth; Nexus is a mirror

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** P — Platform

## Context

The launcher has to fetch release manifests and files automatically, verify a signature and a
hash, and be able to roll back to a previous release. That requires a host with stable,
scriptable, unauthenticated downloads.

Nexus Mods is where the Cyberpunk 2077 modding audience actually is. Its API terms for direct
downloads, however, appear to be restricted for free accounts [verify]. A launcher that
depends on an API the average user cannot use is not a launcher.

## Decision

**GitHub Releases is the source of truth** for the launcher, the SDK and release manifests.
Every release is published there first, with its signed manifest.

**Nexus is a mirror and a storefront:** the project's own modules, a Vortex collection, and
the page most players will discover the project through. Third-party mods stay on their
authors' own Nexus pages and are never mirrored by us.

## Consequences

- The launcher has one code path for downloads, and it works for everyone without an account
  or an API key.
- Publishing happens twice — automated to GitHub on a `release-*` tag, manual to Nexus. The
  manual step can drift, so patch notes must name the release version explicitly.
- Discovery suffers relative to Nexus-first projects. The Vortex collection and the Nexus
  page are the mitigation.
- For `linked`-tier mods the launcher deliberately sends the player to the author's Nexus
  page instead of downloading the file itself. This is slower for the player and it is the
  point: **the download counts for the author.**

## Alternatives considered

- **Nexus as the source of truth.** Rejected on the API terms, and because it would put us in
  the position of hosting other authors' files.
- **Our own CDN.** Rejected: cost, and someone has to keep it alive. GitHub Releases is free,
  and the project has no infrastructure funding yet.
