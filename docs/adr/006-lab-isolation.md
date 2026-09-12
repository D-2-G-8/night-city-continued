# ADR-006: The lab runs on a self-hosted runner with a disposable VM

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** T — Tooling

## Context

The lab's value is that it boots the **real game** on every merge request. That requires a
GPU, a licensed game install and Windows — so it cannot run on hosted CI, and it has to run
on hardware someone owns.

That is also the problem. A public repository plus a self-hosted runner is a well-known
compromise path: anyone can open a pull request, and if the runner executes what the PR
contains, anyone can run code on that machine. This project makes it worse than usual,
because mods legitimately contain **native code** (RED4ext plugins) — so "only build, never
execute" is not available either.

GitHub itself recommends against self-hosted runners on public repositories without isolation.

## Decision

Three boundaries, all of which must hold:

1. **Build in the cloud, execute in the lab.** PR code is built by hosted GitHub Actions. The
   self-hosted runner downloads **artifacts only**, never sources, and never builds.
2. **Execute only inside a disposable VM.** The VM `lab-01` is restored from the clean
   `clean-2.31` checkpoint before every run and rolled back after. It has **no outbound
   network** (internal switch only) and **no secrets** — no tokens, no accounts, no keys.
   The PR-comment token lives on the host, never inside the VM.
3. **A human starts every run.** A run requires a maintainer to apply the `lab:run` label,
   and for an outside contributor that means after reading the diff. Nothing runs
   automatically on a stranger's PR.

Nothing from an MR is ever executed on the lab host itself. `lab/runner/` is the host side and
is a security boundary; `lab/guest/` is the inside of the VM.

## Consequences

- A lab run is never instant — it waits for a maintainer. Accepted: this is the cost of
  running untrusted native code at all.
- The `lab:run` label is a privileged action, and treating it as routine is how this
  protection fails in practice.
- The VM's lack of network means everything it needs must be pushed in beforehand. Guest
  scripts cannot fetch anything.
- Maintainer attention becomes the throughput limit on outside contributions. The hardware
  limit is smaller than originally assumed — see ADR-016, which provides three concurrent
  game VMs.
- GPU partitioning was the original plan and is superseded: ADR-016 assigns a whole GPU per
  VM, which removes the uncertainty this decision depended on.

## Alternatives considered

- **Run PR code directly on the host.** Simple and fast. Rejected: it gives a stranger's
  native code full access to a personal machine.
- **Trusted contributors only.** Rejected: the lab is the main thing the project offers new
  modders, and gating it on trust defeats the purpose.
- **Build on the runner too.** Rejected — a build is code execution (build scripts, source
  generators), so this reintroduces the problem it appears to solve.
