# AGENTS.md — Night City Continued

Brief for any AI coding agent working in this repository. Tool-agnostic.
Claude Code reads `CLAUDE.md`, which imports this file.

## What this project is

An open-source platform that keeps Cyberpunk 2077 evolving after the last official
PC patch (2.31, September 2025). It is **not a single mod**. It is:

- a **distribution** of community mods (via recipes) plus our own modules and content packs;
- an **in-game test lab** that runs the real game for every pull request;
- a **release pipeline** with versioned updates, migrations and patch notes;
- a **launcher** that installs, updates and rolls back like a game patch.

Unofficial fan project. Not affiliated with CD Projekt Red.

Full design document: `docs/techdoc.md`. Decisions: `docs/adr/`. Proposals: `docs/rfc/`.
What a mod author is entitled to: `governance/author-rights.md`.

No track is the project's headline. Priorities come from the community (polls, then the
roadmap), and the tracks are listed in the tech doc, section 2.1.

## Environment

- **Windows only.** The game, the tools and the lab all run on Windows 11.
  Write every command for **PowerShell** (`pwsh`). Never suggest bash, WSL or macOS commands.
- Game version is pinned: **2.31, build 5294808**. Never assume a newer patch.
- Dependency versions are pinned in `deps.lock.md`. Never bump one as a side effect of another change.

## Repository map

| Path | What lives there |
|---|---|
| `core/` | redscript API, facts, save migrations, pack/recipe loader, `core/verbs/` action vocabulary |
| `modules/` | Feature modules (`residents`, `narrative`, `phone`, `systems/*`) |
| `content/` | Content packs: districts and stories. **Data only, no code** |
| `recipes/` | Recipes for community mods (see `recipes/AGENTS.md`) |
| `services/brain/` | .NET service: agent perception, memory, reflection, LLM calls |
| `launcher/` | .NET launcher `ncc`: install, update, rollback, log bundling |
| `lab/` | Test lab: harness mod, host runner, guest scripts, scenarios, comparison |
| `sdk/` | Schemas, validator CLI, templates for pack and recipe authors |
| `tools/` | `build.ps1`, `deploy.ps1`, `release.ps1` |
| `governance/` | Donation and sponsorship policy, author permissions, code of conduct |
| `docs/` | Tech doc, ADRs, RFCs, runbooks, guides, patch notes |

## Common commands (PowerShell)

```powershell
pwsh ./tools/build.ps1 -Target <module|pack|recipe:id> -Configuration Release
pwsh ./tools/deploy.ps1 -GamePath "<path to game>" -Targets core,<other>
dotnet test launcher
dotnet test services/brain
dotnet run --project sdk/Validator -- validate <path>
pwsh ./tools/release.ps1 -Release <X.Y.Z> -Channel beta
```

## Conventions

- **Branches:** `feature/<track>-<id>-<slug>`, `recipe/<mod-id>`, `release/X.Y`,
  `hotfix/X.Y.Z`, `port/cp<patch>`, `research/<slug>`. PRs target `dev`; `main` holds releases.
- **Commits:** Conventional Commits with a scope — `feat(residents):`, `recipe(example-mod):`, `fix(lab):`.
- **Versions:** SemVer per module. Releases add game-patch metadata: `0.4.1+cp2.31`.
  Schemas are versioned separately: `core-api/1`, `ncc-pack/1`, `ncc-recipe/1`, `brain api: v1`.
- **Language:** **English everywhere** — code, identifiers, comments, commits, branches,
  issues, pull requests, documentation, log and error strings, and file names. Contributors
  are in different countries; a comment a maintainer cannot read is a comment nobody can
  review. Player-facing text is localisable, with English as the source language.
- **File and directory names:** lowercase `kebab-case`, ASCII only, no spaces. Windows is
  case-insensitive and Linux CI is not, so wrong case passes locally and fails only in CI;
  macOS and Linux normalise non-ASCII names differently, so the same name arrives as two
  different byte sequences. Exceptions are only names a tool
  requires: root metadata files, `AGENTS.md` / `CLAUDE.md` / `SKILL.md`,
  `.github/ISSUE_TEMPLATE/`, `PascalCase` for .NET projects, and `snake_case` for identifiers
  inside game data.
- Full rules and per-artifact naming: `docs/guides/conventions.md`.

## Hard rules

These are not style preferences. Breaking one of these breaks the project.

1. **Never copy another author's mod into this repository** outside the recipe system.
   Open source does not mean "no copyright", and a public repo without a license grants
   no rights. Permissions are read separately from the license, and unstated means denied.
   See `recipes/AGENTS.md`, ADR-005 and ADR-010.
2. **Never write NPC behaviour.** Agents decide for themselves — see ADR-008 and
   `services/brain/AGENTS.md`. Do not add behaviour trees, schedules, goals, or a
   whitelist of "allowed" actions. Extend what agents *can* do, never what they *will* do.
3. **Never execute PR artifacts on the lab host.** Only inside the disposable VM,
   which has no network and no secrets. See `lab/AGENTS.md`.
4. **Never put anything behind money.** No early access, no donor-only builds or features,
   no paid priority. No brand placement or paid content of any kind, at any price.
   See `governance/donations.md`.
5. **Never clone the voices of the game's original actors.** Only original or licensed voices.
6. **Never change a save-data structure without a migration.** Migrations are named and
   recorded in the save, not driven by a version counter. See `core/AGENTS.md` and ADR-013.
7. **Never redistribute extracted game assets** as standalone files.
8. **Never keep a copy of a third-party mod so that a release keeps working.** An author who
   removes their work has exercised a right this project guarantees. See ADR-011.
9. **Never rebuild a living mod to replace it.** Reimplementing someone's idea is legal and
   it is not what this project does. An author declining to take part is not a reason — the
   `compat` tier needs nothing from them. See ADR-022.

## Definition of Done

- [ ] Cloud CI green: build, schemas, vanilla-node registry, license audit
- [ ] Lab: declared scenarios passed, report attached to the PR
- [ ] No new errors in redscript, CET or RED4ext logs
- [ ] If save data changed: a named migration written, golden saves load, and an `on-removed`
      path where the component can be uninstalled
- [ ] The module, pack or recipe can be disabled without breaking a save
- [ ] Patch notes and docs updated
- [ ] License and attribution preserved

## When unsure

- Ask before: changing `core-api`, any schema, save-data structures, `deps.lock.md`,
  anything in `governance/`, or the tier or permissions of a recipe.
- These need an RFC in `docs/rfc/` before code.
- For REDengine modding questions, use the modding wiki (`wiki.redmodding.org`)
  rather than guessing — it exposes `llms.txt` and markdown pages for agents.
