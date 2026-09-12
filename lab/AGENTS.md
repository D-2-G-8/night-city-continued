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

## A crash does not end the run (ADR-012)

A run is a sequence of steps with a cursor persisted inside the guest. When the game dies,
the supervisor captures logs and the last screenshot, marks the step `crashed`, relaunches
and continues at the next step.

- A step that crashes twice is marked `blocked` and skipped.
- Each scenario declares a relaunch budget; the run ends when steps or budget are exhausted.
- The report separates `crashed`, `blocked` and `not run`. A reviewer must never have to
  guess whether a missing result passed quietly or was never attempted.
- Every step is self-contained — load, teleport, set time, wait for streaming — because a
  step that depends on the previous one cannot be resumed into.
- Crashes remain blocking gates. Resuming changes how much a run learns, not what merges.

## Thresholds are measured before they are set

An FPS gate that has not been validated for repeatability will go red on its own. Before a
numeric gate is enabled, measure the spread across repeated runs of the *same* revision, and
set the threshold outside that spread. Record the measurement with the threshold.

The same applies to SSIM on screenshots. A visual diff is only useful when it names what it
is looking for — a black face, a gap at the neck, a missing mesh, a hole in a facade — rather
than reporting that pixels changed.

## Crowds

Several agents active near the player at once is where comparable LLM-NPC systems degrade
first: stalled conversations, agents that stop answering. A crowd scenario is standing lab
coverage for the L track, not a later refinement.

## Load order matches the player's

Run scenarios in the order `ncc` produces on a player's machine. A run against a different
order is testing a configuration nobody has.

## Throughput and hardware

Three concurrent game VMs, each with a whole GPU passed through (DDA), plus a `brain` VM with
two GPUs for inference. The `brain` VM is on the same internal switch and has **no route out**
either — a game VM testing the L track needs inference, and inference may not live on the host
or outside the isolated network. See ADR-016.

Keep scenarios short and deterministic: fixed time of day, fixed weather, fixed save. Pin each
VM to one NUMA node — cross-socket access on a dual-socket host adds frame-time variance, and
variance is what makes a numeric gate fire on its own.

Game VMs run from differencing disks off one golden parent VHDX. Storage is the binding
constraint on this host, not GPUs.

**Frame rates measured here are lower than a player's** and are regression signals only. Never
publish them as expected performance.

## The lab is not always there

It is a machine in a contributor's home. Cloud CI never depends on it. When it is down,
changes that declare lab coverage wait; documentation and non-game code merge on cloud CI
alone. There is no override that merges a game-affecting change without its lab report.
