# ADR-014: The platform absorbs game-patch churn instead of passing it to authors

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** P — Platform
- **Extends:** ADR-003 (versioning), ADR-002 (distribution)

## Context

The plan for a new game patch is a `port/cp*` branch, a full regression, and compatibility
reports to authors. Every affected mod is then fixed by hand, by its own author, one at a
time. Fallout: London is what that costs at the extreme — a next-gen patch two days before
release, every mod waiting on its framework to be updated first, and a three-month delay.

Stardew Valley shows the other approach. SMAPI **detects when a mod uses a part of the game
that a patch changed and rewrites the mod so it keeps working**. It publishes a compatibility
list as a first-class artifact, and it has built-in support for unofficial updates: when a
player has an incompatible official mod, the loader itself points them at the community fix.
On the day the large 1.6 update landed, 44% of mods worked — a figure its maintainers publish
openly, alongside the admission that some changes cannot be rewritten around.

Cyberpunk 2077's own ecosystem has the same shape as Stardew's, with core frameworks —
ArchiveXL, TweakXL, redscript, Codeware — that the community updates quickly and everything
else waiting behind them.

## Decision

**When a game patch moves something, the platform adapts to it in one place, wherever it
can, rather than asking every author to adapt separately.**

Three commitments, in descending order of confidence:

### 1. The core API is a stable surface over an unstable one — committed

`core-api/N` already promises modules and packs a stable interface. That promise now
explicitly covers game patches: when a patch changes an engine symbol, path or structure that
core exposes, **core absorbs the change and the public API keeps its shape**. A module built
against `core-api/1` is not expected to know a patch happened.

This is the existing stability contract applied to a new source of change, and it costs
nothing new to promise.

### 2. The compatibility table is a product, not a byproduct — committed

A public, always-current table of every module, pack and recipe against every supported game
patch: working, degraded, broken, unknown, with the date checked and a link to the lab run.

It is generated from lab results rather than maintained by hand, it is linked from the
launcher and the site, and `ncc doctor` reads it to explain to a player why something is not
working. Until now this was mentioned only for the `compat` tier; it covers everything.

### 3. Rewriting third-party code at load time — research, not a promise

SMAPI's automatic rewriting works because .NET assemblies can be rewritten before loading.
Whether an equivalent is possible for redscript, RED4ext plugins or archive content on this
engine is **unknown and must be established by a spike** before anything is built on it.

The spike is scoped to answer one question: given a patch that renames or moves a symbol a
mod depends on, can the loader redirect it without the mod's cooperation, and for which of
the four framework layers. Until that is answered, no part of the port process assumes it.

### 4. Unofficial updates have a route — committed

When a mod is broken by a patch and its author is absent, the project can record a
community-maintained fix in the recipe and point players at it, subject to ADR-010
permissions. An abandoned mod does not silently become a `compat` entry with no path forward.

## Consequences

- The port cost concentrates on the platform maintainers instead of spreading across every
  author. That is the intent, and it makes a patch a heavier event for the core team.
- Commitment 1 means core carries patch-specific code paths. They are versioned, dated, and
  removed one major release after the patch they compensate for; otherwise core accumulates
  permanent sediment.
- The compatibility table is only as honest as the lab. An entry whose last check is old must
  display as `unknown`, never as its last known state.
- Commitment 3 may return a flat "not possible here". The decision is written so that the
  other three stand on their own if it does.
- Pointing players at unofficial fixes requires care with attribution and permissions. It is
  the author's work that broke, and their name stays on it.

## Alternatives considered

- **Pass churn through to authors** — the original plan. Honest about effort and reproduces
  the failure mode where one unmaintained framework blocks everything downstream.
- **Freeze on 2.31 permanently.** Attractive while the game is not being patched, and it
  makes the project worthless the day it is.
- **Promise SMAPI-style rewriting now.** The outcome we want, on an engine where nobody has
  demonstrated it. Promising it before the spike would put an undeliverable claim in front of
  the authors we are asking to trust us.
