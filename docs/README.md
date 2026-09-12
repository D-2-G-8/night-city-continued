# docs/

| Path | What it holds |
|---|---|
| `techdoc.md` | The full technical design document — the source of truth for how this project is meant to work |
| `adr/` | Architecture decisions, numbered `NNN-slug.md`. An ADR records a decision and why; it is not rewritten, it is superseded |
| `rfc/` | Proposals under discussion, and spike reports |
| `runbooks/` | Procedures a human follows: cutting a release, porting to a game patch, recovering the lab |
| `guides/` | How-to documentation: dev setup, opening a PR, reading lab reports, porting a mod, the player-facing launcher guide |
| `patch-notes/` | `X.Y.Z.md`, one per release — **written for players, not in the language of commits** |

An RFC is required before code for: a new module, a change to the core API or any schema,
a new system mechanic, anything touching save data, and any policy change in `governance/`.
