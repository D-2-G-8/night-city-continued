# Architecture decisions

An ADR records **a decision that was made and why**, at the moment it was made. It is not
documentation of how the system works today — that is `docs/techdoc.md`.

An ADR is never quietly rewritten. If a decision changes, write a new ADR that supersedes the
old one and mark the old one `Superseded by ADR-NNN`. The reasoning that turned out to be
wrong is the most useful part of the record.

## Status vocabulary

| Status | Meaning |
|---|---|
| **Accepted** | Decided. Binding on code, review and planning |
| **Proposed** | **Not decided.** Written to record what is known, what is not, and what has to be established before a decision is possible. **Nothing may be built assuming an outcome.** A `Proposed` ADR may still carry an interim constraint, which holds precisely because the question is open |
| **Superseded by ADR-NNN** | Replaced. Kept for its reasoning |

A question that needs investigation gets a `Proposed` ADR rather than silence. An unverified
claim written as a decision is worse than an open one.

## Index

| ADR | Decision | Track | Status |
|---|---|---|---|
| [001](001-dotnet-for-out-of-game-code.md) | .NET 10 for the launcher, `brain`, the validator and lab utilities | P | Accepted |
| [002](002-github-releases-as-source-of-truth.md) | GitHub Releases is the distribution source of truth; Nexus is a mirror | P | Accepted |
| [003](003-monorepo-and-versioning.md) | Monorepo, SemVer per module, releases pinned by a manifest | P | Accepted |
| [004](004-content-is-schema-backed-data.md) | Content is schema-backed data, validated automatically | P | Accepted |
| [005](005-recipes-not-copies.md) | Third-party mods are distributed as recipes, never as copies | E | Accepted |
| [006](006-lab-isolation.md) | The lab runs on a self-hosted runner with a disposable VM | T | Accepted |
| [007](007-gog-build-in-the-lab.md) | The lab uses the GOG build of the game | T | Accepted |
| [008](008-agent-autonomy.md) | Agents are autonomous; developers never write NPC behaviour | L | Accepted |
| [009](009-releases-survive-upstream-change.md) | A release survives an upstream file changing or disappearing | P | Accepted |
| [010](010-recipe-permissions-from-upstream.md) | Recipe tiers follow upstream permissions, not the license alone | E | Accepted |
| [011](011-author-opt-out.md) | An author can leave, at any tier, without giving a reason | E | Accepted |
| [012](012-lab-runs-resume-after-a-crash.md) | A lab run resumes after the game crashes | T | Accepted |
| [013](013-named-idempotent-save-migrations.md) | Save migrations are named, recorded in the save, and idempotent | P | Accepted |
| [014](014-absorbing-game-patch-churn.md) | The platform absorbs game-patch churn instead of passing it to authors | P | Accepted |
| [015](015-world-events-may-be-directed.md) | World events may be directed; agent decisions may not | L | Accepted |
| [016](016-lab-hardware-and-topology.md) | Lab hardware and topology: whole-GPU passthrough, three concurrent runs | T | Accepted |
| [017](017-canon-is-the-default-world-mode.md) | Canon is the default world mode | L | Accepted |
| [018](018-license-allowlist-for-included.md) | License allowlist for the `included` tier | E | Accepted |
| [019](019-launcher-signing.md) | The launcher ships unsigned for 0.1.0 | P | Accepted |
| [020](020-documentation-license.md) | Documentation is CC BY 4.0; code samples are MIT | C | Accepted |
| [021](021-navigation-in-custom-interiors.md) | Navigation in custom interiors | W | **Proposed — research required** |
| [022](022-not-reimplementing-living-mods.md) | The project does not rebuild a living mod in order to replace it | E | Accepted |

ADRs 009–015 come from a review of how comparable projects and communities solved the same
problems — curated mod distributions, modding loaders that survive game patches, automated
in-game testing, and published work on LLM-driven agents. Each records what was learned and
what it changed here.

## Pending

| Decision needed | Blocks | Waiting on |
|---|---|---|
| Pilot location for the first facade → interior vertical slice | The W-track vertical slice | **ADR-021.** A one-room interior and a multi-room one need different parts of the city, so the location cannot be chosen before navigation is settled |
| First mod to carry through the full cycle as a recipe | Launch plan step 3, release 0.1.0 | Candidate survey against ADR-018 and ADR-010 |

## Writing one

Keep the shape of the existing files: Status, Date, Deciders, Track, then Context, Decision,
Consequences, Alternatives considered. State the consequences you do not like: an ADR that
lists only upsides records nothing.

An RFC in `docs/rfc/` is the discussion. An ADR is what the discussion concluded.
