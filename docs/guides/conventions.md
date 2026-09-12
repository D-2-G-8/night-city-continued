# Language and naming conventions

Contributors here come from different countries and work on different operating systems.
These rules exist so that neither fact shows up as a bug.

## Language

**Everything in this repository is written in English.** Without exception:

| Where | Rule |
|---|---|
| Code, identifiers, type and variable names | English |
| Comments and docstrings | English |
| Commit messages and branch names | English |
| Issues, pull requests, code review | English |
| Documentation, ADRs, RFCs, runbooks, guides | English |
| Patch notes | English |
| Log messages, error strings, CLI output | English |
| File and directory names | English |

This is not about which language is better. A repository where half the comments are in a
language a maintainer cannot read is a repository where that maintainer cannot review, cannot
search, and cannot help. English is the language this project happens to have chosen as its
common one, and consistency is the entire value.

**Write plainly.** Many readers here are not native English speakers, including people who
wrote parts of this. Short sentences beat clever ones. Idioms do not travel.

### The one thing that is not English

**Player-facing text in the game is localisable.** English is the source language; other
languages arrive through localisation, not by writing them into source files. A hardcoded
string in any language — English included — is a bug when it is shown to a player.

Translations of the documentation are welcome and live outside this repository. The
documentation is CC BY 4.0 (ADR-020) precisely so that translating it needs no permission.

## Naming files and directories

### The rule

**Lowercase `kebab-case`, ASCII only, no spaces.**

```
governance/author-rights.md          yes
tools/hooks/validate-changed.ps1     yes
docs/adr/009-releases-survive-upstream-change.md   yes

governance/Author Rights.md          no — spaces, capitals
docs/adr/naïve-approach.md           no — not ASCII (even one accent)
tools/validateChanged.ps1            no — camelCase
```

### Why, concretely

**Case.** Development happens on Windows, which treats `Recipe.yaml` and `recipe.yaml` as the
same file. Cloud CI runs on Linux, which does not. A reference with the wrong case works on
every developer machine and fails only in CI — or worse, only for the one contributor whose
filesystem is case-sensitive. Lowercase everywhere removes the class of bug.

**ASCII.** macOS and Linux store non-ASCII filenames in different Unicode normal forms. The
same file name can arrive as two different byte sequences, and git will show a file as both
deleted and added with no visible difference between the two names. With contributors on
different systems this is not theoretical.

**Spaces.** Every shell script, every path in a manifest, and every PowerShell argument then
needs quoting, and the one place it is forgotten breaks at a distance from the cause.

### Exceptions, and only these

Every exception is a name some tool requires. There are no exceptions of taste.

| Pattern | Where | Why |
|---|---|---|
| `README.md`, `LICENSE`, `CODEOWNERS`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` | Repository and directory roots | GitHub looks for these exact names |
| `AGENTS.md`, `CLAUDE.md`, `SKILL.md` | Agent instruction files and `.claude/skills/*/` | Agent tooling looks for these exact names |
| `.github/ISSUE_TEMPLATE/` | Issue template directory | GitHub requires this exact path |
| `PascalCase` directories and files | .NET projects only — `sdk/Validator`, `Ncc.Core`, `Ncc.Cli` | .NET convention; fighting it costs more than it saves |
| `snake_case` | Identifiers inside game data: fact names, verb names, sector files | The engine's own convention — `ncc_pack_pilot_`, `go_to`, `pilot_interior_01.streamingsector` |

Adding an exception means a tool demands it. If you want one for any other reason, the answer
is no — and if a tool really does demand it, add the row here in the same pull request so the
next person does not have to rediscover why.

## Naming specific things

| Thing | Pattern | Example |
|---|---|---|
| ADR | `NNN-slug.md`, three digits, never renumbered | `011-author-opt-out.md` |
| RFC | `NNN-slug.md` | `003-navmesh-findings.md` |
| Migration | `NNNN-slug`, four digits, ordered within its component | `0007-split-relationships` |
| Patch in a recipe | `NNNN-slug.patch` | `0001-fix-load-order.patch` |
| Mod id, pack id, module id | `kebab-case`, stable forever once released | `example-mod`, `district-pilot` |
| Facts namespace | `ncc_`, `ncc_<module>_`, `ncc_pack_<id>_` | `ncc_pack_pilot_` |
| Verb | `snake_case`, imperative | `go_to`, `call_police` |
| Release manifest | `X.Y.Z.json`, pins addendum `X.Y.Z.pins.json` | `0.1.0.json` |
| Patch notes | `X.Y.Z.md` | `0.1.0.md` |
| Author permission record | `<mod-id>.md` | `example-mod.md` |
| Lab scenario | `kebab-case.json` | `residents-daycycle.json` |
| PowerShell script | `kebab-case.ps1`, verb-first | `push-artifacts.ps1` |

**Identifiers are permanent once released** (ADR-013). Fact names, pack ids, module ids and
verb names are never renamed; a rename is a new identifier plus a migration.

## Branches and commits

**Branches** — see `docs/techdoc.md` section 4.2:

```
feature/<track>-<id>-<slug>     feature/P1-decisions-and-conventions
recipe/<mod-id>                 recipe/example-mod
release/X.Y                     release/0.1
hotfix/X.Y.Z                    hotfix/0.1.1
port/cp<patch>                  port/cp2.32
research/<slug>                 research/navmesh-in-custom-sectors
```

**Commits** — Conventional Commits with a scope, in English, imperative mood:

```
feat(residents): add relationship decay between agents
fix(lab): stop the run cursor resetting after a relaunch
recipe(example-mod): bump upstream to 1.4.3
docs(adr): record ADR-022 on reimplementing existing mods
```

Pull requests are squash-merged, so the pull request title becomes the commit message on
`dev`. Write it as one.

**AI co-authorship is never recorded** in commits or pull requests. No `Co-Authored-By`
trailers, no generated-by footers.

## When a convention is wrong

Change it in a pull request, with the reason, and rename what exists — or write down why the
existing names stay. A convention that half the repository ignores is worse than none, because
it teaches everyone that the written rules are decorative.
