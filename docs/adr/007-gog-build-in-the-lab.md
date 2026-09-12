# ADR-007: The lab uses the GOG build of the game

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** T — Tooling

## Context

Lab runs are only meaningful if the game is byte-identical between runs. A screenshot diff or
an FPS comparison against a baseline means nothing if the game updated itself in between.

The project pins game version **2.31, build 5294808**. The lab restores a VM from a clean
checkpoint before every run, so the game install has to survive that cycle without phoning
home, re-validating or re-patching itself.

## Decision

**The lab uses the GOG build**, installed from the offline installer.

It is DRM-free, it installs without a client, it does not auto-update, and it survives being
restored from a snapshot into a network-isolated VM — which is exactly what ADR-006 requires.

The copy is **purchased by the person who owns the machine it runs on**, and the machine is
a contributor's (ADR-016). **The VM image is never copied to anyone else's machine**,
including another maintainer's. A second lab host means another purchased copy, not a copied
image.

## Consequences

- The lab environment is reproducible, which is what makes baselines trustworthy.
- The lab tests the GOG build specifically. Differences between the GOG, Steam and Epic
  builds — if any appear — are not covered, and would be found by players on the beta channel.
- Scaling the lab to more hosts means buying more copies, by whoever owns each host.
- Players are told, in the launcher guide, to disable the game's auto-updates. The launcher
  blocks installation onto an unknown build regardless, which is the real protection.

## Alternatives considered

- **Steam.** The client wants to be running, wants to update, and complicates a network-isolated
  VM. Rejected.
- **Epic.** Same class of problem.
- **Testing on multiple stores.** Multiplies hardware, licences and run time for a difference
  that may not exist. Revisit if a store-specific bug ever appears.
