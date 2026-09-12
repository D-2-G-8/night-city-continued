# Night City Continued

An open-source platform to keep Cyberpunk 2077 evolving, and a shared home for modders.

Official PC support stopped at patch 2.31 in September 2025. Modding carried on, but each
author maintains their own process, their own manual testing and their own delivery. This
project puts shared infrastructure under that work:

- a **distribution** of community mods — added as recipes, never copied — alongside our own
  modules and content packs;
- an **in-game test lab** that boots the real game on every pull request and reports what
  changed, with screenshots, frame rates and logs;
- a **release pipeline** with versioned updates, save migrations and patch notes;
- a **launcher** (`ncc`) that installs, updates and rolls back like a game patch.

Unofficial fan project. Not affiliated with CD Projekt Red.

---

## Status: early

**There is no code yet.** The core, the launcher, `brain` and the lab are designed and not
written. What exists is the design, the decisions behind it, and the rules the project runs
on. Nothing here is installable.

Saying so plainly is deliberate: a demo that looks further along than the work is a debt, not
a launch.

## For mod authors

**[`governance/author-rights.md`](governance/author-rights.md)** is one page, written for you
rather than for us. The short version:

- You can have your mod removed at any time, at any tier, **without giving a reason**, and we
  keep no archival copy to keep our releases working.
- Inclusion is opt-in. We never ship your files without a permissive licence or your written
  permission.
- Downloads stay yours. For linked mods the launcher opens **your** page and waits for the
  player to fetch the file from you — no proxying, no mirroring, no caching.
- We read your stated permissions separately from your licence. If you said no modifications,
  we do not patch your mod, not even locally, not even for compatibility.
- **Declining costs you nothing.** We do not build our own version of your mod because you
  said no, and compatibility testing needs nothing from you at all.
- Nothing about your work is ever behind money.

## For contributors

Start with **[`CONTRIBUTING.md`](CONTRIBUTING.md)**.

Two rules decide whether a change can be accepted at all:

1. **Another author's mod is never copied into this repository** outside the recipe system.
   Open source does not mean "no copyright", and a public repository with no licence grants
   no rights.
2. **NPC behaviour is never written by hand.** Where the project has autonomous agents, they
   decide for themselves — no behaviour trees, no schedules, no developer-set goals, no
   whitelist of allowed actions.

Everything in this repository is written in **English**, and file names are lowercase
`kebab-case` ASCII. Contributors are in different countries and on different operating
systems; both rules exist so that neither fact turns into a bug. See
[`docs/guides/conventions.md`](docs/guides/conventions.md).

## Documentation

| Document | What it is |
|---|---|
| [`docs/techdoc.md`](docs/techdoc.md) | The full technical design — how all of this is meant to work |
| [`docs/adr/`](docs/adr/) | Architecture decisions, and the reasoning behind each |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | How to work here |
| [`docs/guides/conventions.md`](docs/guides/conventions.md) | Language and naming |
| [`governance/`](governance/) | Author rights, donations, sponsorship, code of conduct |

No track is the project's headline. Priorities come from the community — polls first, then a
public roadmap with an owner on every feature.

## Environment

Windows only. The game, the tools, the frameworks and the lab all run on Windows 11, and the
game version is pinned to **2.31, build 5294808**. The .NET parts build and test anywhere.

## Money

Nothing in this project is ever behind money. No early access, no donor-only builds or
features, no paid priority, no advertising, no paid product placement — at any price. See
[`governance/donations.md`](governance/donations.md).

## Licence

Platform code, SDK and schemas: **MIT**. Documentation prose: **CC BY 4.0**, with code samples
inside it under MIT. Third-party mods keep their own licences — those never change.
