---
name: lab-report-triage
description: Diagnose a failed or suspicious test-lab run — crashes, redscript errors, FPS regressions, screenshot diffs, failed migrations. Use when a lab report comes back red or a run looks wrong.
---

# Triage a lab run

Delegate large log files to the `lab-triager` subagent.

## Read in this order

1. **Which gate failed** — crash, redscript compile error, critical log error, save load
   failure, FPS threshold, migration. Each points at a different cause.
2. **`redscript_rCURRENT.log`** — compile errors first. A syntax or API error here means
   nothing else in the run is meaningful.
3. **RED4ext and CET logs** — native plugin failures usually mean a version mismatch
   against `deps.lock.md`.
4. **Screenshots** — against baseline. Missing geometry, flickering (occluders), an
   invisible wall in a doorway (collider), a black interior (no lights or reflection probe).
5. **FPS** — average and 1% low against baseline, at the same points.

## Distinguish the three causes

- **The PR is wrong** → fix the code.
- **The scenario is wrong** — non-deterministic, captures too early, stale baseline →
  fix the scenario, not the threshold.
- **The lab is wrong** — VM, checkpoint, dependency drift → file an issue against `lab/`
  and say so in the PR, so nobody "fixes" working code.

## Do not

- Raise a threshold to make a run pass. That is a human decision, in its own PR, with a
  stated reason.
- Re-run hoping for green without a hypothesis. A flaky scenario is a bug in the scenario.
- Mark a screenshot diff acceptable without looking at it.

## Output

A short verdict: which gate, which cause, the fix or the issue, with a link to the run
artifacts.
