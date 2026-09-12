# Contributing

Thanks for looking. This project is an open-source platform that keeps Cyberpunk 2077
evolving — a distribution of community mods, our own modules and content, a test lab that
boots the real game on every pull request, and a launcher that ships updates to players.

It is an unofficial fan project, not affiliated with CD Projekt Red.

> **Status: early.** The platform is being built. Some of what is described here and in
> `docs/techdoc.md` is design, not working code. If something does not exist yet, that is
> why — open an issue rather than assuming it is broken.

## Before anything else

Two rules decide whether a change can be accepted at all.

**1. Another author's mod is never copied into this repository.** Open source does not mean
"no copyright", and a public repository with no license grants no rights at all. Third-party
mods are added through the recipe system, which records the source, the hash, the license and
the author's links. See `recipes/AGENTS.md` and section 10 of the tech doc.

**2. NPC behaviour is never written by hand.** Agents decide for themselves — that is the
point of the project, not an implementation detail. No behaviour trees, no schedules, no
developer-set goals, no whitelist of "allowed" actions. Extend what an agent *can* do and
*can* perceive; never define what it *will* do. See ADR-008 and `services/brain/AGENTS.md`.

## Environment

**Windows only.** The game, the tools, the frameworks and the lab all run on Windows 11.
Every command in this repository is written for PowerShell 7 (`pwsh`).

The .NET parts — the launcher, `brain`, the validator — build and unit-test on any platform,
so a fair amount of work can be done elsewhere. Anything that touches the game cannot.

The game version is pinned to **2.31, build 5294808**, and dependency versions are pinned in
`deps.lock.md`. Disable the game's auto-updates before you start. Never bump a pinned version
as a side effect of another change — that is its own PR, and it triggers a full lab regression.

Setup instructions: `docs/guides/dev-setup.md` — being written in step 2 of the launch plan.
Until it lands, `deps.lock.md` is the list of what to install.

## The cycle

1. **Open an issue first** for anything larger than a fix. If it changes the core API, a
   schema, save data, adds a module or a system mechanic, or touches `governance/`, it needs
   an RFC in `docs/rfc/` before code.
2. **Branch** from `dev`:
   - `feature/<track>-<id>-<slug>` — a task (tracks are listed in the tech doc, section 2.1)
   - `recipe/<mod-id>` — adding or updating a mod recipe
   - `research/<slug>` — a spike
3. **Build and check locally:**

   ```powershell
   pwsh ./tools/build.ps1 -Target <module|pack|recipe:id> -Configuration Release
   dotnet run --project sdk/Validator -- validate <path>
   dotnet test launcher
   dotnet test services/brain
   ```

4. **Declare lab coverage.** Every pack, module and recipe declares at least one scenario or
   point. A change with no coverage ships untested, so it will be sent back.
5. **Open a PR against `dev`.** Conventional Commits with a scope: `feat(residents):`,
   `recipe(example-mod):`, `fix(lab):`. PRs are squash-merged.
6. **Wait for the lab.** A maintainer applies the `lab:run` label after reading the diff —
   this is a security boundary, not a formality, since a run executes built artifacts.
   The report comes back to the PR with screenshots, FPS against the baseline and log excerpts.

## Definition of Done

- [ ] Cloud CI green: build, schemas, vanilla-node registry, license audit
- [ ] Lab: declared scenarios passed, report attached to the PR
- [ ] No new errors in the redscript, CET or RED4ext logs
- [ ] If save data changed: `dataVersion` bumped, migration written, golden saves load
- [ ] The module, pack or recipe can be disabled without breaking a save
- [ ] Patch notes and docs updated
- [ ] License and attribution preserved

**Never raise a lab threshold to make a run go green.** If a threshold is genuinely wrong,
that is a separate PR with a reason, decided by a human.

## Adding a mod

You do not have to leave Nexus, change your license or give up donations. Downloads of
`linked` mods go through your own pages and count for you, and you can drop your mod to a
lower tier or remove the recipe at any time.

Which tier applies depends on the license, not on preference:

| Tier | When |
|---|---|
| `included` | License from the allowlist, or your written permission. We ship the files |
| `linked` | Redistribution not allowed, but the mod is free. We ship only the recipe |
| `compat` | Not included — a compatibility entry and a lab scenario |

Start from `recipes/AGENTS.md` and the porting guide in `docs/guides/migrate-mod.md`.

## Language

Code, comments, documentation, commits and issues are written in **English**.

## Working with AI agents

Agents are used here for drafts, review and research. The rules they follow are in
`AGENTS.md` (and `CLAUDE.md`, which imports it) — read it if you use one, because it also
binds you. Two things worth stating plainly:

- **Decisions stay with people.** An agent drafts; a human reviews and is accountable.
- **AI co-authorship is not recorded in commits.** No `Co-Authored-By` trailers, no
  generated-by footers.

## Code of conduct

`governance/CODE_OF_CONDUCT.md` applies everywhere this project has a presence.

## Money

Nothing in this project is ever behind money. No early access, no donor-only builds or
features, no paid priority, no advertising, no paid product placement — at any price.
Donations fund infrastructure and, later, recognise work already done. See
`governance/donations.md`.
