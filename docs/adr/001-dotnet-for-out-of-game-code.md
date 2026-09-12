# ADR-001: .NET 10 for the launcher, `brain`, the validator and lab utilities

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** P — Platform

## Context

Four things live outside the game process and need a language: the `ncc` launcher, the
`brain` service behind autonomous agents, the SDK validator, and the lab's host and guest
utilities.

All four share the same concerns — release manifests, SHA-256 hashes, minisign signatures,
structured logs, semantic version ranges. Writing those four times in four languages means
the launcher and the release tooling can disagree about what a valid manifest is, which is
exactly the kind of bug that ships a broken release.

The target platform is Windows only. The multiplayer track (M1) is expected to build on
CyberpunkMP, which exposes a **.NET SDK** for server plugins.

## Decision

**.NET 10 for everything that runs outside the game process.** One solution, shared
libraries for manifests, hashing, signatures and logging.

In-game code stays redscript (core, modules, migrations) with CET Lua for debugging and the
lab harness. This ADR does not touch those.

## Consequences

- Manifest handling has exactly one implementation. The launcher and `tools/release.ps1`
  cannot disagree about it.
- `brain` can later move into a CyberpunkMP server plugin without a rewrite, because that
  SDK is .NET. This is the main reason not to pick Python or Go for the agent service.
- The launcher ships self-contained (`--self-contained -p:PublishSingleFile=true`), so
  players do not install a runtime. That costs tens of megabytes per release.
- Contributors need the .NET SDK to work on these parts. That is a real barrier for modders
  whose background is Lua and redscript, and it is the price of this decision.
- These components build and unit-test on any platform, which matters more than expected:
  the project's day-to-day machine is a Mac, and this is the work that can happen there.

## Alternatives considered

- **Python for `brain`.** Best LLM ecosystem, and the fastest thing to prototype in. Rejected
  because it strands the CyberpunkMP path and adds a second runtime for players to install.
- **Rust.** Attractive for the launcher. Rejected: a smaller intersection with the modding
  community, and no CyberpunkMP SDK.
- **PowerShell for the lab utilities only.** Partly kept — the orchestration scripts in
  `tools/`, `lab/runner/` and `lab/guest/` stay PowerShell, because they drive Hyper-V and
  the filesystem. Comparison and reporting logic is .NET.
