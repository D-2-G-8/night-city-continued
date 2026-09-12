# lab/ — agent rules

The test lab runs the real game for every pull request and reports back what changed.

## Security is the first concern

PR artifacts include native RED4ext plugins — arbitrary code. GitHub advises against
self-hosted runners for public repositories precisely because of this. Our isolation:

1. **Nothing from a PR executes on the host.** The host only restores checkpoints, copies
   artifacts in, collects results out.
2. **A maintainer's `lab:run` label is required** for external contributions, after reading the diff.
3. **The VM is disposable**: restored from the `clean-2.31` checkpoint before every run.
4. **The VM has no outbound network, no tokens, no secrets, no personal accounts.**
   The PR-comment token lives on the host only.

Never weaken any of these for convenience, speed or "just this once". If a change would
let PR code touch the host, it needs an RFC.

## Structure

| Path | Runs where | What |
|---|---|---|
| `harness/` | Inside the game | Test mod: scenario execution, teleport, time of day, readiness signals |
| `runner/` | Host | Checkpoint restore, artifact push, result pull, VM lifecycle |
| `guest/` | Inside the VM | Install via `ncc`, launch the game, capture screenshots/metrics/logs |
| `scenarios/` | Data | Scenario definitions |
| `compare/` | Host | Diff against baseline, build the PR report |

## Scenario selection

Always: `smoke`. Then from the diff — changed packs run their `lab.points`, changed modules
and recipes run their declared scenarios, a `dataVersion` change runs migrations on all
golden saves, a `deps.lock.md` change runs the full regression.

## Gates vs. information

Blocking: crash or hang, redscript compile errors, new critical log errors, a save failing
to load, FPS drop beyond threshold, a failed migration.

Informational: screenshot diffs above the SSIM threshold, new warnings, and — for agent,
verb or `brain` changes — simulation metrics against baseline plus sample agent thoughts.

Never convert an informational signal into a silent pass by loosening a gate. Raising a
threshold is a decision for a human, in its own PR, with a reason.

## Throughput

One GPU means one run at a time. Smoke on PRs, full regression nightly. Keep scenarios
short and deterministic: fixed time of day, fixed weather, fixed save.
