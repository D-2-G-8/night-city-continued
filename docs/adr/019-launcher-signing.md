# ADR-019: The launcher ships unsigned for 0.1.0

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** P — Platform
- **Extends:** ADR-002 (GitHub Releases as source of truth)

## Context

`ncc` is a Windows executable downloaded from the internet. Without an Authenticode
signature, SmartScreen warns the player before it runs, and the warning is worded strongly
enough that some people stop there.

Signing has become harder rather than easier. Organisation-validated certificates now require
the key to live on a hardware token or in a cloud HSM, which turns CI signing into a
provisioning problem on top of an annual cost the project has no funding for. SmartScreen
reputation also accrues with downloads, so an early release gets the least benefit from a
certificate at the moment it is most expensive.

## Decision

**0.1.0 ships unsigned.** Instead:

- The player-facing launcher guide states plainly that the warning will appear, why, and what
  to click. No euphemism: the executable is unsigned, and that is what Windows is reporting.
- Every release publishes **SHA-256 checksums and a minisign signature** for the launcher
  itself, alongside the signed release manifest. Verification is possible for anyone who wants
  it, and the instructions are in the guide.
- **Azure Trusted Signing is evaluated before 1.0.** It changed the economics of code signing
  and may be affordable at this project's scale; eligibility requirements need checking
  against the project's legal standing.
- The decision is revisited at 1.0, or earlier if download volume makes the warning the main
  obstacle to adoption.

## Consequences

- Some players will not get past the warning. That is a real loss of reach, taken knowingly.
- Telling players to click through a security warning is a habit worth being uncomfortable
  about. The checksums exist so that the instruction is "verify this, then proceed" rather
  than "ignore Windows".
- An unsigned binary from an unknown project is exactly the shape of a malicious download.
  Distribution therefore stays on GitHub Releases (ADR-002), where the artifact's origin is
  visible, rather than on mirrors.
- When signing does arrive, the key becomes the second most sensitive secret after the
  minisign key, and it will need the same treatment: release environment only, never on the
  lab host.

## Alternatives considered

- **Buy an OV certificate now.** A few hundred a year plus token logistics, spent before the
  project has a first release or any funding. Stage A funding exists for infrastructure, and
  this is a candidate once it is running.
- **An EV certificate**, which SmartScreen trusts immediately. More expensive still, and
  requires organisational identity the project does not yet have.
- **Ship the launcher as a script instead of an executable**, sidestepping SmartScreen.
  Trades a warning for a worse install experience and a dependency on a runtime the player
  must install first.
