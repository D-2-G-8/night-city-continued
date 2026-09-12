# ADR-016: Lab hardware and topology

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** T — Tooling
- **Extends:** ADR-006 (lab isolation), ADR-007 (GOG build), ADR-012 (runs resume)

## Context

The lab needs a Windows machine with a GPU that can be reset to a known state before every
run. The design assumed a single graphics card, which forced two compromises: GPU
partitioning (GPU-P) to share one card with a VM, and a throughput model of one run at a time.
GPU-P for a running game was an open spike with no fallback except a bare-metal machine
restored from a disk image between runs.

A machine has become available: dual AMD EPYC 7763 (128 cores / 256 threads), 512 GB RAM,
2 TB SSD, and **five discrete RTX 5060 Ti 16 GB cards**.

It belongs to a contributor and sits in their home. They are a participant in the project,
not a vendor.

## Decision

### Whole-GPU passthrough, not partitioning

With five discrete cards there is no reason to share one. The lab uses **Discrete Device
Assignment (DDA)** — a whole GPU assigned to a VM — on Windows Server with Hyper-V.

This replaces the GPU-P spike. The remaining question is narrower and well-trodden: whether a
consumer NVIDIA card behaves correctly as a passed-through device under Hyper-V. It is
verified once, during environment setup, not researched.

### Card allocation

| Cards | Role |
|---|---|
| 3 | Game VMs — three concurrent runs |
| 2 | A `brain` VM — nightly agent simulation, and inference for game runs |

**The `brain` VM sits on the same internal switch as the game VMs and has no outbound network
either.** ADR-006 forbids a lab VM reaching the internet; a game VM testing the L track still
needs inference, so inference lives on an isolated peer, never on the host and never outside.

### Throughput

The previous model — one run at a time, FIFO — is replaced. Three game VMs run concurrently,
so smoke runs on pull requests stop queueing behind each other. Full regression still runs
nightly, and `hotfix/*` still takes priority.

### Storage is the binding constraint

2 TB is the smallest resource here, not the GPUs. Game VMs use **differencing disks from one
golden parent VHDX**: a single installed-and-pinned game image, with thin per-VM children.
Copying a full install per VM does not fit alongside checkpoints, models and golden saves.

With 512 GB of RAM, transient run artifacts can live on a RAM-backed volume rather than the
SSD.

### The lab measures deltas, not player performance

EPYC 7763 is a server part: 64 cores at a 2.45 GHz base. This game is sensitive to
single-thread performance, so **absolute frame rates here will be lower than on a player's
desktop**.

That is acceptable because a lab run compares against a baseline measured on the same
hardware. It has two consequences that are not optional:

- **Frame rates from lab reports are never published as expected player performance.** They
  are regression signals.
- **Each VM is pinned to one NUMA node.** On a dual-socket machine, cross-socket memory
  access adds frame-time variance, and variance is what makes a numeric gate fire on its own
  (ADR-012 requires thresholds be measured before they are set — pinning is what makes that
  measurement stable).

### The host belongs to a contributor

- **The game copy in the lab is purchased by the person who owns the machine**, installed
  from the GOG offline installer. ADR-007's rule is unchanged and now matters more: **the VM
  image is never copied to another person's machine.** A second lab host means another
  purchased copy, not a copied image.
- The host is operated by a named maintainer, who has physical access. The `lab:run` label
  stays a maintainer action, and the PR-comment token lives on the host and never inside a VM.
- **Hardware contributed by a participant is disclosed in the monthly report and grants no
  influence over the roadmap** — the same rule as any infrastructure sponsorship. Maintainer
  standing comes from the work someone does, never from the hardware they own.
- Electricity is a real cost borne by a person. It is a legitimate infrastructure expense for
  funding stage A, on the same terms as hosting.

### Availability is not guaranteed

A machine in someone's home loses power, reboots, and goes offline. The lab is therefore
**not a dependency of the cloud pipeline**: builds, schema validation, license audit and .NET
tests run in hosted CI and are unaffected by the lab being down.

When the lab is unavailable, changes that declare lab coverage wait. Documentation and
non-game code, which declare none, merge on cloud CI alone. There is no override that merges
a game-affecting change without its lab report.

## Consequences

- The staged lab plan — manual runs, then automation without a VM, then full isolation — is
  obsolete. Full isolation is available immediately, which means **external contributions can
  be accepted from the start** rather than waiting for isolation to exist.
- The GPU-P spike is closed. The bare-metal-with-image-restore fallback is not needed.
- Three concurrent runs change what is affordable on a pull request. Scenario selection can be
  broader than the original "smoke only on PRs".
- The nightly agent simulation has 128 cores and two dedicated GPUs. Inference cost shifts
  from API billing to electricity and wall-clock, which is a materially better position than
  the published generative-agents figures assume.
- Combined draw under load is well over a kilowatt. That is a constraint on a domestic
  electrical circuit and on the room the machine is in.
- The project's infrastructure now depends on one person's goodwill and one person's house.
  That is a real dependency and it is recorded here rather than assumed away.

## Alternatives considered

- **GPU-P on a single card**, as originally planned. Unnecessary with five cards, and it was
  the least certain part of the lab design.
- **Bare metal with disk-image restore between runs.** The fallback for a single-GPU machine.
  Slower, and it gives up the VM boundary that ADR-006 depends on.
- **A rented cloud GPU server.** Removes the dependency on one household and introduces a
  different problem: installing a personally purchased game on rented infrastructure is not
  clearly within its terms, and ADR-007 deliberately avoids that ambiguity.
- **All five cards to game VMs.** More concurrency, and inference would have to run on the
  host or outside — both of which break the isolation ADR-006 exists to provide.
